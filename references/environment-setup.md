---
id: environment-setup
scope: "git installation procedures: package-manager install, manual guide, sandbox halt; optional tool fallback table"
read-when: "Phase 0 detects git=missing"
depends-on: []
priority: P1
tags: [setup, git, installation, fallback]
---

# Environment Setup Reference - git Installation & Recovery Paths

> Read this file only when Phase 0 detects `git=missing`.
> The sandbox classification rules and risk tiers live in `SKILL.md` Phase 0;
> this file contains only the installation and recovery procedures.

## Contents

1. Step 1 - Package-Manager Install (Non-Sandbox, requires one confirmation)
2. Step 2 - Step-by-Step Manual Installation Guide (per OS)
3. Step 3 - Sandbox Environment: Inform & Provide Guide Only
4. Optional Tools: Silent Fallback Table

---

### `git` - Conditionally Required Tool: Install & Recovery Decision Tree

Requirement level depends on elicited scope (see `SKILL.md` Phase 0 tool table):

- **Required** when the deliverables include git workflow content (`GIT_WORKFLOW.md`,
  branch strategy, CODEOWNERS, changelog with commit hashes) or Mode B migration of
  a git repo. If missing, do not proceed past Phase 3 - run this decision tree.
- **Optional** for documentation or content-type projects (A1 = D or E) or when the user explicitly
  declines git. Skip this decision tree, omit git-dependent deliverables, and note
  the omission in the plan document. Never hard-stop a deliverable that does not
  actually need git.

#### Step 1 - Package-Manager Install (Non-Sandbox Only, Confirm First)

If **not** in a sandbox environment and a package manager is detected, ask once
before touching the user's system - installing system packages (often via `sudo`)
is a higher-risk operation than any file edit this skill performs:

> "检测到缺少 git。是否允许我通过 <package manager> 安装？(可能需要 sudo 权限) /
>  git is missing. May I install it via <package manager>? (may require sudo)
>  [yes / no - 选择 no 将显示手动安装指南 / choosing no shows the manual guide]"

On `yes`, run the matching branch below. On `no` or no answer, go to Step 2.

```bash
# macOS (Homebrew)
if [ "$PKG_MANAGER" = "brew" ]; then
  echo "[INFO] Installing git via Homebrew..."
  brew install git && echo "[OK] git installed successfully." || echo "[FAIL] brew install failed."

# Debian / Ubuntu
elif [ "$PKG_MANAGER" = "apt" ]; then
  echo "[INFO] Installing git via apt..."
  sudo apt-get update -qq && sudo apt-get install -y git \
    && echo "[OK] git installed successfully." || echo "[FAIL] apt install failed."

# Fedora / RHEL
elif [ "$PKG_MANAGER" = "dnf" ]; then
  echo "[INFO] Installing git via dnf..."
  sudo dnf install -y git \
    && echo "[OK] git installed successfully." || echo "[FAIL] dnf install failed."

# Arch Linux
elif [ "$PKG_MANAGER" = "pacman" ]; then
  echo "[INFO] Installing git via pacman..."
  sudo pacman -Sy --noconfirm git \
    && echo "[OK] git installed successfully." || echo "[FAIL] pacman install failed."

# Windows (winget)
elif [ "$PKG_MANAGER" = "winget" ]; then
  echo "[INFO] Installing git via winget..."
  winget install --id Git.Git -e --source winget \
    && echo "[OK] git installed successfully." || echo "[FAIL] winget install failed."

# Windows (Chocolatey)
elif [ "$PKG_MANAGER" = "choco" ]; then
  echo "[INFO] Installing git via Chocolatey..."
  choco install git -y \
    && echo "[OK] git installed successfully." || echo "[FAIL] choco install failed."

else
  echo "[WARN] No supported package manager detected. Manual installation required."
fi
```

After the confirmed install attempt, re-verify:

```bash
git --version 2>/dev/null && echo "git=ok" || echo "git=still-missing"
```

If `git=ok` → continue to Phase 1.
If `git=still-missing` → proceed to Step 2.

---

#### Step 2 - Step-by-Step Manual Installation Guide

If the install failed, was declined, or is not available (sandbox, no package manager, or
Windows without winget/choco), display the appropriate guide based on detected OS:

---

**🍎 macOS - Manual Installation Guide**

```
Git is not installed. Follow these steps:

Option A - Install via Homebrew (recommended):
  1. Open Terminal
  2. Install Homebrew if not present:
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  3. Install git:
     brew install git
  4. Verify: git --version

Option B - Install Xcode Command Line Tools (includes git):
  1. Open Terminal
  2. Run: xcode-select --install
  3. Follow the on-screen installer prompt
  4. Verify: git --version

Option C - Download the official installer:
  1. Visit: https://git-scm.com/download/mac
  2. Download and run the .pkg installer
  3. Follow the installation wizard
  4. Verify: git --version

Once installed, return here and I will continue from where we left off.
```

---

**🐧 Linux - Manual Installation Guide**

```
Git is not installed. Run the command for your distribution:

Ubuntu / Debian:
  sudo apt-get update && sudo apt-get install -y git

Fedora:
  sudo dnf install -y git

CentOS / RHEL:
  sudo yum install -y git

Arch Linux:
  sudo pacman -Sy git

openSUSE:
  sudo zypper install git

Alpine:
  sudo apk add git

After installation, verify: git --version
Once installed, return here and I will continue from where we left off.
```

---

**🪟 Windows - Manual Installation Guide**

```
Git is not installed. Choose your preferred method:

Option A - winget (Windows 10/11 built-in, recommended):
  1. Open PowerShell or Command Prompt
  2. Run: winget install --id Git.Git -e --source winget
  3. Restart your terminal
  4. Verify: git --version

Option B - Chocolatey:
  1. Open PowerShell as Administrator
  2. Run: choco install git -y
  3. Restart your terminal
  4. Verify: git --version

Option C - Official installer:
  1. Visit: https://git-scm.com/download/win
  2. Download the installer (.exe)
  3. Run the installer - recommended settings:
     ✅ "Git from the command line and also from 3rd-party software"
     ✅ "Use Windows' default console window"
     ✅ "Enable Git Credential Manager"
  4. Restart your terminal
  5. Verify: git --version

Option D - WSL (Windows Subsystem for Linux):
  1. Open PowerShell as Administrator
  2. Run: wsl --install
  3. After restart, open WSL terminal
  4. Run: sudo apt-get install -y git
  5. Verify: git --version

Once installed, return here and I will continue from where we left off.
```

---

**❓ Unknown OS - Manual Installation Guide**

```
Git is not installed and your OS could not be detected automatically.

Please visit the official Git download page for your platform:
  https://git-scm.com/downloads

Select your operating system, follow the installation instructions,
then verify with: git --version

Once installed, return here and I will continue from where we left off.
```

---

#### Step 3 - Sandbox Environment: Inform & Provide Guide Only

If running in a **sandbox environment** where installation is not possible:

```
⚠️  Git is not available in this sandbox environment, and installing it
    is not permitted here.

To proceed, please install git in your local environment and either:
  A) Run this skill in your local terminal where git is available, OR
  B) Ask your system administrator to provision git in this environment.

Installation guide for your platform:
  🍎 macOS:   brew install git  OR  xcode-select --install
  🐧 Linux:   sudo apt-get install -y git  (or your distro's equivalent)
  🪟 Windows: winget install --id Git.Git -e --source winget

Official reference: https://git-scm.com/downloads

I cannot proceed until git is available. Once installed, restart this
skill and I will continue from the beginning.
```

Hard stop. Do not proceed to Phase 1 until `git --version` succeeds.

---

### Optional Tools: Silent Fallback (No User Action Required)

| Missing Tool | Automatic Fallback | User Impact |
|---|---|---|
| `tree` | `find . -not -path '*/\.*' \| sort` | Directory display is less visual; functionally identical |
| `gh` | Branch protection checks skipped; noted in plan document | Minor: CODEOWNERS validation skipped |
| `jq` | Plain text parsing used for all JSON output | No user-visible impact |

---
