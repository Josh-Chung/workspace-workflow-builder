---
id: print-output
scope: "Press-file rules for artifacts that deliver a PDF to a printer: font type on the generation side, the outlining remedy and where it sits in the pipeline, and the preflight criteria that verify both"
read-when: "Building or reviewing any artifact whose output is a press file (a PDF handed to a print shop)"
depends-on: [visual-presentation]
priority: P1
tags: [print, prepress, pdf, fonts, preflight]
---

# Print Output Rules (Press-File Fonts & Verification)

> **Scope:** Rules an instruction artifact must carry when the thing it
> produces is a **press file** -- a PDF a print shop images onto plates.
> Adapt the wording to the target artifact's domain; preserve every rule,
> every command, and every threshold.

---

## Applicability (this file is binding only when the condition holds)

**Binding** when the artifact's output is a PDF sent to a printer: brochure,
manual, card, poster, packaging, any piece that ends up on paper.

**Not binding** for a PDF that is only ever viewed on a screen, for web pages,
or for slides. A screen PDF may do everything this file forbids and be correct.

**Layered on top of `visual-presentation.md`, not a replacement for it.** That
file governs what the page looks like (color, grouping, the fine-stroke plate
limit). This one governs whether the file the shop receives can be imaged at
all.

---

## Why this file exists

A viewer is forgiving; a RIP is not. It is an older, stricter, more literal
interpreter, and it is the only reader whose verdict matters. A file can be
correct on every screen it was ever opened on and still come back from the shop
as *"the fonts do not show, please convert to outlines."*

The trap that produces that sentence is **Type 3**. PDF has several font
subtypes, and they are not equally welcome:

| Subtype | What is embedded | Standing at a print shop |
|---|---|---|
| Type 1 / Type 1C (CFF) | Adobe outline format | Excellent |
| TrueType | Quadratic outlines with hinting | Excellent |
| Type 0 (composite) + CIDFontType0/2 | A CID-keyed font, two-byte addressed | **The correct form for CJK** |
| Type 3 | No font program -- each glyph is a small PDF content stream | Legal, embedded by definition, and the one that breaks presses |

A Type 3 font reports `emb yes`. It is often genuine vector artwork, so nothing
about the page quality is at risk. It is still the file the shop rejects: many
preflight profiles flag it as an error, it usually carries no `BaseFont` (tools
list it as `[none]`, which reads as a missing font), and its `FontBBox` can clip
every glyph away on a RIP that reads the box differently.

Nobody chooses Type 3. A generator falls into it silently. **That is why the
check belongs in preflight rather than in anyone's memory: the font type of a
press deliverable is a property you verify, not one you inherit.**

---

## P1 -- The generator must emit a real font program

Browser-to-PDF pipelines are the common source, and Chrome/Skia is what both
`pagedjs-cli` and headless `--print-to-pdf` drive underneath. Skia embeds a
**static TrueType** face as Type 0 / CIDFontType2. For anything else it gives
up and emits Type 3. Three triggers, all common:

- **CFF-flavoured OpenType** (`.otf`), including CID-keyed CJK families
- **Variable fonts**
- **A weight the browser has to synthesize** because no face was declared for it

So, in the artifact's build stage:

- **Bundle every face with the project**, and declare it with `@font-face`. A
  system-installed font is a silent dependency: a missing face does not error,
  it falls back, and every figure changes shape with no warning.
- **Every bundled face is static TrueType.** Many families ship one (`.ttf`
  alongside the `.otf`); prefer the build from the same release so metrics and
  advance widths do not move.
- **Declare every weight the CSS sets, explicitly.** Never leave the browser to
  synthesize one.
- **Name a bundled CJK family so it cannot collide with the system copy**
  (e.g. `"NotoSansSC"` against the system's `"Noto Sans SC"`).
- **If only a variable or CFF source exists**, instance and subset it to static
  TrueType -- fontTools `instancer.instantiateVariableFont` then
  `subset.Subsetter` -- and track the generated faces rather than rebuilding
  them from a machine's font folder. Keep licence name IDs (0-7, 13, 14) when
  subsetting a redistributed face; the default drops 13 and 14, which is where
  the licence text lives.
- **Subset to every character the piece actually sets, including its spaces.**
  U+0020, U+00A0, and U+2003 are glyphs like any other. One uncovered character
  makes the browser fall back to a system face and Type 3 returns *for that
  character alone* -- and nothing upstream of preflight can see it.

**Fallback when the generator cannot be fixed** (the render environment offers
only a CFF or variable face, or the shop refuses fonts of any kind): P2.

---

## P2 -- Outlining is a remedy, and it runs last

Outlining (`转曲`, *create outlines*) replaces every glyph with the plain vector
shape it draws. Afterwards the page has no text objects and no font resources
at all. It is the strongest guarantee that type reproduces as designed, and it
is irreversible: the text stops being searchable, selectable, and correctable.

**Fix the generator first (P1).** Outlining is a legitimate remedy and a poor
default. It is the *only* remedy for Type 3 -- no tool can promote a Type 3
font back into a real one, because the original font program is gone.

```bash
gs -dBATCH -dNOPAUSE -dQUIET -sDEVICE=pdfwrite \
   -dNoOutputFonts \
   -dCompatibilityLevel=1.7 \
   -dPreserveOverprintSettings=true \
   -sColorConversionStrategy=LeaveColorUnchanged \
   -sProcessColorModel=DeviceCMYK \
   -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode \
   -dAutoFilterGrayImages=false  -dGrayImageFilter=/FlateEncode \
   -dDownsampleColorImages=false -dDownsampleGrayImages=false \
   -dDownsampleMonoImages=false \
   -sOutputFile=piece-cmyk-outlined.pdf piece-cmyk.pdf
```

**The input is the CMYK file, never the RGB intermediate.** Outlining before the
color conversion is the obvious placement and it is wrong. The extra `pdfwrite`
round-trip moves the source RGB about 0.4%, and any conversion step that matches
colors against a recorded table then misses them. Measured on one book: 0.75pt
table keylines that should separate to K only came out C51 M44 Y42 -- four
plates on a 0.26 mm line, the exact defect the fine-stroke rule exists to
prevent -- across 1183 fills, with nothing on the page looking wrong. Run after
the conversion and no color transform happens at all: the file is already
DeviceCMYK and the pass is `LeaveColorUnchanged`.

**Ghostscript drops `/OutputIntents`.** Re-stamp the output intent after the
pass, and re-check it; a rewrite is exactly where output intents, ICC profiles,
and page boxes go missing.

**Verify the result, do not trust it.** All four, every time:

| Check | Pass condition |
|---|---|
| Font objects | zero, reachable from any page |
| Extractable text | `pdftotext -raw` returns nothing. Fonts removed while the text operators stay behind renders a **blank page** that every geometric check still passes |
| Page boxes | MediaBox / TrimBox / BleedBox unchanged, to 0.01pt -- otherwise the shop cuts in the wrong place |
| Ink drift | every CMYK color operator in the output within **0.002** of the nearest one in the input. A color that is not near anything the source contained means a conversion ran where none should have |

**Ship both editions.** The outlined file goes to press; the readable file (same
artwork, glyphs still in fonts) is kept and is not merely an archive -- any
preflight check that reads text cannot run on an outlined file at all. Suffix
*both* names, never leave one unsuffixed: the shop picks files by name.

---

## P3 -- The font `type` column is a criterion, not a note

`pdffonts` prints `name type encoding emb sub uni object ID`. Read the columns
**positionally, by slicing from the header row**. A font reported as `[none]` --
which is every Type 3 font -- yields fewer whitespace tokens and shifts every
later field by one, so splitting on whitespace silently reads the wrong column.

**Readable edition:** every row has `emb = yes` **and** a `type` in

```
CID TrueType, CID Type 0, CID Type 0C, TrueType, Type 1, Type 1C
```

Anything else fails, `Type 3` included. An **empty** font list also fails here:
an edition that should carry live text and has no fonts is a file whose text has
gone missing.

**Outlined edition:** zero font rows, and `pdftotext` returns nothing. Gate this
edition on its own terms; do not run the readable edition's criterion against it.

**`emb` is not the criterion.** A Type 3 font is embedded by definition and
reports `emb yes`. Checking embedding alone is what lets the defect through.

**If a build still emits Type 3 and must ship anyway,** additionally sample the
`CharProcs` streams for inline-image operators (`BI` / `ID`). That answers
whether the file is merely non-compliant or actually unprintable -- a Type 3
built from bitmaps prints at whatever resolution it was baked at. It does not
make the file pass. Vector-ness answers a *quality* question; the type column
answers a *compatibility* question, and both must be yes.

---

## Self-check before calling a file press-ready

- [ ] Every face is bundled with the project and declared by `@font-face`; no
      face is picked up from the machine's font folder.
- [ ] Every bundled face is static TrueType, and every weight the CSS sets has
      its own declaration -- nothing is synthesized.
- [ ] The subset covers every character the piece sets, spaces included.
- [ ] `pdffonts` read positionally: every row `emb = yes` and every `type` in
      the allowed set. Zero Type 3 rows.
- [ ] If outlined: the pass ran on the CMYK file, the output intent was
      re-stamped, and all four output checks pass (0 fonts, 0 extractable
      characters, boxes unchanged, ink drift <= 0.002).
- [ ] If outlined: both editions exist and both filenames say which is which.
- [ ] The preflight report states the observed font types, not just "embedded".
