# Squad Core Rules

**Version:** 0.1.0 (MVP)
**Purpose:** Token-efficient multi-agent orchestration for Claude Code

---

## Overview

Squad is a lightweight multi-agent framework that coordinates specialized AI agents through intelligent task routing. Unlike parallel execution systems, Squad prioritizes **token efficiency** through **serial execution** and **smart routing**.

**Core Principle:** Right agent, right task, minimal overhead.

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

### 1. Researcher / 研究员
**Purpose:** Explore codebase, search files, understand architecture

**Tags:**
- `codebase` (default) - General code exploration
- `documentation` - Find and read documentation

**Tools:** Read, Glob, Grep, WebSearch
**Model:** Haiku (cost-efficient)

---

### 2. Engineer / 工程师
**Purpose:** Implement features, fix bugs, write code

**Tags:**
- `fullstack` (default) - General implementation
- `frontend` - UI/UX, components, styling
- `backend` - APIs, databases, server logic

**Tools:** Read, Write, Edit, Bash, Glob, Grep
**Model:** Sonnet (default), Opus (complex tasks)

---

### 3. Tester / 测试员
**Purpose:** Run tests, verify results, check builds

**Tags:**
- `unit` (default) - Unit tests
- `integration` - Integration tests
- `e2e` - End-to-end tests

**Tools:** Read, Bash, Glob
**Model:** Haiku (cost-efficient)

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

**Default (token-efficient):**
```
→ Engineer:frontend
```

**Verbose mode (`--verbose`):**
```
→ Task analysis:
  - Keywords detected: [button, login, fix]
  - Matched pattern: frontend
→ Routing: Engineer:frontend
```

---

## Command Syntax

### Basic Usage
```bash
/squad [task description]
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

## Configuration Files

```
~/.claude/rules/00-squad-core.md    # This file (auto-loaded)
~/.claude/agents/                    # Agent definitions
~/.claude/commands/
    ├── squad.md                     # /squad command
    ├── config.md                    # /squad config command
    └── reflect.md                   # /squad reflect command
~/.claude/skills/                    # Skill definitions
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

## Version History

- **v0.1.0** (MVP) - Basic routing, 3 agents, tag system
