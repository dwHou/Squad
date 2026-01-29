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

## Configuration Files

```
~/.claude/rules/00-squad-core.md    # This file (auto-loaded)
~/.claude/agents/                    # Agent definitions
~/.claude/commands/squad.md          # /squad command
~/.squad/router.yaml                 # Routing rules (extensible)
~/.squad/config.yaml                 # User config
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
