---
id: elicitation-track-b
scope: "Bilingual question bank, Track B (B0-B10): AI agent workflow requirements -- generation matrix, behavior, collaboration, and full-depth layers"
read-when: "Phase 3 elicitation, after Track A is resolved"
depends-on: [elicitation-questions]
priority: P1
tags: [elicitation, questions, requirements, bilingual, track-b]
---

### Track B - AI Agent Workflow Requirements (Full-Depth)

**B0. Agent Selection**

> **您计划使用哪些 AI Agent？ / Which AI Agents will this project use?**
>
> AI Agent 是指在人类触发或编排框架驱动下执行任务的 AI 助手，例如帮你写代码、审查 PR、管理文件等。不同的 Agent 有不同的能力和适用场景，你可以只用一个，也可以多个配合使用。
>
> ⚠️ **"多 Agent"有两种含义 / "Multiple agents" means two different things:**
>
> - **多个运行时共用一套规范（本题选择的就是这个）：** 例如 Claude + Codex 读取同一份规则，但不会自行互相调用。工作在它们之间的传递由你完成，或经由你自己配置的桥接（例如 MCP 服务器）；本 Skill 不生成桥接。如何分工在 B4 中确定。
> - **一个运行时委派子代理（sub-agent）：** 部分运行时能在一次任务中启动子代理。生成的工作流只在运行时确实支持时才委派，否则串行执行，绝不假装并行。
>
> 角色名不会增加知识：叫"架构师"的 Agent 并不比叫"工程师"的懂得更多。值得拆分的理由是上下文（让每个窗口小而相关）、权限（例如只读的审查者），或请另一种模型给出第二意见。
>
> *(Several runtimes sharing one spec - what this question selects: e.g. Claude + Codex read the same rules but do not call each other on their own; work moves between them through you, or through a bridge you configure yourself (such as an MCP server) - this Skill does not generate one. B4 settles how they divide the work. One runtime delegating to sub-agents: some runtimes can launch sub-agents within a task; the generated workflow delegates only where the runtime actually supports it, and otherwise runs serially - never pretending to run in parallel. A role name adds no knowledge: an "architect" agent knows nothing an "engineer" agent does not. Split for context (keep each window small and relevant), for permissions (e.g. a read-only reviewer), or for a second opinion from a different model.)*
>
> A) **Claude only**（Anthropic 出品，擅长复杂推理、长文档处理和代码审查）
>    *(Made by Anthropic - strong at complex reasoning, long documents, and code review.)*
>
> B) **Gemini only**（Google 出品，擅长多模态任务和与 Google 生态集成）
>    *(Made by Google - strong at multimodal tasks and integration with Google ecosystem.)*
>
> C) **OpenAI Codex only**（OpenAI 出品，专注代码生成和终端命令执行）
>    *(Made by OpenAI - focused on code generation and terminal command execution.)*
>
> D) **多个 Agent 组合 / Multiple agents**
>    - 请指定使用哪几个，例如 Claude + Gemini，或 Claude + Codex。
>    *(Please specify which combination, e.g. Claude + Gemini, or Claude + Codex.)*

Based on selection, determine which files to generate:

| Agent Selected | Files Generated |
|---|---|
| Claude only | `CLAUDE.md` |
| Gemini only | `GEMINI.md` |
| OpenAI Codex only | `AGENTS.md` (Codex's native filename) |
| Claude + Gemini | `CLAUDE.md` + `GEMINI.md`, identical |
| Claude + Codex | `CLAUDE.md` + `AGENTS.md`, identical |
| Gemini + Codex | `GEMINI.md` + `AGENTS.md`, identical |
| Claude + Gemini + Codex | `CLAUDE.md` + `AGENTS.md` + `GEMINI.md`, identical |
| Any combination | `MEMORY.md`, `GIT_WORKFLOW.md` (always generated) |

> **Note on the copies:** every selected agent gets its own native filename, and
> every one of those files carries the same body, byte for byte. No entry file
> points at another. The harness decides which file it loads and may never
> resolve a reference to a second one -- Claude Code loads a project's
> `CLAUDE.md` and does not load `AGENTS.md` -- so each entry file has to be
> complete on its own. The obligation this creates: **every later edit to the
> rules must land in every copy.**
>
> *(每个选中的 Agent 都生成自己的原生文件名，而这些文件的内容逐字节相同，互不指向。加载哪个文件由运行时决定，它可能永远不会去读第二个文件——例如 Claude Code 只加载 `CLAUDE.md`，不加载 `AGENTS.md`——所以每个入口文件都必须自身完整。由此带来的义务：**今后对规则的每一次修改，都必须同步到每一份副本。**)*

---

#### 🔧 Behavior Layer

**B1. Claude Behavior Preferences** *(ask only if Claude is selected)*

> **Claude 的行为偏好？ / What are your Claude behavior preferences?**
>
> 这里决定 Claude 在这个项目里工作的方式。
> *(This determines how Claude operates within your project.)*
>
> A) **默认推理强度 / Default reasoning effort**
>    - Claude 使用运行时默认的推理强度工作，适合大多数日常任务。
>    *(Claude works at the runtime's default reasoning effort - suitable for most everyday tasks.)*
>
> B) **提高推理强度 / Higher reasoning effort for complex work**
>    - 当前模型总是先推理再回答，这里选择的是推理的深度：在运行时提供推理强度设置的地方，为复杂任务（例如架构设计、复杂 Bug 分析）调高一档。响应更慢、消耗更多，但质量更高。
>    *(Current models always reason before answering; what you choose here is how much. Wherever the runtime offers a reasoning-effort setting, raise it one level for complex work such as architecture design or tricky bug analysis. Responses are slower and cost more, but quality is higher.)*
>
> C) **集成 MCP 工具 / Integrate MCP tools**
>    - MCP（Model Context Protocol）是让 Claude 能够调用外部工具的协议，例如读写本地文件、操作 GitHub、发送 Slack 消息等。请指定需要哪些工具。
>    *(MCP - Model Context Protocol - lets Claude call external tools: reading/writing local files, operating GitHub, sending Slack messages, etc. Please specify which tools you need.)*
>
> D) **B + C 组合 / Both higher reasoning effort and MCP integration**
>    - 同时提高推理强度并集成外部工具。
>    *(Raise reasoning effort and integrate external tools.)*

**B2. Memory Strategy**

> **Agent 记忆策略？ / What memory strategy should the agents use?**
>
> "记忆"指 Agent 在工作过程中记住哪些信息、记多久。没有记忆的 Agent 每次对话都从零开始；有记忆的 Agent 能记住上次的决定、错误和项目背景，避免重复犯错。
> *("Memory" refers to what information the agent retains and for how long. An agent without memory starts fresh every conversation; one with memory can recall past decisions, errors, and project context - avoiding repeated mistakes.)*
>
> A) **会话级记忆 / Session-level only**
>    - 每次新对话开始时记忆清空，Agent 不保留上次的任何内容。适合独立任务，不需要跨对话积累知识。
>    *(Memory clears at the start of each new conversation. Good for standalone tasks that don't need accumulated knowledge.)*
>
> B) **跨会话持久化 / Cross-session persistent**
>    - Agent 的记忆会保存到 `MEMORY.md` 文件，下次对话时可以读取，形成持续积累的项目知识库。
>    *(Memory is saved to `MEMORY.md` and reloaded next session - building a continuously growing project knowledge base.)*
>
> C) **分层混合 / Hybrid**
>    - 日常对话使用会话级记忆；只有重要决定、关键错误等核心内容才写入持久化文件，兼顾效率与积累。
>    *(Everyday conversation uses session memory; only important decisions and key errors are written to the persistent file - balancing efficiency with accumulation.)*
>
> D) **无需记忆管理 / No memory management needed**
>    - 不生成 `MEMORY.md`，Agent 完全无状态运行。
>    *(No `MEMORY.md` generated - agents run fully stateless.)*

**B3. MEMORY.md Classification Structure**

> **`MEMORY.md` 的记忆分类需求？ / What memory categories does your project need?**
>
> `MEMORY.md` 是 Agent 的"工作笔记本"，将不同类型的记忆分开存放，便于 Agent 快速检索。请选择你需要哪些分类。
> *(`MEMORY.md` is the agent's "notebook" - different types of memory are stored in separate sections for quick retrieval. Choose which categories you need.)*
>
> A) **基础四类 / Basic (recommended starting point)**
>    · 📁 **项目记忆 Project Memory**：项目的基本事实，例如技术栈、架构决策、核心约束。*(Stable facts about the project: tech stack, architecture, key constraints.)*
>    · 🧠 **决策记忆 Decision Memory**：重要决策的记录和原因，避免将来重复讨论同样的问题。*(Record of important decisions and their rationale - prevents relitigating the same choices.)*
>    · 🐛 **错误记忆 Error Memory**：曾经踩过的坑和解决方案，防止 Agent 重蹈覆辙。*(Past failures and their solutions - prevents agents from making the same mistakes.)*
>    · 📏 **运维规则 Operational Specification Rules**：Agent 在本项目内必须遵守的持久行为规则，由 Agent 与用户共同维护——这是 Agent 唯一可自主写入规则的地方，指令文件本身对 Agent 只读。*(Durable behavior rules the agent must follow in this project, maintained jointly by agent and user - the agent's only self-writable home for rules; the instruction files themselves stay read-only to agents.)*
>
> B) **A + 跨 Agent 共享记忆 / A + Cross-agent shared memory**
>    - 新增一块共享看板：所有 Agent 都能读取；每一行只有一个所有者，只有所有者能修改，其他 Agent 通过新增一行向它提出请求。
>    *(Adds a shared board every agent reads; each row has one owner who alone edits it, and other agents add a new row to ask that owner for something.)*
>
> C) **A + B + Agent 专属私有记忆 / A + B + Agent-specific private memory**
>    - 每个 Agent 额外拥有只有自己能写入的私有区域，存放 Agent 专属的中间状态或临时信息。
>    *(Each agent also gets a private zone only it can write to - for agent-specific intermediate state or temporary notes.)*
>
> D) **自定义分类 / Custom**
>    - 以上分类不满足需求，请描述你想要的记忆结构。
>    *(The above doesn't fit - please describe the memory structure you have in mind.)*

---

#### 🤝 Collaboration Layer

**B4. Multi-Agent Collaboration Mode** *(ask only if multiple agents selected)*

> **多个 Agent 如何分工？ / How should the agents divide the work?**
>
> 原则：任何文件都不会有两个写入者——读可以并行，并行写入只能落在互不重叠的文件上。每多一个 Agent 都要重新读取上下文，成本随之成倍增加，所以只在值得时才拆分。你的选择会生成入口文件中的"多 Agent 协作"小节（Multi-Agent Coordination）：所有权表、交接格式（brief），以及核验报告的规则。
> *(The principle: no file ever has two writers - reading can run in parallel, and parallel writers work only on disjoint files. Every extra agent re-reads the context, so cost multiplies - split only when it pays. Your choice generates the Multi-Agent Coordination subsection of the entry file: an ownership table, a brief format, and a rule for checking reports.)*
>
> A) **一个主写者 + 只读协助 / One lead writes, the others read and report（推荐 / recommended）**
>    - 一个 Agent 负责所有写入并整合结果；其他 Agent 只做审查、调研等只读工作，并以附带证据的报告回复。
>    *(One agent writes everything and integrates the result; the others do read-only work - review, research - and reply with reports that carry evidence.)*
>
> B) **按领域分工 / Split by domain**
>    - 每个 Agent 拥有自己的文件或目录（例如 Claude 负责 `src/`，Gemini 负责 `docs/`），任何文件都不会有两个写入者。由你把任务交给对应领域的 Agent。
>    *(Each agent owns its own files or directories - e.g. Claude owns `src/`, Gemini owns `docs/` - so no file ever has two writers. You route each task to the agent that owns it.)*
>
> C) **顺序接力 / Sequential handoff**
>    - Agent 按固定顺序工作，由你把每次交接交给下一个 Agent。例如：Claude 写代码 → 你把交接交给 Codex 审查 → 你把审查意见交回 Claude 修改。入口文件规定交接格式（brief），其中包括已做出的决定，避免下一个 Agent 悄悄推翻。
>    *(Agents work in a fixed order, and you carry each brief to the next one - e.g. Claude writes code, you hand it to Codex for review, you hand the review back to Claude. The entry file defines the brief format, including the decisions already made, so the next agent does not silently reverse them.)*
>
> D) **编排框架 / Orchestration framework（LangGraph、CrewAI、AutoGen 等）**
>    - 由框架自动路由。本 Skill 只记录这一决定，并生成框架应遵守的所有权表与交接格式；不生成任何编排脚本或配置——接入框架由你完成。
>    *(The framework routes the work automatically. This Skill records the decision and generates the ownership table and brief format the framework should honor; it generates no orchestration scripts or config - wiring the framework is yours to do.)*
>
> E) **自定义 / Custom**
>    - 请描述分工方式，以及你期望的自动化程度。
>    *(Describe the division of work and the level of automation you want.)*
>
> **追问（选择后必答） / Follow-up (required after any choice):**
> - 哪个 Agent 是主写者（负责整合结果）？ / **Which agent is the lead (integrates the result)?**
> - *(仅 B / B only)* 每个 Agent 拥有哪些文件或目录？ / **Which files or directories does each agent own?**
>
> 两个答案都写入确认摘要，绝不猜测。*(Both answers go into the confirmation summary and are never guessed.)*

**B5. Agent-Git Workflow Integration**

> **哪个 Agent 负责哪些 Git 操作？ / Which agent handles which Git operations?**
>
> Git 操作包括：提交代码（commit）、创建 PR（Pull Request，即合并请求）、撰写 PR 描述、回应代码审查意见等。你可以让 Agent 帮你起草这些内容，再由你最终确认执行。
> *(Git operations include: committing code, creating PRs (Pull Requests), writing PR descriptions, and responding to code review comments. You can have agents draft these for your final approval.)*
>
> A) **无 Agent 负责 Git / No agent handles Git operations**
>    - 所有 Git 操作由人工完成，Agent 不介入。
>    *(All Git operations are done manually - agents don't touch Git.)*
>
> B) **单一 Agent 全权负责 / One agent handles all Git tasks**
>    - 一个 Agent 负责所有 Git 相关的起草工作：commit message（提交说明）、PR 描述、代码审查回应。
>    *(One agent drafts all Git-related content: commit messages, PR descriptions, code review responses.)*
>
> C) **分工负责 / Split responsibilities**
>    - 不同 Agent 负责不同的 Git 任务，例如 Agent A 起草 commit message，Agent B 撰写 PR 描述。
>    *(Different agents handle different Git tasks - e.g. Agent A drafts commit messages, Agent B writes PR descriptions.)*
>
> D) **自定义分工 / Custom**
>    - 请说明每个 Agent 具体负责哪些 Git 操作。
>    *(Please specify each agent's exact Git responsibilities.)*

**B6. GIT_WORKFLOW.md Core Standards**

> **`GIT_WORKFLOW.md` 需要规定哪些内容？ / What should `GIT_WORKFLOW.md` govern?**
>
> `GIT_WORKFLOW.md` 是项目的 Git 使用规范手册，让所有人（包括 AI Agent）遵循一致的规则。规范越完整，团队协作越顺畅，但初期配置也越多。
> *(`GIT_WORKFLOW.md` is your project's Git rulebook - ensuring everyone, including AI agents, follows consistent practices. More complete rules = smoother collaboration, but more initial setup.)*
>
> A) **基础规范 / Basic standards**
>    · **Conventional Commits**：一种标准化的 commit message 格式，例如 `feat: add login page`、`fix: resolve null error`，让提交历史一目了然。*(A standardized commit message format - e.g. `feat: add login page`, `fix: resolve null error` - making history easy to read.)*
>    · **分支命名规则 Branch naming**：规定分支名的格式，例如 `feature/user-auth`、`fix/api-timeout`。*(Rules for branch name format, e.g. `feature/user-auth`, `fix/api-timeout`.)*
>
> B) **A + 合并策略与 PR 规范 / A + merge strategy + PR standards**
>    · **Squash merge（压缩合并）**：将一个功能分支的所有零散提交压缩成一个干净的提交再合并，保持主分支历史整洁。*(Squashes all commits from a feature branch into one clean commit before merging - keeps main branch history tidy.)*
>    · **PR 规范**：PR 标题格式、描述模板、必填检查项等。*(PR title format, description template, required checklist items, etc.)*
>
> C) **B + 代码归属与分支保护 / B + CODEOWNERS + branch protection**
>    · **CODEOWNERS**：一个配置文件，规定哪些团队或个人负责哪些代码目录，当相关代码有 PR 时自动通知对应的负责人。*(A config file specifying which team or person owns which code area - automatically notifies them when a PR touches their code.)*
>    · **分支保护 Branch protection**：防止直接往主分支推送代码，必须通过 PR 和审查才能合并，保护生产代码质量。*(Prevents direct pushes to main - all changes must go through a PR and review process, protecting production code quality.)*
>
> D) **全量治理 / Full governance**
>    - C 的所有内容，再加上：
>      · **Code review SLA**：规定代码审查的响应时限，例如"工作日内 24 小时必须有人审查"。*(Code review response time commitment, e.g. "reviewed within 24 business hours".)*
>      · **Release process（发布流程）**：版本发布的完整步骤和检查清单。*(Full steps and checklist for releasing a new version.)*

---

#### 🛡️ Full-Depth Layer

**B7. Agent Failure & Fallback Strategy**

> **Agent 失败时的处理策略？ / How should agents handle failures?**
>
> Agent 失败指 Agent 遇到工具报错、无法完成任务、或收到模糊不清的指令等情况。需要预先定义遇到这种情况时该怎么办，避免 Agent 静默地做出错误决策。
> *(Agent failure means the agent encounters a tool error, can't complete a task, or receives unclear instructions. Defining a fallback strategy prevents agents from silently making wrong decisions.)*
>
> A) **静默失败并记录 / Silent fail and log**
>    - Agent 遇到失败时不中断流程，将失败信息写入 `MEMORY.md` 的错误记忆，继续执行其他任务。适合非关键任务。
>    *(On failure, the agent doesn't stop - it logs the failure to `MEMORY.md` error memory and continues. Suitable for non-critical tasks.)*
>
> B) **暂停并请求用户干预 / Pause and request human intervention**
>    - Agent 遇到失败时立即停止，向用户报告问题并等待指示，不自行做出假设。适合对准确性要求高的场景。
>    *(On failure, the agent immediately stops, reports the problem to you, and waits for instructions - no assumptions made. Best when accuracy is critical.)*
>
> C) **人工降级到备用 Agent / Human-directed fallback to backup agent**
>    - 主 Agent 失败时，在 `MEMORY.md` 记录失败详情，并向用户发出明确提示，**由用户决定**是否切换到备用 Agent 继续任务。备用 Agent 通过读取 `MEMORY.md` 获取上下文后接手。注意：Agent 之间无法自动切换，切换动作由人类执行。
>    *(On failure, log details to `MEMORY.md` and alert the user clearly - **the user decides** whether to switch to a backup agent. The backup agent picks up context from `MEMORY.md`. Note: agents cannot switch to each other automatically; the handoff is human-executed.)*
>
> D) **自定义回退逻辑 / Custom fallback**
>    - 请描述你希望的失败处理方式。
>    *(Please describe your preferred failure handling approach.)*

**B8. Audit & Logging Requirements**

> **需要审计和日志记录吗？ / Do you need audit and logging?**
>
> 审计日志记录"谁在什么时间做了什么事"，用于追溯问题、合规要求，或者仅仅是了解 Agent 的行为历史。日志越详细，追溯能力越强，但存储和维护成本也越高。
> *(An audit log records "who did what and when" - useful for tracing issues, compliance requirements, or simply understanding what the agents have done. More detail = better traceability, but higher storage and maintenance cost.)*
>
> A) **不需要 / No audit logging**
>    - 不记录 Agent 的操作历史。适合个人项目或对追溯没有要求的场景。
>    *(No record of agent actions. Fine for solo projects or where traceability isn't required.)*
>
> B) **轻量日志 / Lightweight logging**
>    - 只在 `MEMORY.md` 的决策记忆中记录关键决策，不单独建立日志文件。低成本，够用于一般项目。
>    *(Only key decisions are logged in `MEMORY.md` decision memory - no separate log file. Low overhead, sufficient for most projects.)*
>
> C) **结构化日志 / Structured logging**
>    - 创建独立的审计日志文件 `AUDIT_LOG.md`，每次改变状态的操作记一行：时间戳、执行的 Agent、动作、对象和结果。适合团队项目。
>    *(A separate audit log, `AUDIT_LOG.md`, with one line per state-changing action: timestamp, agent, action, target, and outcome. Good for team projects.)*
>
> D) **完整审计链 / Full audit trail**
>    - 在 C 的基础上，每行再记录输入和输出；日志只追加，并始终纳入 git 跟踪，改动旧行会在历史里留下痕迹。真正的"不可篡改"需要文字之外的保证（受保护分支、CI 检查、外部日志存储），见 B10。适合对合规或安全有要求的项目。
>    *(C plus the inputs and output on every line. The log is append-only and always tracked in git, so an edit to an old line shows in history. True immutability needs a guarantee outside the prose - a protected branch, a CI check, an external log store - see B10. For compliance- or security-sensitive projects.)*

**B9. Memory Expiry & Cleanup Policy**

> **记忆过期与清理策略？ / What memory expiry and cleanup policy do you need?**
>
> `MEMORY.md` 会随项目推进不断积累内容。过期策略决定哪些记忆需要定期清理或归档，避免文件无限膨胀，也避免 Agent 读取到过时的信息。
> *(`MEMORY.md` grows as the project progresses. An expiry policy decides which memories to periodically clean up or archive - preventing the file from growing endlessly and preventing agents from reading stale information.)*
>
> A) **事件驱动-标准 / Event-driven standard (recommended)**
>    - 在关键工作流节点自动整理：交付前（Handoff）强制整理、容量软上限触发压缩（行数与字节双重判定：单个表格单元超 2 KB，或整份文件超 32 KB）、手动 `MEMORY CLEANUP`、项目归档终轮。清理即“压缩或标记”（Superseded/Promoted），几乎不直接删除，每次清理写入 Cleanup Log 审计行。
>    *(Cleanup fires on workflow events - mandatory consolidation at handoff, size soft ceilings (row counts **and** bytes: any single table cell over 2 KB, or the whole file over 32 KB - a 40 KB cell is one row on one line, so row counts alone never see it), manual MEMORY CLEANUP, a final pass at archive. Cleanup condenses or marks (Superseded/Promoted) rather than deleting; every pass appends one Cleanup Log audit line.)*
>
> B) **事件驱动 + 时间窗 / Event-driven + time-window**
>    - 在 A 的基础上，对已标记 Resolved/Promoted/Superseded 的条目按固定时间窗（如 90 天）额外压缩一次。
>    *(A plus periodic condensation of entries already marked Resolved/Promoted/Superseded - e.g. every 90 days.)*
>
> C) **事件驱动 + 迭代复审 / Event-driven + iteration review**
>    - 在 A 的基础上，每次重入 PHASE 1 开启新迭代时强制先复审记忆，标记被新方向取代的决策。
>    *(A plus a mandatory memory review whenever PHASE 1 restarts for a new iteration - superseded decisions are marked before new work begins.)*
>
> D) **自定义分类保留 / Custom per-category retention**
>    - 各类记忆采用不同的保留规则，请描述你的分类保留方案。
>    *(Different retention rules per memory type - please describe your per-category scheme.)*

**B10. Rule Enforcement Level**

> **哪些规则必须"被保证执行"，而不只是"被要求执行"？ / Which rules must be *guaranteed* rather than merely *requested*?**
>
> 写在指令文件里的规则，本质上是对模型的一个**请求**：大多数时候会被遵守，但不是每一次。真正的**保证**来自 harness（运行 Agent 的那个程序）：权限规则、生命周期钩子、CI 步骤。任何"必须每次都发生"的规则，都应该放在确定性层，无论措辞写得多强硬。典型例子：文件编码规范、提交前清理临时文件、禁止修改生产配置。
> *(A rule written in an instruction file is a **request** to a probabilistic model - followed most of the time, which is not the same as always. A **guarantee** comes from the harness (the program running the agent): permission rules, lifecycle hooks, CI steps. Anything that must happen every single time belongs in the deterministic layer, no matter how firmly the prose is worded. Typical cases: file-encoding rules, clearing temp files before a commit, never touching production config.)*
>
> A) **全部保持提示级 / All rules stay prose-level**
>    - 不区分层级，所有规则都写在指令文件里。跨运行时最安全，但没有任何规则是被强制的。适合低风险项目或早期探索。
>    *(No distinction - every rule lives in the instruction file. Safest across runtimes, but nothing is enforced. Fine for low-risk or exploratory projects.)*
>
> B) **标注并为每条命名机制 / Mark the absolutes and name a mechanism for each (recommended)**
>    - 识别出所有"绝对性"规则（总是/从不/每次/必须），逐条标注：要么写明由哪个机制保证（权限规则、钩子、CI 步骤、评审门禁），要么明确记录"这是提示级请求"。不生成任何配置代码——但从此没有一条绝对规则的执行状态是含糊的。
>    *(Identify every rule phrased as an absolute (always / never / every time / must) and annotate each one: either name the mechanism that enforces it - permission rule, hook, CI step, review gate - or record explicitly that it is a prose-level request. No config code is generated, but no absolute rule is left with an ambiguous enforcement status.)*
>
> C) **B + 输出待接线清单 / B plus a wiring checklist**
>    - 在 B 的基础上，额外产出一份清单文件，列出每条需要保证的规则、建议的机制类型和接入位置，由你手工接到 harness 或 CI 中。
>    *(B plus a checklist file listing each rule needing a guarantee, the suggested mechanism type, and where it would attach - you wire it into your harness or CI yourself.)*
>
> D) **自定义 / Custom**
>    - 请描述你希望的规则分层方式。
>    *(Please describe how you want rules layered.)*
>
> ⚠️ **本工作流不生成 harness 配置或 shell 代码。** 钩子与权限规则的名称、格式在各运行时之间不同（且会随版本变化），生成一份可能已经过时的配置，比诚实地交出一份接线清单更糟。B 与 C 产出的是**决策记录**，接线动作由你执行。
> *(This workflow does not generate harness config or shell code. Hook event names, settings keys and permission syntax differ between runtimes and change between versions; shipping config that may already be stale is worse than handing you an honest checklist. B and C produce a **decision record** - the wiring is yours to do.)*

If B, C or D, also ask, and never guess the answer:

> **这个项目里已经有哪些保证机制？ / Which guarantees already exist in this project?**
>
> 例如权限规则、钩子、CI 步骤、评审门禁。请逐条说出名字和位置；没有说到的规则，一律记为"提示级请求"。
> *(For example permission rules, hooks, CI steps, review gates. Name each one and where it lives; any rule you do not name is recorded as a prose-level request.)*
