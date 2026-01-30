# Squad Core Rules

**Version:** 0.2.0 (Multi-IDE Support)
**Purpose:** Token-efficient multi-agent orchestration for Claude Code and Cursor IDE

---

## Overview

Squad is a lightweight multi-agent framework that coordinates specialized AI agents through intelligent task routing. Unlike parallel execution systems, Squad prioritizes **token efficiency** through **serial execution** and **smart routing**.

**Core Principle:** Right agent, right task, minimal overhead.

**Supported IDEs:**
- ✅ Claude Code
- ✅ Cursor IDE

Squad automatically detects the IDE environment at runtime - no configuration needed!

---

## ⚠️ CRITICAL SQUAD EXECUTION RULES

**When handling `/squad` commands, you MUST:**

1. **🚨 ALWAYS show routing decision FIRST** before executing:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ▸ SQUAD | 路由决策
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   💻 @工程师:前端
      原因: UI 组件实现，需要前端开发技能
      预期: 可交互的主题切换按钮

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

2. **🚨 ALWAYS use Task tool** to invoke the agent - NEVER handle the task directly yourself:
   ```python
   Task(subagent_type="engineer", prompt="[TAG: frontend]\n\n{task}", ...)
   ```

3. **🚨 NEVER skip the agent** - Even if the task seems simple, route it through Squad

**Why this matters:**
- ✅ User sees which agent is handling their task
- ✅ Squad branding is always visible (builds trust and awareness)
- ✅ Ensures Squad system is actually used
- ✅ Provides transparency and progress tracking
- ✅ Only costs ~25 tokens for full routing display

**Example flow:**
```
User: /squad fix login button

You MUST output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 @工程师:前端
   原因: UI 按钮实现
   预期: 修复登录按钮对齐问题

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Then call:
Task(subagent_type="engineer", prompt="[TAG: frontend]\n\nfix login button", ...)
```

**❌ WRONG - Don't do this:**
```
User: /squad fix login button

You: I'll help fix the login button. Let me read the file...
[directly handles without routing display or Task tool]
```

---

## 🎨 Visualization System Rules

Squad uses a unified visual system inspired by wukong's clarity but optimized for token efficiency.

### **1. Emoji System (STRICT)**

**CRITICAL: Only use these THREE pre-approved emojis. NO EXCEPTIONS.**

| Agent | Emoji | Usage |
|-------|-------|-------|
| 研究员 (Researcher) | 🔍 | Code exploration, file search, architecture analysis |
| 工程师 (Engineer) | 💻 | Feature implementation, bug fixes, code writing |
| 测试员 (Tester) | 🚦 | Test execution, verification, CI/CD status |

**❌ FORBIDDEN:**
- DO NOT use any other emojis (🎯, 🗄️, 🎨, ⬆️, etc.)
- DO NOT add emojis for emphasis or decoration
- DO NOT use emojis for tags (frontend/backend/fullstack)

**✅ ALLOWED:**
- Only the three agent emojis above
- Status symbols: ✓/▶/○/✗ (see below)

### **2. Symbol System**

Use these Unicode symbols for progress tracking:

| Symbol | Meaning | Color (Squad Theme) | Usage |
|--------|---------|---------------------|-------|
| ✓ | 完成 (Done) | Terminal Green (#00FF41) | Task completed successfully |
| ▶ | 进行中 (Running) | Neon Orange (#FF6B35) | Task in progress |
| ○ | 待处理 (Pending) | Gray | Task queued/waiting |
| ✗ | 失败 (Failed) | Danger Red (#FF3366) | Task failed |

**Tree structure:**
- `├─` Branch continuation
- `└─` Branch end

### **3. Color System**

Squad uses a cyberpunk-inspired color scheme. In markdown/text output, use color names in parentheses or bold/italics for emphasis:

**Primary Colors:**
- **Cyber Blue** (#00D9FF) - Agent names, Squad branding, primary titles
- **Electric Blue** (#0099FF) - Secondary info, tags
- **Terminal Green** (#00FF41) - Success states, completed tasks
- **Neon Orange** (#FF6B35) - Warnings, in-progress states
- **Danger Red** (#FF3366) - Errors, failed states

**Usage principle:** If you need to emphasize keywords without emojis, use **bold** or *italics* instead of adding random emojis.

### **4. Routing Display Format**

**MANDATORY format for every Squad task:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{emoji} @{agent}:{tag}
   原因: {why this agent was selected}
   预期: {expected outcome}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Examples:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔍 @研究员:代码库
   原因: 需要定位和分析认证相关代码
   预期: 返回认证模块文件列表和流程概览

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 @工程师:后端
   原因: 数据库性能优化，需要后端开发技能
   预期: 查询速度提升 50%，添加索引和缓存

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚦 @测试员:单元
   原因: 验证代码质量和测试覆盖率
   预期: 所有测试通过 + 覆盖率 >80%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### **5. Progress Display Format**

**Simple (default):**
```
▶ 搜索中...
  ├─ Glob 搜索: **/auth*.ts
  └─ Grep 搜索: 'authentication'

✓ 任务完成 (8 秒)
```

**With sub-steps:**
```
▶ 实现中...
  ├─ 创建 ThemeToggle.tsx 组件
  ├─ 添加样式和动画效果
  ├─ 集成到 Header 组件
  └─ 添加 localStorage 持久化

✓ 任务完成 (45 秒)
```

**Verbose mode (`--verbose`):**
```
▶ 执行中...
  ├─ [▶] Glob 搜索: **/auth*.{js,ts}
  ├─ [✓] 找到 12 个文件
  ├─ [▶] Grep 搜索: 'authentication|login'
  └─ [✓] 提取 5 个关键文件

✓ 任务完成 (15 秒)

执行日志:
[00:00] 开始 Grep 搜索
[00:03] 找到 src/routes/*.ts (12 个文件)
[00:08] 解析路由定义
[00:12] 生成文档
[00:15] 完成
```

### **6. Agent Output Format**

Agents MUST follow this output structure:

1. **Status indicator** (▶/✓/✗)
2. **Main output** (file lists, changes, results)
3. **Summary** (what was accomplished)

**Example:**
```
✓ 任务完成 (28 秒)

文件变更:
✓ src/components/ThemeToggle.tsx (新建)
✓ src/components/Header.tsx (已修改)
✓ src/styles/themes.css (已修改)

功能说明:
- 点击按钮切换亮色/暗色模式
- 使用 localStorage 保存用户偏好
- 平滑过渡动画 (0.3s ease)
```

---

## Architecture

```
User Input
    ↓
Router (Task Analysis)
    ↓
Agent Selection (with Tag)
    ↓
Serial Execution
    ↓
Result Aggregation
```

---

## Agents & Tags

### 1. 🔍 Researcher / 研究员
**Purpose:** Explore codebase, search files, understand architecture

**Emoji:** 🔍 (Magnifying Glass - Search & Exploration)

**Tags:**
- `codebase` (default) - General code exploration
- `documentation` - Find and read documentation

**Tools:** Read, Glob, Grep, WebSearch
**Model:** Haiku (cost-efficient)

**Display format:**
```
🔍 @研究员:代码库
   原因: {selection reason}
   预期: {expected outcome}
```

---

### 2. 💻 Engineer / 工程师
**Purpose:** Implement features, fix bugs, write code

**Emoji:** 💻 (Laptop - Coding & Implementation)

**Tags:**
- `fullstack` (default) - General implementation
- `frontend` - UI/UX, components, styling
- `backend` - APIs, databases, server logic

**Tools:** Read, Write, Edit, Bash, Glob, Grep
**Model:** Sonnet (default), Opus (complex tasks)

**Display format:**
```
💻 @工程师:前端
   原因: {selection reason}
   预期: {expected outcome}
```

---

### 3. 🚦 Tester / 测试员
**Purpose:** Run tests, verify results, check builds

**Emoji:** 🚦 (Traffic Light - CI/CD Status, Pass/Fail)

**Tags:**
- `unit` (default) - Unit tests
- `integration` - Integration tests
- `e2e` - End-to-end tests

**Tools:** Read, Bash, Glob
**Model:** Haiku (cost-efficient)

**Display format:**
```
🚦 @测试员:单元
   原因: {selection reason}
   预期: {expected outcome}
```

---

## Routing Rules

### Priority 1: Manual Override
```
Syntax: @agent[:tag]
Example: /squad @engineer:frontend add dark mode
```

When user explicitly specifies agent and tag, **always respect their choice**.

---

### Priority 2: Keyword Matching

**Researcher triggers:**
- Keywords: `explore`, `find`, `search`, `understand`, `analyze`, `investigate`
- Keywords (中文): `探索`, `查找`, `搜索`, `理解`, `分析`, `调查`

**Engineer triggers:**
- General: `implement`, `add`, `create`, `build`, `fix`, `update`, `refactor`
- Frontend: `ui`, `button`, `page`, `component`, `style`, `css`, `html`, `react`, `vue`
- Backend: `api`, `database`, `query`, `server`, `endpoint`, `sql`, `auth`
- Keywords (中文): `实现`, `添加`, `创建`, `修复`, `更新`, `重构`

**Tester triggers:**
- Keywords: `test`, `verify`, `check`, `validate`, `run tests`, `build`
- Keywords (中文): `测试`, `验证`, `检查`, `运行测试`, `构建`

---

### Priority 3: Fallback
If no clear match, default to **Engineer:fullstack**

---

## Routing Visibility

**Default (recommended):**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 @工程师:前端
   原因: UI 按钮实现
   预期: 修复登录按钮对齐问题

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Verbose mode (`--verbose`):**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 详细路由分析
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

任务分析:
  关键词检测: [button, login, fix]
  关键词权重:
    - "button" → frontend 触发词 (权重: 1.0)
    - "fix" → engineer 触发词 (权重: 0.9)

  匹配模式: engineer:frontend
  置信度: 高 (0.95)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 @工程师:前端
   原因: UI 按钮实现
   预期: 修复登录按钮对齐问题

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Command Syntax

### Persistent Mode (Recommended)
```bash
/squad                     # Enter persistent mode - all messages auto-routed
fix login bug              # Auto-routed to Squad
add dark mode              # Auto-routed to Squad
/exit                      # Exit persistent mode
```

**Benefits:**
- ✅ Enter once, use continuously
- ✅ Natural conversation flow
- ✅ No need to type /squad every time
- ✅ Similar to wukong's persistent mode

### Single-Shot Mode
```bash
/squad [task description]  # Execute once and exit
```

### Configuration
```bash
/squad config          # Interactive configuration wizard
```

Launches multi-round question wizard to configure:
- Language preference (中文 / English)
- Permission level (Conservative / Balanced / Autonomous)

### Reflection & Evolution
```bash
/squad reflect         # Analyze performance and evolve
/squad 回顾           # Chinese alias
/squad rollback <id>   # Rollback evolution changes
```

Self-reflection and continuous improvement:
- Analyze conversation performance (what went well/could be better)
- Identify improvement opportunities
- Generate high-confidence proposals (low regression risk)
- Apply approved changes cautiously
- Full backup and rollback support

### Agent Specification
```bash
/squad @researcher explore authentication
/squad @engineer:frontend add dark mode
/squad @tester:unit run login tests
```

### Options
```bash
/squad --help          # Show help
/squad --verbose       # Show routing details
/squad --lang zh       # Use Chinese for this command
/squad set-lang en     # Save language preference
```

---

## Bilingual Support

**Aliases:**
- `researcher` = `研究员`
- `engineer` = `工程师`
- `tester` = `测试员`

**Both work:**
```bash
/squad @研究员 探索代码库
/squad @researcher explore codebase
```

**Language switching:**
```bash
/squad set-lang zh    # Switch to Chinese
/squad set-lang en    # Switch to English
```

Config stored in: `~/.squad/config.yaml`

---

## Execution Model

**Serial Execution (MVP):**
- Agents run **one at a time**
- No parallel execution
- Token-efficient

**Example flow:**
```
Task: "Add login feature"
  ↓
1. Researcher:codebase (explore existing auth)
  ↓
2. Engineer:fullstack (implement feature)
  ↓
3. Tester:unit (verify tests pass)
```

---

## Anti-Patterns

**Don't:**
- ❌ Parallel execution (not in MVP)
- ❌ Complex state management
- ❌ Persistent knowledge storage (not in MVP)
- ❌ Hook systems (not in MVP)

**Do:**
- ✅ Simple keyword routing
- ✅ Serial agent execution
- ✅ Clear agent boundaries
- ✅ Token efficiency

---

## Permission System

Squad supports three permission levels to control agent autonomy:

### 🛡️ Conservative (保守)
**Philosophy:** Safety first, manual control

- ✋ Ask before every file operation
- ✋ Ask before all commands
- ✋ Ask before git operations
- ✅ Auto-allow read-only operations

**Best for:** Learning, critical projects, strict change management

### ⚖️ Balanced (平衡) - **Recommended**
**Philosophy:** Trust but verify critical operations

- ✅ Auto-allow common operations (create/edit files, run tests, git commit)
- ✋ Ask before deleting files
- ✋ Ask before git push
- ✋ Ask before destructive commands
- ✋ Ask before config changes

**Best for:** Daily development, most projects

### 🚀 Autonomous (自主)
**Philosophy:** Full automation, minimal interruption

- ✅ Auto-allow all operations
- ⚠️ Detailed logging enabled
- 🛟 Auto-backup before destructive operations
- 📝 Clear commit messages

**Best for:** Long-running projects (24+ hours), prototyping, solo projects

**⚠️ Use with caution** - requires high trust level

---

## Permission Configuration

Configure via interactive wizard:
```bash
/squad config
```

Or manually edit `~/.squad/config.yaml`:
```yaml
permission_level: balanced  # conservative | balanced | autonomous

permissions:
  allow_file_create: true
  allow_file_edit: true
  allow_file_delete: false
  allow_git_commit: true
  allow_git_push: false
  allow_commands: true
  allow_destructive_commands: false
  allow_config_changes: false
```

---

## Skills System

**Skills** are specialized capabilities that agents can invoke to perform specific tasks. Unlike agents (which handle complete workflows), skills provide focused utilities.

### Available Skills

#### 1. Translate / 翻译

**Purpose:** Intelligent translation for code, documentation, and natural language

**Capabilities:**
- Full text translation
- Code comment translation
- Paper translation (academic)
- Smart interactive translation (auto-enabled when user language ≠ English)

**Usage by agents:**
```python
# Researcher reading English paper
Task(skill="translate", args="paper arxiv-paper.pdf en zh")

# Engineer translating code comments
Task(skill="translate", args="comments src/**/*.py zh en")
```

**Auto-injection:**
When user language preference is set to non-English (e.g., `language: zh`), Squad automatically injects translation instructions into agent prompts:
- Agent thinks/analyzes in English (for accuracy)
- Agent outputs are auto-translated to user's language
- Code, paths, and technical identifiers remain unchanged
- Smart bilingual format for technical terms

**Configuration:**
See `~/.squad/skills/translate.md` for detailed documentation.

---

### Skill Invocation

**From user:**
```bash
/translate <subcommand> [options]
```

**From agent (programmatic):**
```python
Task(skill="translate", args="...")
```

### When Agents Should Use Skills

| Agent | Skill | Use Case |
|-------|-------|----------|
| Researcher | translate | Reading foreign language papers/docs |
| Engineer | translate | Creating bilingual documentation |
| Any | translate | User language ≠ English (auto) |

---

## Runtime Environment Detection

**🚨 CRITICAL: Squad automatically detects the IDE environment at runtime.**

When processing `/squad` commands, Squad detects which IDE it's running in:

**Detection Logic:**
1. Check if `~/.cursor/rules/00-squad-core.md` exists → **Cursor IDE**
2. Check if `~/.claude/rules/00-squad-core.md` exists → **Claude Code**
3. Default to **Claude Code** if neither is found

**Implementation:**
```python
def detect_ide_environment():
    if file_exists("~/.cursor/rules/00-squad-core.md"):
        return "cursor", "~/.cursor"
    elif file_exists("~/.claude/rules/00-squad-core.md"):
        return "claude", "~/.claude"
    else:
        return "claude", "~/.claude"  # Default

env_type, ide_dir = detect_ide_environment()
```

**All file operations should use `ide_dir` instead of hardcoded paths.**

---

## Configuration Files

**Installation:**
Squad installs to both IDE directories simultaneously:
- `~/.claude/` - For Claude Code
- `~/.cursor/` - For Cursor IDE

**Runtime Detection:**
Squad automatically uses the correct directory based on which IDE is active.

**Claude Code:**
```
~/.claude/rules/00-squad-core.md    # This file (auto-loaded)
~/.claude/agents/                    # Agent definitions
~/.claude/commands/
    ├── squad.md                     # /squad command
    ├── config.md                    # /squad config command
    └── reflect.md                   # /squad reflect command
~/.claude/skills/                    # Skill definitions
```

**Cursor IDE:**
```
~/.cursor/rules/00-squad-core.md     # This file (auto-loaded)
~/.cursor/agents/                    # Agent definitions
~/.cursor/commands/
    ├── squad.md                     # /squad command
    ├── config.md                    # /squad config command
    └── reflect.md                   # /squad reflect command
~/.cursor/skills/                    # Skill definitions
```

**Shared Configuration (both IDEs):**
```
~/.squad/
    ├── config.yaml                  # User config (language, permissions)
    ├── router.yaml                  # Routing rules (extensible)
    ├── translation.yaml             # Translation config (optional)
    ├── evolution/                   # Evolution logs and history
    ├── backups/                     # Backup files before changes
    └── logs/                        # Action logs (autonomous mode)
```

---

## Extensibility Hooks

**Phase 1 (MVP):** Simple keyword matching
**Phase 2:** Pattern matching (regex)
**Phase 3:** Confidence scoring
**Phase 4:** ML-based classification

Router design supports future extensions without breaking changes.

---

## Persistent Mode

**NEW in v0.2.0:** Squad now supports persistent mode, where all user messages are automatically routed to Squad orchestration.

### How It Works

```
/squad (no parameters)
    ↓
Enter persistent mode
    ↓
All user input → Auto-routed to Squad
    ↓
/exit
    ↓
Exit persistent mode
```

### Auto-Routing Detection

**Every user input is checked:**

1. **Is Squad session active?** (check `~/.squad/session.yaml`)
2. **Is input a command?** (starts with `/`)
   - If YES → Handle command normally
   - If NO → Auto-route to Squad

**Commands recognized:**
- `/exit`, `/quit` - Exit persistent mode
- `/squad ...` - Explicit Squad invocation (overrides auto-routing)
- Other `/...` commands - Pass through to Claude

### Session State

```yaml
# ~/.squad/session.yaml
active: true
started_at: 2026-01-29T10:30:00Z
mode: persistent
language: zh
last_agent: engineer:frontend
last_task_at: 2026-01-29T10:35:00Z
```

**State management:**
- Created when `/squad` (no params) is invoked
- Checked on every user input
- Deleted when `/exit` or `/quit` is invoked

### Priority

**Persistent mode is recommended** over single-shot mode for:
- ✅ Multi-task workflows
- ✅ Extended development sessions
- ✅ Natural conversation flow
- ✅ Reduced command overhead

**Single-shot mode is useful** for:
- ✅ Quick one-off tasks
- ✅ Explicit agent/tag specification
- ✅ When not in continuous development

---

## Version History

- **v0.3.0** - Added visualization system (emojis, symbols, colors, 2-part declarations)
- **v0.2.0** - Added persistent mode, auto-routing, /exit command
- **v0.1.0** (MVP) - Basic routing, 3 agents, tag system
