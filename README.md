# Squad

> **Token-efficient multi-agent orchestration for Claude Code**

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/yourusername/squad/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## What is Squad?

**Squad** is a lightweight multi-agent framework designed for Claude Code. Instead of running multiple agents in parallel (expensive!), Squad uses **intelligent routing** and **serial execution** to coordinate specialized agents efficiently.

Think of it as **leading a focused engineering team** where each member has a specific role, and tasks are assigned to the right person at the right time.

```
User Request
     ↓
  Router  ────→  Right Agent, Right Task
     ↓
  Execute ────→  Token-efficient, Serial
     ↓
  Results ────→  Clear, Actionable
```

---

## Core Features

### 🎯 Smart Routing
Automatically routes tasks to the right agent based on keywords and patterns. No manual decision-making needed.

### 🏃 Serial Execution
Agents run one at a time, minimizing token consumption while maintaining quality.

### 🏷️ Tag System
Each agent supports specialized tags (e.g., `engineer:frontend`, `engineer:backend`) without agent explosion.

### 🌐 Bilingual Support
Full English and Chinese support. Switch languages with one command.

### 📈 Extensible Design
Start simple, grow as needed. Clean separation between routing logic and agent definitions.

---

## The Team

### 🔍 Researcher / 研究员
**Model:** Haiku (cost-efficient)

Explores codebase, searches files, understands architecture.

**Tags:**
- `codebase` (default) - General code exploration
- `documentation` - Find and read docs

**Example:**
```bash
/squad find authentication implementation
/squad @researcher:documentation locate API reference
```

---

### 💻 Engineer / 工程师
**Model:** Sonnet (balanced) / Opus (complex)

Implements features, fixes bugs, writes code.

**Tags:**
- `fullstack` (default) - General implementation
- `frontend` - UI/UX, components, styling
- `backend` - APIs, databases, server logic

**Example:**
```bash
/squad fix login button
/squad @engineer:frontend add dark mode
/squad @engineer:backend optimize database queries
```

---

### ✅ Tester / 测试员
**Model:** Haiku (cost-efficient)

Runs tests, verifies results, checks builds.

**Tags:**
- `unit` (default) - Unit tests
- `integration` - Integration tests
- `e2e` - End-to-end tests

**Example:**
```bash
/squad run tests
/squad @tester:unit verify login tests
/squad @tester:e2e test checkout flow
```

---

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/squad.git
cd squad

# Install
./install.sh

# Or clean install (remove old version first)
./install.sh --clean
```

The installer will:
1. Copy rules to `~/.claude/rules/`
2. Copy agent definitions to `~/.claude/agents/`
3. Copy commands to `~/.claude/commands/`
4. Create router config in `~/.squad/`
5. Optionally add file permissions

### Usage

```bash
# Basic usage - automatic routing
/squad fix login button
→ Engineer:frontend

/squad optimize database query
→ Engineer:backend

/squad find authentication code
→ Researcher:codebase

# Manual routing - precise control
/squad @engineer:frontend add dark mode toggle
/squad @researcher:documentation find setup guide
/squad @tester:unit run login tests

# Help and options
/squad --help
/squad --verbose [task]    # Show routing details
/squad set-lang zh         # Switch to Chinese
```

---

## How It Works

### Automatic Routing

Squad analyzes your task description and routes it to the appropriate agent:

```
Task: "fix login button"
  ↓
Keywords detected: [button, login, fix]
  ↓
Match: frontend (button → UI work)
  ↓
Route: Engineer:frontend
  ↓
Execute with frontend-specific instructions
```

### Routing Rules

Defined in `~/.squad/router.yaml`:

```yaml
engineer:
  frontend:
    keywords: [ui, button, page, component, style, css, react, vue]
  backend:
    keywords: [api, database, query, server, endpoint, sql, auth]
  fullstack:
    default: true
```

**Extensible:** Add your own keywords, patterns, and rules.

---

## Configuration

### `~/.squad/config.yaml`

```yaml
# Language preference
language: en  # en | zh

# Verbose mode
verbose: false

# Model overrides (optional)
# models:
#   researcher: haiku
#   engineer: sonnet
#   tester: haiku
```

### `~/.squad/router.yaml`

Customize routing rules by adding keywords, patterns, and weights.

---

## Design Philosophy

### 1. Token Efficiency First
- **Serial execution** over parallel
- **Smart routing** to minimize overhead
- **Lightweight agents** (Haiku where possible)

### 2. Progressive Complexity
- Start with **3 simple agents**
- Add tags instead of new agents
- Extend when you need it, not before

### 3. Clarity Over Magic
- **Visible routing decisions**
- **Clear agent boundaries**
- **Understandable rules**

### 4. Practical Over Perfect
- **Keyword matching** is enough for 90% of cases
- **Pattern matching** when you need it
- **ML classification** if you really need it

---

## Comparison

### vs. Parallel Multi-Agent Systems (e.g., Wukong)

| Feature | Parallel Systems | Squad |
|---------|------------------|-------|
| **Execution** | Multiple agents in parallel | One agent at a time (serial) |
| **Token Cost** | High (10+ agents running) | Low (1 agent per step) |
| **Speed** | Fast (concurrent) | Moderate (sequential) |
| **Complexity** | High (coordination, state) | Low (simple routing) |
| **Best For** | Complex workflows, research | Development tasks, cost-conscious |

**TL;DR:** Squad trades some speed for significant cost savings and simplicity.

---

## Roadmap

### v0.1.0 (MVP) ✅
- [x] 3 core agents (Researcher, Engineer, Tester)
- [x] Tag system for specialization
- [x] Keyword-based routing
- [x] Bilingual support (EN/ZH)
- [x] Serial execution

### v0.2.0 (Enhanced Routing)
- [ ] Pattern matching (regex)
- [ ] Confidence scoring
- [ ] User confirmation for low confidence
- [ ] Routing analytics

### v0.3.0 (More Agents)
- [ ] Architect agent (system design)
- [ ] Reviewer agent (code review)
- [ ] Security specialist
- [ ] Performance optimizer

### v0.4.0 (Advanced Features)
- [ ] Multi-agent workflows (serial chains)
- [ ] Context persistence
- [ ] Learning from corrections
- [ ] Project-specific routing

See [ROADMAP.md](ROADMAP.md) for details.

---

## Project Structure

```
squad/
├── README.md                    # This file
├── ROADMAP.md                   # Feature roadmap
├── CLAUDE.md                    # Developer guide (for Claude)
├── LICENSE                      # MIT License
├── install.sh                   # Installation script
│
├── squad-dist/                  # Source files
│   ├── rules/
│   │   └── 00-squad-core.md    # Core rules (auto-loaded by Claude Code)
│   │
│   ├── agents/                  # Agent definitions
│   │   ├── researcher.md       # Researcher agent
│   │   ├── engineer.md         # Engineer agent
│   │   └── tester.md           # Tester agent
│   │
│   ├── commands/
│   │   └── squad.md            # /squad command implementation
│   │
│   └── router/
│       └── router.yaml         # Routing rules (extensible)
│
└── tests/                       # Tests (coming soon)
    └── test_router.py
```

**After installation:**

```
~/.claude/
├── rules/00-squad-core.md      # Auto-loaded by Claude Code
├── agents/                      # Available to Task tool
│   ├── researcher.md
│   ├── engineer.md
│   └── tester.md
└── commands/squad.md            # /squad command

~/.squad/
├── config.yaml                  # User configuration
└── router.yaml                  # Routing rules
```

---

## Examples

### Example 1: Fix a Bug

```bash
/squad fix the login button not responding

→ Engineer:frontend

[Agent analyzes the issue]
[Locates button component]
[Identifies event handler issue]
[Fixes the code]
[Tests the fix]

✅ Fixed: onClick handler was missing in LoginButton.tsx
```

### Example 2: Explore Codebase

```bash
/squad find where user authentication is implemented

→ Researcher:codebase

[Agent searches for auth-related files]
[Reads key implementations]
[Traces dependencies]

📋 Authentication found in:
  - src/auth/login.ts:42 (main logic)
  - src/middleware/auth.ts:15 (middleware)
  - src/api/auth.ts:23 (API endpoints)
```

### Example 3: Run Tests

```bash
/squad verify all tests pass

→ Tester:unit

[Agent runs test suite]
[Parses results]
[Reports status]

✅ Test Results:
  - Total: 42 tests
  - Passed: 42 ✅
  - Failed: 0
  - Build: ✅ Success
```

---

## FAQ

### Why not just use Claude directly?

You can! Squad is for when you want:
- **Specialized behavior** (frontend vs backend)
- **Consistent quality** (dedicated agent for testing)
- **Better organization** (clear separation of concerns)

### Why serial instead of parallel?

**Token efficiency.** Running 5 agents in parallel consumes 5x tokens. For most development tasks, serial execution is fast enough and much cheaper.

### Can I add my own agents?

Yes! See [CLAUDE.md](CLAUDE.md) for developer guide.

### Can I customize routing rules?

Yes! Edit `~/.squad/router.yaml` to add keywords, patterns, and weights.

### Does it work with other Claude Code tools?

Yes! Squad is just a command and some agents. Use it alongside other skills and commands.

---

## Contributing

Contributions welcome! Please:

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Add tests (when available)
5. Submit a PR

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Inspiration

Squad was inspired by:
- **Wukong** - Multi-agent orchestration concept
- **Agile teams** - Specialized roles working together
- **Unix philosophy** - Do one thing well, compose tools

---

## Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/squad/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/squad/discussions)
- **Documentation:** See `~/.squad/` after installation

---

<p align="center">
  <b>Smart routing · Serial execution · Token efficient</b><br>
  Built for Claude Code developers who care about costs
</p>
