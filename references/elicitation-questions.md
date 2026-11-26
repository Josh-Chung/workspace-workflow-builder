---
id: elicitation-questions
scope: "Bilingual question bank, Track A (A1-A6): project workflow requirements. Track B lives in elicitation-track-b.md"
read-when: "Phase 3 entry (requirements elicitation)"
depends-on: []
priority: P0
tags: [elicitation, questions, requirements, bilingual]
---

# Elicitation Question Bank (Phase 3)

> Read this file when entering Phase 3. The gate rules, preset profiles, and
> pruning matrix live in `SKILL.md` Phase 3 - this file contains the full
> bilingual question bank only. Ask only the questions that survive preset
> resolution and pruning; ask ONE question per turn, always with concrete options.

## Contents

- Track A - Project Workflow Requirements (A1-A6) -- this file
- Track B - AI Agent Workflow Requirements (B0-B10) -- `elicitation-track-b.md`

---

### Track A - Project Workflow Requirements

**A1. Project Type & Tech Stack**

> **这个项目是什么类型的？ / What type of project is this?**
>
> 不同类型的项目需要不同的目录结构和工作流规范，请选择最贴近你项目的类型。
> *(Different project types need different folder structures and workflows - pick the closest match.)*
>
> A) **软件开发 / Software development**
>    - 开发一个可运行的程序，例如网站、手机 App、后端服务、命令行工具等。
>    *(Building a runnable application: website, mobile app, backend API, CLI tool, etc.)*
>
> B) **数据分析 / Data science & analytics**
>    - 主要工作是分析数据、制作图表或构建数据处理流程，通常使用 Jupyter Notebook、Python、SQL 等。
>    *(Analyzing data, making charts, or building data pipelines - typically using Jupyter, Python, or SQL.)*
>
> C) **AI/ML 工程 / AI/ML engineering**
>    - 训练机器学习模型、部署 AI 推理服务，或管理模型版本与实验。
>    *(Training ML models, deploying AI inference services, or managing model experiments and versions.)*
>
> D) **文档与研究写作 / Document & research writing**
>    - 主要产出是文字内容，例如技术文档、知识库、产品手册、商业计划书、可行性研究、行业报告等。
>    *(The main output is written content: technical docs, knowledge bases, product manuals,
>    business plans, feasibility studies, research reports.)*
>
> E) **内容运营 / Content operations**
>    - 持续性的内容生产与发布，例如自媒体账号、newsletter、营销文案、社媒矩阵。
>    *(Recurring content production and publishing: social media accounts,
>    newsletters, marketing copy, multi-platform content.)*
>
> F) **提示词与 Agent 工程 / Prompt & agent engineering**
>    - 设计、构建或优化 AI 指令制品：系统提示词、Skill、Chat 指令、Agent 工作流。
>    *(Designing, building, or optimizing AI instruction artifacts: system prompts,
>    Skills, Chat Instructions, agent workflows.)*
>
> G) **运维与基础设施 / Ops & infrastructure**
>    - IaC、部署、迁移、SRE 运维项目，例如 Terraform、Kubernetes、CI/CD 流水线等。
>    *(Infrastructure as Code, deployment, migration, SRE projects - Terraform,
>    Kubernetes, CI/CD pipelines, etc.)*
>
> H) **其他 / Other** - 请描述你的项目 / Please describe your project
>
> *映射说明 / Branch mapping:* A -> Branch S (Engineering); B/C -> Branch E
> (Data & Experiment); D -> Branch D (Document & Research); E -> Branch C
> (Content Operations); F -> Branch P (Prompt & Agent Engineering);
> G -> Branch O (Ops & Infrastructure); H -> branch selected by a follow-up
> question.

**A1-combo. Secondary Branch QA Checklist (conditional)**

*Trigger: only when the agent detects mixed deliverable types during A1
resolution - e.g. A1=A but user also mentions writing documentation or
research reports, or A1=D but user describes building automation scripts.
Do NOT ask if the project clearly fits a single branch.*

> **这个项目还涉及 \<secondary type\> 的工作。是否将该分支的 QA 检查清单
> 合并到 Step 5？ / This project also involves \<secondary type\> work.
> Should we merge that branch's QA checklist into Step 5?**
>
> 主分支: \<primary branch\> (决定工作流步骤)
> 候选次要分支: \<secondary branch\> (仅贡献 QA 检查项)
> *(Primary: \<primary branch\> (determines workflow steps)
> Candidate secondary: \<secondary branch\> (contributes QA checklist items only))*
>
> A) **是 / Yes** - 合并次要分支的 QA 检查清单到 Step 5
>    *(Merge secondary branch's QA checklist into Step 5)*
>
> B) **不需要 / No** - 仅使用主分支
>    *(Primary branch only)*
>
> *约束 / Constraints:*
> - 最多一个次要分支 / Maximum one secondary branch
> - 仅借用 QA 检查项，不改变工作流步骤或路由规则
>   *(Checklist items only - no workflow steps or routing rules are injected)*
> - 次要分支的 BLOCKED 项目与主分支的 BLOCKED 项目取并集
>   *(Secondary BLOCKED items are additive - union of primary and secondary)*

**A1-visual. Visual Output (conditional)**

*Trigger: ask whenever the deliverables could include something a reader
looks at -- a UI, charts, diagrams, slides, a document with figures, or
print material. Typical for A1=A, B, E; possible for D. Skip when the
output is plainly text-only (scripts, logs, APIs).*

> **这个项目的产出里有需要「看」的内容吗？（界面、图表、示意图、幻灯片、
> 带插图的文档、印刷品） / Will this project's deliverables include visual
> content (UI, charts, diagrams, slides, illustrated documents, print)?**
>
> 如果有，工作流会带上令牌、配色、结构与分类呈现规则：每个取值都有名字，
> 输出看起来是一套系统，而不是每次重新发明一套颜色和间距。
> *(If yes, the generated workflow carries the token, color, structure and
> categorized-display rules: every value is a named token, so output reads as
> one system instead of a fresh palette and a fresh spacing scale each time.)*
>
> A) **有 / Yes** - 生成 `.workflow-references/visual-presentation.md`，并在
>    Step 3 引用它
>    *(Generate `.workflow-references/visual-presentation.md` and reference it
>    at Step 3)*
>
> B) **没有 / No** - 纯文本产出，跳过
>    *(Text-only output - skip it)*

*Answer A -> include the `visual-presentation.md` companion, its Reference
Files row, and the VISUAL_PRESENTATION fragment. Answer B -> omit all three.*

If A (visual output), also ask:

> **这些产出里，有要送到印厂付印的 PDF 吗？（画册、手册、卡片、海报、包装）
> / Does any of that output become a press file -- a PDF handed to a print
> shop (brochure, manual, card, poster, packaging)?**
>
> 只在屏幕上看的 PDF 不算。付印文件多一层规则：字体类型、转曲时机、印前判据。
> *(A PDF only ever viewed on screen does not count. A press file carries an
> extra layer of rules: font type, when to outline, and the preflight
> criteria that verify both.)*
>
> A) **有 / Yes** - 再生成 `.workflow-references/print-output.md`，并在
>    Step 3 一并引用
>    *(Also generate `.workflow-references/print-output.md` and reference it
>    at Step 3 alongside the visual rules)*
>
> B) **没有 / No** - 只在屏幕上呈现，跳过
>    *(Screen-only presentation - skip it)*

*Answer A -> include the `print-output.md` companion, its Reference Files row,
and the PRINT_OUTPUT fragment, in addition to the visual ones. Answer B ->
omit all three.*

If A (Software Development), also ask:

> **主要技术栈是什么？ / What is the primary tech stack?**
>
> 技术栈是指你的项目所使用的编程语言和主要框架的组合，它决定了目录结构、依赖管理方式和配置文件的生成。
> *(Your tech stack is the combination of programming language and frameworks your project uses - it determines folder layout, dependency files, and config templates.)*
>
> 常见示例 / Common examples:
> - 前端 / Frontend: `TypeScript + React`, `Vue 3`, `Next.js`
> - 后端 / Backend: `Python + FastAPI`, `Node.js + Express`, `Go`, `Java + Spring`
> - 全栈 / Full-stack: `Next.js (frontend + backend)`, `Django + React`
> - 移动端 / Mobile: `React Native`, `Flutter`
> - 其他 / Other: `Rust`, `monorepo (多包单仓库)`, etc.
>
> 如果你还不确定，可以告诉我你打算用哪种编程语言，我来帮你推荐。
> *(If you're unsure, just tell me which programming language you plan to use and I'll suggest a stack.)*

**A2. Team & Collaboration Scale**

> **团队规模与协作方式？ / What is your team size and collaboration style?**
>
> 团队规模决定了需要多严格的协作规范。人越多，越需要明确的规则来避免混乱。
> *(Team size determines how strict your collaboration rules need to be. More people = more structure needed.)*
>
> A) **个人项目 / Solo project**
>    - 只有你一个人开发，不需要团队协作规范，结构尽量简洁。
>    *(Just you - no team collaboration needed. Keep things simple.)*
>
> B) **小团队 / Small team (2-5 人/people)**
>    - 少数几人合作，规范可以相对轻量，主要确保代码不冲突即可。
>    *(A few collaborators - lightweight rules, mainly to avoid conflicts.)*
>
> C) **中型团队 / Medium team (6-20 人/people)**
>    - 需要结构化的工作流规范，例如明确的代码审查流程和分支命名规则。
>    *(Needs structured workflows: clear code review processes and branch naming conventions.)*
>
> D) **大型团队 / Large team (20+ 人/people)**
>    - 需要严格的治理规范，包括：
>      · CODEOWNERS（代码归属文件：规定哪个团队负责哪些代码文件）
>      · Branch protection（分支保护：防止直接往主分支推送代码）
>      · 完整的审批流程
>    *(Requires strict governance: CODEOWNERS file to assign ownership of code areas, branch protection to prevent direct pushes to main, and a full approval process.)*

**A3. CI/CD Integration**

> **需要集成 CI/CD 吗？ / Do you need CI/CD integration?**
>
> CI/CD 是"持续集成 / 持续部署"的缩写。简单来说：每次你提交代码，系统自动帮你运行测试、检查代码质量，甚至自动发布到服务器，减少手动操作和人为失误。
> *(CI/CD stands for Continuous Integration / Continuous Deployment. In plain terms: every time you push code, the system automatically runs tests, checks quality, and can even deploy to your server - reducing manual steps and human error.)*
>
> A) **不需要 / No CI/CD**
>    - 暂时不需要自动化流程，手动测试和发布即可。
>    *(No automation for now - manual testing and deployment is fine.)*
>
> B) **GitHub Actions**
>    - GitHub 平台内置的自动化工具，适合托管在 GitHub 上的项目，配置简单，免费额度充足。
>    *(GitHub's built-in automation tool - best if your project is hosted on GitHub. Easy to set up, generous free tier.)*
>
> C) **其他平台 / Other platform**
>    - 例如 GitLab CI（GitLab 平台自带）、Jenkins（自托管，高度可定制）、CircleCI（云端 CI 服务）等，请注明使用哪个。
>    *(E.g., GitLab CI (built into GitLab), Jenkins (self-hosted, highly customizable), CircleCI (cloud CI service) - please specify which one.)*
>
> D) **暂不确定 / Not decided yet**
>    - 先搭好结构，CI/CD 配置预留位置，后续再填充。
>    *(Set up the structure now, reserve a placeholder for CI/CD config, and fill it in later.)*

**A4. Branch & Git Strategy**

> **Git 分支策略偏好？ / What Git branching strategy do you prefer?**
>
> 分支策略规定了团队如何使用 Git 分支来组织开发工作。分支就像代码的"平行宇宙"，让多人可以同时开发不同功能而互不干扰，完成后再合并回主线。
> *(A branching strategy defines how your team uses Git branches to organize development. Branches are like parallel timelines for your code - multiple people can work on different features simultaneously without interfering, then merge back when done.)*
>
> A) **GitHub Flow（推荐新手 / Recommended for beginners）**
>    - 最简单的策略。只有一条主分支（`main`），每个新功能开一个分支，完成后合并回 `main`。适合持续发布的项目。
>    *(The simplest strategy. One main branch, one branch per feature, merge back when done. Great for projects with continuous releases.)*
>
> B) **Git Flow（适合有版本发布周期的项目）**
>    - 稍复杂，有固定的分支类型：`main`（生产）、`develop`（开发主线）、`feature/*`（新功能）、`release/*`（发布准备）、`hotfix/*`（紧急修复）。适合有明确版本号的软件。
>    *(More structured, with fixed branch types: `main` (production), `develop` (integration), `feature/*` (new work), `release/*` (release prep), `hotfix/*` (urgent fixes). Good for versioned software with defined release cycles.)*
>
> C) **Trunk-based development（适合经验丰富的团队）**
>    - 所有人都在一条主干分支上工作，分支存活时间极短（通常不超过 1-2 天），依赖大量自动化测试保证质量。适合 DevOps 成熟度较高的团队。
>    *(Everyone works close to one main trunk, branches are very short-lived (1-2 days max), and relies heavily on automated tests. Best for mature DevOps teams with strong test coverage.)*
>
> D) **自定义 / Custom**
>    - 以上都不完全符合，请描述你的分支使用习惯。
>    *(None of the above fits - please describe how your team uses branches.)*

**A5. Change Logging**

> **需要为项目追踪修改记录吗？ / Do you want to track a change log for this project?**
>
> 修改记录（Changelog）是一份按时间倒序记录项目每次变更的文件，包含：改了什么文件、做了什么操作、对应的 Git 提交哈希。它能帮助你和团队快速回溯"这个改动是什么时候引入的"，也方便 AI Agent 理解项目的演变历史。
> *(A changelog is a file that records every project change in reverse-chronological order - what files changed, what was done, and the corresponding Git commit hash. It helps you and your team quickly trace "when was this change introduced", and helps AI Agents understand the project's evolution.)*
>
> A) **不需要 / No** - 不生成 `CHANGELOG.md`，依靠 `git log` 查看历史即可。
>    *(No `CHANGELOG.md` generated - rely on `git log` for history.)*
>
> B) **需要，手动维护 / Yes, manually maintained** - 生成 `CHANGELOG.md` 文件和格式规范，由人类自行在每次变更后填写，AI Agent 不介入。
>    *(Generate `CHANGELOG.md` with format spec - humans fill it in after each change; AI Agents don't touch it.)*
>
> C) **需要，由 AI Agent 维护 / Yes, AI Agent-maintained** - 生成 `CHANGELOG.md` 并将变更日志规则注入所有 Agent 工作流文件（`CLAUDE.md`、`AGENTS.md`、`GEMINI.md` 等），要求 Agent 在每次有意义的操作后自动写入日志条目并与代码变更原子提交。
>    *(Generate `CHANGELOG.md` and inject the Change Logging Rule into all Agent workflow files - Agents are required to write a log entry and commit it atomically with every meaningful code change.)*

> ⚠️ **选 C 时的注意事项 / Note for option C:**
> Agent 每次操作后会先写入日志条目（commit hash 暂填 `PENDING`），将 `CHANGELOG.md` 与所有变更文件一起原子提交。**真实的 40 位 commit hash 将在下次编辑 `CHANGELOG.md` 时回填**，而非提交后立即回填 -- 这避免了为回填 hash 单独追加一次提交的问题。
> *(After each operation, the Agent writes the log entry first with `PENDING` as the hash placeholder, then commits `CHANGELOG.md` atomically with all changed files. **The real 40-character commit hash is back-filled on the next edit to `CHANGELOG.md`** - not immediately after the commit - avoiding a separate follow-up commit just for the hash.)*

**A6. Agent Workflow File Git Tracking**

> **AI Agent 工作流文件是否纳入 git 追踪？ / Should AI Agent workflow files be tracked by git?**
>
> 默认情况下，`CLAUDE.md`、`AGENTS.md`、`GEMINI.md`、`MEMORY.md`、`GIT_WORKFLOW.md`
> 等文件**不会**提交到 git 仓库（已加入 `.gitignore`）。这些文件包含 AI 行为配置和团队操作规范，
> 通常属于本地或团队内部约定，不适合与源代码一起版本化。
>
> *(By default, Agent workflow files are added to `.gitignore` and not committed.
> They contain AI behavioral config and team conventions that are typically
> local or internal - not appropriate to version alongside source code.)*
>
> A) **不追踪（默认推荐）/ Exclude from git (default, recommended)**
>    - 文件保留在本地，加入 `.gitignore`，不出现在 `git log` 或远程仓库中。
>    *(Files stay local, added to `.gitignore` - never appear in `git log` or remote repo.)*
>
> B) **追踪全部 / Track all**
>    - 所有 Agent 工作流文件纳入 git 追踪，与源代码一同提交和版本化。适合希望团队共享
>    同一套 AI 工作流配置的场景。
>    *(All Agent workflow files are tracked, committed, and versioned alongside source code.
>    Suitable when the team wants to share a unified AI workflow config.)*
>
> C) **选择性追踪 / Selective tracking**
>    - 指定哪些文件纳入追踪，哪些排除。例如：`GIT_WORKFLOW.md` 追踪（团队共享），
>    `MEMORY.md` 排除（Agent 私有状态）。
>    *(Specify which files to track and which to exclude - e.g. track `GIT_WORKFLOW.md`
>    for team sharing, exclude `MEMORY.md` as private agent state.)*

---

### Track B - AI Agent Workflow Requirements

Track B (B0-B10) covers the AI agent workflow itself -- generation matrix,
behavior, collaboration, and full-depth layers. Its questions live in
`elicitation-track-b.md`. Read that file after Track A is resolved; the
same gate rules, preset resolution, and pruning matrix apply to both tracks.
