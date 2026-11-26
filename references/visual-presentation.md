---
id: visual-presentation
scope: "Direction, token, color, structure and display rules for artifacts whose output contains visual content: direction proposed before building with named defaults avoided, total tokenization and role-based naming, restricted value sets per dimension, default Morandi palette, main-color extraction, derived-tone discipline, hierarchy, spacing, alignment, type scale, set classification, nested-figure display"
read-when: "Building or reviewing any artifact whose output includes visual content (diagrams, charts, slides, documents, web pages, print pieces, UI)"
depends-on: []
priority: P1
tags: [visual, color, palette, layout, presentation]
---

# Visual Presentation Rules (Tokens, Color, Structure & Categorized Display)

> **Scope:** Rules an instruction artifact must carry when the thing it
> produces is *seen* -- not when it merely produces text. Adapt the wording to
> the target artifact's domain; preserve every rule and every threshold.

---

## Applicability (this file is binding only when the condition holds)

**Binding** when the artifact's output is a composed visual: diagram, chart,
slide, poster, print piece, web page, UI, illustrated document, generated
image, or any layout where a reader perceives grouping and hierarchy.

**Not binding** for text-only output: prose, code, logs, CLI output, plain
data files. Do not carry these rules into an artifact that renders nothing.

**Once binding, every family inside binds together.** There is no sub-condition
and no partial adoption: an artifact that carries this file carries Direction
(what the piece starts from), T (how values are stored), C (which colors), H
(how the piece is arranged) and D (how sets are drawn). A single diagram is not exempt from the token rules -- T5's
scope note states why that exemption is refused here.

---

## Precedence (settle color conflicts in this order)

1. **A confirmed source or brand color wins** (rule C2). A brand token, a
   design-system value, or a color read off a supplied element is the element's
   real main color; never overwrite it with a default.
2. **Morandi fills every gap** (rule C1) -- surfaces, grouping geometry,
   dividers, and anything else the workflow invents on its own.
3. **The color budget (C3) applies to the result of 1 + 2 combined**, not to
   each source separately.

---

## Direction (settle it before the first value is chosen)

A brief with no visual direction, or only adjectives ("modern", "clean",
"minimal"), does not leave the look open. It hands the look to the model's
house style, and a general instruction such as "avoid a generic look" only
swaps one house style for another. So:

- **Propose, then build.** When the brief names no direction, or only
  adjectives, propose 3-4 distinct directions before building -- each as
  ground color / accent color / typeface / a one-line reason tied to the brief
  -- and let the user pick. If the user has asked you not to wait ("generate
  now"), pick one yourself, name it and the reason in one line, and build it.
- **Named defaults are choices, not starting points.** Unless the brand, the
  user, or a stated reason calls for them, do not reach for: a cream or
  off-white ground, italic accent words in headlines, numbered "01 / 02 / 03"
  section labels, monospace labels, or pill-shaped buttons.
- The Precedence above still holds: a brand or source color wins, and Morandi
  fills the gaps. Direction decides which of those legal choices the piece
  starts from; it never licenses a color the Precedence rules out.

---

## Token rules (how every value in this file is stored)

Everything else here decides *values*; these decide how they are **stored**.
They bind wherever this file binds -- no piece is too small, and there is no
"mostly tokenized" state to aim at: a rule with unmarked exceptions cannot be
reasoned with or checked.

### T1 -- Every design decision is a named token

No raw color, length, size, weight, radius, shadow, or duration appears in the
**composed layer** -- the stylesheet, template, component, or drawing
instruction that renders the piece. Each refers to a name defined in one place.

**Is this value a decision?** *Could someone legitimately want it changed
across the whole piece?* If yes, it needs a name.

**Not decisions, so not tokens:** a circle's 50% radius, an aspect ratio, a 1px
hairline that is the smallest renderable line, a value computed from a token, a
structural number inside one self-contained widget. Naming these buries the
real decisions in noise.

Three elements each holding a bare grey are three facts with no stated
relationship: the token name is the only surviving record of what a value
*meant*, and nothing later can recover it.

### T2 -- Fix the legal value set for every dimension, not for color alone

C1-C3 restrict color. Apply the same discipline to every other dimension, and
fix each set **before** building:

| Dimension | Set | Note |
|-----------|-----|------|
| Spacing | 5-7 ratio steps (e.g. 4, 8, 12, 16, 24, 32, 48) | Steps grow, so no two gaps land 3px apart |
| Type size | <= 7 steps (H4) | Each step has a named job |
| Font weight | <= 3 | Regular, medium, bold is complete |
| Corner radius | 1-3 across the piece | Every D3/D4 figure shares **one** of them -- T2 sets the vocabulary, D4 fixes which one the figures use |
| Shadow / elevation | <= 2 levels | Unnamed shadows put two modals on different planes |
| Border width | <= 2 | Print pieces: also bound by C4 |
| Motion duration | <= 3 | Only when the output moves |

**A value outside its set may not be typed.** Ratio steps are already in
proportion, so harmony becomes a property of the set rather than something
achieved per view. Spacing is the set most often improvised, so start there.

### T3 -- Name by role, not by appearance

- **Primitive** -- a position in a set: `--grey-700`, `--space-4`,
  `--radius-sm`. Means nothing on its own.
- **Semantic** -- a *role* pointing at a primitive: `--surface`,
  `--content-muted`, `--border-divider`, `--danger`, `--space-group-gap`.

**The composed layer consumes semantic tokens.** Reaching past the role for a
primitive (`--grey-700` on a caption) loses the re-pointing: no role is left to
swap when the theme, brand, or contrast requirement changes. A token named for
appearance becomes a lie the day the value changes -- `--red-500` when the
brand turns orange.

**Keep the semantic layer small:** the fewest roles that describe the piece. A
name per component per property is a maze people route around by typing values
again, failing T1 through the back door.

### T4 -- An exception is added to the system by name

A value with no token is never typed inline. Two legal moves: add it to the set
as a **named** exception, or change the design so an existing token fits.
Deviation is allowed -- contexts differ -- but a named one can be found and
argued with; a silent one cannot.

### T5 -- The target is 100%, and 95% is not 95% of the benefit

At partial coverage a global change is still a values edit **plus** a full
manual audit, because the leftovers are unmarked -- and that cost barely falls
between half and nearly-all, reaching zero only at total. Total is also the
only checkable target: no scan can tell an approved holdout from a lapse, so
anything less falls back on vigilance, which decays.

**The check (an empty result is the pass):** scan the composed layer for raw
values and report the observed count, never an impression. A portable form,
run from the project root with the include list and the token file adjusted to
the stack:

```sh
grep -rnE '#[0-9a-fA-F]{3,8}\b|\b(rgba?|hsla?)\(|\b[0-9]+(\.[0-9]+)?(px|rem|pt|mm)\b'   --include='*.css' --include='*.scss' --include='*.html' .   | grep -v 'tokens.css'
```

Every hit is either a defect or one of T1's structural constants. A hit left
standing is **named in the report with its reason** -- that is what makes the
count a decision rather than a number. Where the stack supports it, a lint rule
(`stylelint`'s `declaration-property-value-disallowed-list`) is the stronger
form, because it fails the build instead of producing a number someone has to
read. Wire whichever form into the project's CI: this file governs the
artifact, but only the project's own pipeline can enforce the scan.

Coverage of *badly named* tokens is worse than lower coverage of well-named
ones: a name that lies is consulted and believed.

> **Scope note.** The wider literature exempts the genuine one-off. This file
> refuses that exemption -- a conditional rule needs a step that decides its
> condition before anything can check it, and a piece whose "one-off" status
> was guessed at is exactly the piece that ships raw values.
---

## Color rules

### C1 -- No main color of its own -> use the Morandi system

When elements carry no inherent color, or every element on the canvas is
generated by the workflow itself, draw all color from the Morandi palette
below. Do not invent a palette; do not reach for saturated defaults
(pure `#FF0000`, framework primary blues, chart-library default cycles).

### C2 -- Elements carry a main color -> extract it

When the elements themselves have a main color -- a photograph of green trees,
blue sky, a person in red clothing, a product shot, an existing brand palette,
a logo -- extract that color from the element and build the piece around it.
The extracted value is used as found; it is not "corrected" toward Morandi.

**Overflow fallback:** if the set carries more distinct main colors than the
C3 budget allows, do not use them all. Fall back to C1: render the piece in
Morandi and let the elements' own colors read only inside the elements
themselves (inside the photo, inside the logo).

### C3 -- Derive tones; never add hues

**Count base colors, not tones.** Tints, shades, and transparency variants of a
base color do not count as additional colors. Pure white and pure black do not
count either -- they are the substrate and the ink, not extra colors to spend.

**Whether to use them is a judgment call, and the user's preference outranks
it.** Reach for black where the piece genuinely reads better for it; leave it
alone where it does not. Two things are not judgment calls. First, a dark that
occupies area **belongs to a ramp**: pure black may be the bottom step of a
base's ramp, but it may not float free as the only dark in a piece with no base
to descend from. Second, black must be **chosen** -- `#000` is the default
stroke, border, and text color of nearly every tool, so a black that arrived
because nothing decided otherwise is a default, not a decision.

- **Budget:** 1-2 base colors is the normal case. **3 is the hard maximum.**
- **To get more tones, move lightness, not hue.** Take the base color and
  slide it along the value axis -- the vertical light/dark bar beside a color
  picker's hue field, which keeps hue and saturation fixed and only changes
  brightness. Equivalently: lower the opacity of the base color over the
  surface behind it.
- **The palette bounds cap base colors, not the ramp.** The membership test
  below decides which *base* colors may enter the piece; it does not limit how
  far a ramp travels. Once a base is admitted -- a Morandi swatch under C1, or
  an extracted main color under C2 -- its lightness and transparency steps may
  run the full range, including darker than the palette's 35% lightness floor
  and lighter than its 95% ceiling. Stepping deeper than any swatch is the
  intended way to buy headroom for reversed (knockout) text. A derived step is
  still bound by two things: keep hue and saturation fixed (move value or
  opacity only), and verify contrast on the step you actually used.
- **A ramp, not a rainbow.** Build 3-5 steps from one base color (e.g. base,
  base at 70% lightness, base at 40% lightness, base at 15% opacity) and treat
  that ramp as the piece's whole vocabulary of that color.
- Two elements that must be told apart are told apart by a *step on the ramp*
  first, and by size, spacing, or layout second -- adding a fourth hue is not
  an available move.

**If the output will be printed:** a color mixed from several ink plates
fringes along fine strokes whenever the press mis-registers, and a thin stroke
is too narrow to hide the fringe. Keep every stroke below **1pt (0.35mm)** --
rules, dividers, table keylines, borders, fine line art, and the field behind a
reversed (knockout) hairline -- on a color that separates to **at most two ink
plates**; black-only is the safe default. Multi-plate colors stay on fills and
on type at body size or larger. A plate-reduced variant of a base color is a
production derivative of that base, not a new base color: it does not count
against the budget.

---

## The Morandi palette (36 swatches, sRGB)

Muted, grey-mixed, low-chroma. Use these values verbatim.

| | | | | | |
|---|---|---|---|---|---|
| `#D7CBB1` | `#C4B8A2` | `#C0CAD6` | `#ADB1B4` | `#DEE3DD` | `#B6C5B2` |
| `#B4B0A4` | `#A2998A` | `#8895A8` | `#A0A5B9` | `#96A28C` | `#7B876F` |
| `#DFD3D7` | `#656364` | `#935256` | `#6A4D52` | `#EFEAE4` | `#CCC2B8` |
| `#D3D2CE` | `#E1CDCF` | `#A3787F` | `#ECCFD4` | `#FBEAD6` | `#C7B6A6` |
| `#FCFAED` | `#ECEBE7` | `#A7A6AB` | `#7B7581` | `#929093` | `#BFBDBE` |
| `#DAD9D7` | `#F6E9D9` | `#C7C0D0` | `#EDE6F6` | `#EEECED` | `#568493` |

**Membership test -- base colors only (use when deriving a new base swatch, or
when checking whether an extracted C2 color sits harmoniously beside these;
C3 ramp steps off an admitted base are exempt):** a Morandi-family color
has an RGB chroma spread -- `max(R,G,B) - min(R,G,B)` -- of **<= 65, and
typically <= 45**, with lightness between **35% and 95%**. A *new hue* outside
that band reads as a saturated intruder next to these swatches; a lighter or
darker step of a base already in the piece does not -- it reads as depth.

### Picking by role

**The bands below are alternatives, not a shopping list.** C3 still governs:
pick your 1-2 base colors first, then use the bands to place *their* tones --
the lightest step for the outer surface, the darkest for text and the innermost
nesting level. Reaching across bands for a genuinely different hue is only
available while the piece is still under the 3-color budget. Pure white and
pure black do not count against that budget (C3), but they are not palette
members either: a Morandi near-neutral such as `#EEECED` or `#929093` is a
color and counts like any other. The four bands describe the palette's own
range, not the reach of a ramp: a base's darkest step may sit below the dark
band, and its lightest above the lightest band (C3).

| Role | Draw from | Examples |
|------|-----------|----------|
| Page / canvas surface, outermost container | lightest band (L > 85%) | `#FCFAED` `#EEECED` `#EFEAE4` `#F6E9D9` `#EDE6F6` |
| Nested container fills, set backgrounds | light-mid band (L 70-85%) | `#DEE3DD` `#D3D2CE` `#CCC2B8` `#C7C0D0` `#DFD3D7` |
| Element fills, the working body of the piece | mid band (L 55-70%) | `#C4B8A2` `#ADB1B4` `#8895A8` `#A0A5B9` `#96A28C` `#B4B0A4` |
| Text, borders, deepest nesting level, accents | dark band (L < 50%) | `#656364` `#7B876F` `#7B7581` `#6A4D52` `#935256` `#568493` |

**Contrast is not optional.** Every swatch above clears 4.5:1 against either
black or white text -- but only against one of them. Pick the text color per
swatch and verify the ratio; never assume a Morandi background is safe for
whichever text color the template happened to default to.

---

## Structure rules (what a value set cannot decide for you)

C1-C3 and T1-T5 buy coherence -- the floor. A perfectly tokenized piece with no
hierarchy is *uniformly* unreadable. These decide the arrangement the tokens
are spent on.

### H1 -- Rank first, then subtract

Before styling anything, name what the reader should see **first**, second,
third. The ranking is a claim about the reader's task, not about what the
commissioner most wants noticed.

- Express the top rank in **at most two** channels: size, weight, lightness,
  position, isolation. Bigger *and* bolder *and* colored *and* uppercase gives
  one loud element and three spent channels, not four times the rank.
- **Emphasis is bought by subtraction** -- the primary element earns prominence
  mostly by everything else being turned down. Emphasize four things and there
  is no first thing.
- Every distinction spends from one budget. C3 says this for color; it holds in
  every channel.

### H2 -- Space inside a group is smaller than space around it

A comparison, not an absolute: the gap **within** a group is at least one full
step of the T2 spacing scale smaller than the gap **around** it. Get it wrong
-- equal spacing everywhere, or a heading nearer the section above than the
text it introduces -- and no border, tint, or label repairs it.

- **Reach for distance before geometry.** Deleting dividers and doubling the
  section gap groups just as reliably, adds no elements, and spends none of the
  contrast budget. D3's figures are where geometry *is* the statement -- a
  deliberate exception, not a licence to box everything.
- **Density is chosen once for the piece**, not per view. Airy says "read
  this", dense says "operate this"; both are legitimate, drifting between them
  is not.

### H3 -- One alignment axis per block

The reader extends every edge into a line nobody drew: sharing one reads as
ordered, *nearly* sharing one reads as sloppy.

- One block gets **one** axis. Centered text under left-aligned text is the
  classic wound: two axes, no continuous edge, unresolved however the type is
  restyled.
- Every edge sits on the declared grid or the T2 spacing set.
- A deliberate break is allowed, and reads as deliberate because nothing else
  breaks.

### H4 -- Fix a small type scale

- **<= 7 text styles for the whole piece**, each a size-and-weight pair with a
  named job (title, section heading, body, secondary, label, caption). Cutting
  to the set gives the survivors room to differ, and hierarchy appears without
  anything being made bigger.
- **State line height** per style: it decides whether a paragraph reads as a
  block or as separate lines.
- **Measure <= ~90 characters.** Past that the reader loses the return sweep.
- Size and weight are preattentive and survive greyscale, a cheap screen, and
  print. Deliver hierarchy here **before** reaching for color.

### H5 -- Color is a set of roles, and never the only carrier

- **Roles, not values:** surface (2-3 depths), content (primary, secondary,
  disabled), border/divider, one accent for the primary action, semantic
  states. These are what T3's semantic layer names.
- **Lightness carries rank, hue carries meaning, chroma carries loudness.**
  Rank in hue does not survive greyscale -- which is why C3 separates two
  elements by a *step on the ramp* first and a new hue never.
- **No meaning is carried by color alone.** Error, success, selected, which
  series -- each is also said by an icon, label, weight, or position. The test:
  it must survive a greyscale copy.
- **A theme is a remap, never an inversion.** Roles carry over, values are
  chosen again: flipping lightness gives glare, shadows that stop reading as
  depth, and calm colors that go radioactive on near-black.

### What these rules deliberately do not cover

**Optical correction.** Where number and eye disagree the eye wins -- a circle
overshoots a square's bounds to look the same size. No rule here covers it: a
workflow that never sees its output rendered cannot apply one, so a human
reviewer must look for it.
---

## Categorized display rules

### D1 -- Classify before drawing

Sort the elements into sets on one logical level at a time. The grouping must
be a real property of the content (kind, stage, owner, layer), never a
convenience of the layout. Name each set and state the level it sits on.

### D2 -- Same set looks the same; different sets look different

- **Within a set:** identical color, size, spacing, and layout method. If two
  items are in one set, nothing in their visual treatment distinguishes them.
- **Between sets:** at least one of color, size, spacing, or layout method
  must differ, and the difference must be **visible at a glance**, not a hair's
  variation. A 2px size difference or one ramp step apart is not a difference.
- **Color alone is not enough on its own.** If color is the *only* lever that
  differs between two sets, the sets must also be **named** -- a legend, a
  caption, or an in-figure label. Set membership is meaning, and H5 forbids
  meaning that dies in a greyscale copy. Color plus a name is legal; color
  by itself is not.
- **Which lever to reach for:** per C3, a step on an existing color ramp,
  size, spacing, or layout comes first. A new base hue is only available while
  the piece is still under the 3-color budget.

### D3 -- One figure per set, nested as the sets nest

- Draw every member of a set inside **one** enclosing geometric figure.
- **Coordinate sets share the identical figure.** Sets that sit at the same
  level under the same parent are peers: draw them with the **same** shape,
  the same corner radius, and the same border treatment. Their difference
  comes from color, size, spacing, or layout (D2) -- never from one peer
  being a rectangle and the next a circle. Changing the figure asserts a
  difference in *kind*, so change it only when the sets genuinely are
  different in kind (a process stage vs. an actor, data vs. the system
  acting on it) -- and say so in the legend or caption when you do.
- **Progressive sets step along one ramp.** When sets carry an order --
  stages of a process, ranked tiers, low-to-high intensity, a time sequence --
  keep the identical figure and encode the order as **evenly spaced,
  monotonic steps of lightness or transparency on one base color** (the C3
  ramp). The two ends of the ramp map to the two ends of the progression,
  never scrambled, and the step size stays constant so the reader can feel
  the interval. State which end means "more" in the legend or caption --
  a ramp with no stated direction is a gradient, not a scale.
  Keep it to 5 steps, 7 absolute maximum: past that, adjacent steps stop
  being tellable apart. Beyond 7, add a numeric label or split the sequence
  rather than squeezing the ramp.
- **One meaning per ramp.** Nesting depth and progression both want the
  lightness ramp. When a figure needs both, let the ramp carry the
  progression and mark nesting another way (border weight, inset spacing),
  or the reverse -- but say which one the ramp encodes. A ramp that means
  two things at once means neither.
- Nest the figures exactly as the sets nest: a subset's figure sits fully
  inside its parent's figure. Never let figures cross or partially overlap --
  overlap asserts a relationship that the classification does not have.
- The figures are themselves visual elements: they follow C1-C3 like anything
  else. Step the nesting levels along one ramp -- lightest surface outside,
  each level inward one step darker (or the reverse on a dark ground) -- so
  depth is legible without adding hues.

### D4 -- Rounded rectangle by default

- Default figure: a **rounded rectangle**, with the **same corner radius on
  every figure** in the piece. A consistent radius is what makes nested
  figures read as one system.
- Other shapes (circles, hexagons, organic blobs, mixed forms) are acceptable
  when the user asks for a livelier, more energetic look. That is a user
  choice -- ask before departing from the default; do not decide it alone.
- Even then, D3 still holds: one figure per set, cleanly nested, never
  crossing.

---

## Self-check before delivering a visual

- [ ] Direction was picked by the user from 3-4 proposals, or picked and named
      because the user asked not to wait; no named default is present unless
      the brand, the user, or a stated reason called for it.
- [ ] Every value in the composed layer is a named token; a raw-value scan
      returns nothing (T1, T5) -- state the count observed, not an impression.
- [ ] Every dimension has a declared value set, color included and color not
      alone: spacing, type size, weight, radius, shadow, border (T2).
- [ ] The composed layer consumes semantic tokens, not primitives (T3).
- [ ] Every exception is named in the system; none typed inline (T4).
- [ ] Base colors counted: <= 3 excluding pure white/black, and 1-2 unless
      there was a reason to go to 3.
- [ ] Every pure-black area was chosen, not defaulted into: name the ramp it
      belongs to, or the reason the piece has none.
- [ ] Every extra tone traces to a lightness or transparency step on a base
      color, not to a new hue.
- [ ] Brand or source colors present and unmodified (C2 precedence).
- [ ] Every *base* color the workflow invented is Morandi (C1), or passes the
      membership test; derived ramp steps are exempt from the palette bounds
      (C3).
- [ ] Every text/background pair verified at >= 4.5:1.
- [ ] If the output is printed: every stroke below 1pt resolves to <= 2 ink
      plates, black-only by default.
- [ ] Squint or thumbnail the piece: exactly one element is first, and its
      rank is carried by at most two channels (H1).
- [ ] Within-group spacing is at least one scale step smaller than
      around-group spacing; no divider is doing work distance could do (H2).
- [ ] One alignment axis per block; every edge on the grid or spacing set (H3).
- [ ] <= 7 text styles, each with a named job; line height stated; measure
      <= ~90 characters (H4).
- [ ] Greyscale copy: no meaning disappears, and rank still reads (H5).
- [ ] Sets named, each on one logical level (D1).
- [ ] Within-set treatment identical; between-set difference visible at a
      glance (D2).
- [ ] One figure per set, nested to match the set nesting, no crossings;
      peer sets drawn with the identical figure; ordered sets stepped along
      one monotonic, evenly spaced ramp whose direction is stated (D3).
- [ ] One corner radius across all figures, or a user-approved alternative
      shape language (D4).
- [ ] Two views set side by side: no value has drifted between them.
- [ ] Optical correction looked for by a human, since no rule here covers it.
