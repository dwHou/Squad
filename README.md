# Squad

> **Token-efficient multi-agent orchestration for Claude Code**

[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](https://github.com/yourusername/squad/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**[English](#)** | **[中文](README.zh.md)**

---

## What is Squad?

**Squad** is a lightweight multi-agent framework designed for **Claude Code** and **Cursor IDE**. Instead of running multiple agents in parallel (expensive!), Squad uses **intelligent routing** and **serial execution** to coordinate specialized agents efficiently.

Think of it as **leading a focused engineering team** where each member has a specific role, and tasks are assigned to the right person at the right time.

**✨ Multi-IDE Support:**
- ✅ **Claude Code** - Full support
- ✅ **Cursor IDE** - Full support
- 🔄 **Auto-detection** - Squad automatically detects your IDE at runtime

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

## ✨ Key Features

### 🎯 Routing Visibility
**NEW!** Every task shows which agent handles it before execution:
```
🎯 @engineer:frontend
```
See Squad's decision-making in real-time.

### 🔄 Persistent Mode
Enter Squad mode once, use it continuously without typing `/squad` every time:
```bash
/squad                  # Enter persistent mode
fix login button        # Auto-routed
add dark mode           # Auto-routed
/exit                   # Exit when done
```

### 🛡️ Permission Levels
Choose how autonomous Squad agents should be:
- **Conservative** - Ask before every operation (safe)
- **Balanced** - Auto-allow common ops, ask for critical ones (recommended)
- **Autonomous** - Full automation for 24+ hour tasks

### 🧠 Self-Evolution
Squad learns from your feedback and improves itself:
```bash
/squad reflect          # Analyze conversation, propose improvements
/squad rollback <id>    # Undo changes if needed
```

### 🏃 Serial Execution
Agents run one at a time, minimizing token consumption while maintaining quality.

### 🏷️ Tag System
Each agent supports specialized tags (e.g., `engineer:frontend`, `engineer:backend`) without agent explosion.

### 🌐 Bilingual Support
Full English and Chinese support. Switch languages with one command.

### 📈 Extensible Design
Start simple, grow as needed. Clean separation between routing logic and agent definitions.

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
1. Install to **both** Claude Code (`~/.claude/`) and Cursor IDE (`~/.cursor/`)
2. Copy rules, agents, and commands to both IDE directories
3. Create shared router config in `~/.squad/`
4. Optionally add file permissions for both IDEs

**Note:** Squad automatically detects which IDE you're using at runtime - no configuration needed!

### First-Time Setup

Run the configuration wizard:

```bash
/squad config
```

Choose:
1. **Language** - English or 中文
2. **Permission Level** - Conservative, Balanced, or Autonomous

### Usage Modes

#### 🔄 Persistent Mode (Recommended)

Enter Squad mode once, use continuously:

```bash
# Enter persistent mode
/squad

# Now all your messages are auto-routed
fix login button                    → 🎯 @engineer:frontend
optimize database queries           → 🎯 @engineer:backend
find authentication implementation  → 🎯 @researcher:codebase

# Exit when done
/exit
```

**Benefits:**
- ✅ No need to type `/squad` every time
- ✅ Natural conversation flow
- ✅ Perfect for extended development sessions

#### ⚡ Single-Shot Mode

For quick one-off tasks:

```bash
/squad fix login button             → Execute once and exit
/squad @engineer:backend optimize   → Manual agent selection
```

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

## 🎯 Routing System

### How Routing Works

Squad analyzes your task description and routes it to the appropriate agent:

```
Task: "fix login button"
  ↓
Keywords detected: [button, login, fix]
  ↓
Match: frontend (button → UI work)
  ↓
Route: Engineer:frontend  🎯
  ↓
Execute with frontend-specific instructions
```

### Routing Visibility

**Every task shows the routing decision:**

```bash
/squad fix login button
🎯 @engineer:frontend

/squad optimize database query
🎯 @engineer:backend

/squad find auth code
🎯 @researcher:codebase
```

**Verbose mode** shows detailed analysis:

```bash
/squad --verbose fix login button

🎯 Squad 路由分析
   任务关键词: [button, login, fix]
   匹配模式: frontend
   置信度: 高

→ @engineer:frontend
```

### Automatic vs Manual Routing

**Automatic (recommended):**
```bash
/squad fix login button
→ Auto-detects: Engineer:frontend
```

**Manual (precise control):**
```bash
/squad @engineer:frontend add dark mode
→ Force: Engineer:frontend
```

---

## 📋 Commands Reference

### `/squad` - Enter Persistent Mode
```bash
/squad
```
Enters persistent mode where all messages are auto-routed.

### `/squad [task]` - Single-Shot Execution
```bash
/squad fix login button
```
Execute one task and exit.

### `/squad config` - Configuration Wizard
```bash
/squad config
```
Interactive wizard to configure language and permission level.

### `/squad reflect` - Performance Analysis
```bash
/squad reflect
/squad 回顾  # Chinese alias
```
Analyze conversation performance and propose improvements.

### `/squad rollback` - Undo Changes
```bash
/squad rollback <session_id>
/squad rollback last
```
Rollback evolution changes.

### `/squad --verbose` - Show Routing Details
```bash
/squad --verbose [task]
```
Display detailed routing analysis.

### `/squad --help` - Show Help
```bash
/squad --help
```
Display comprehensive help message.

### `/squad set-lang` - Switch Language
```bash
/squad set-lang zh    # Switch to Chinese
/squad set-lang en    # Switch to English
```

### `/exit` - Exit Persistent Mode
```bash
/exit
/quit
/squad exit
```
Exit Squad persistent mode.

---

## ⚙️ Configuration

### Language Settings

Configure via wizard:
```bash
/squad config
```

Or manually edit `~/.squad/config.yaml`:
```yaml
language: zh  # en | zh
```

### Permission Levels

#### 🛡️ Conservative (保守)
**Philosophy:** Safety first, manual control

**Behavior:**
- ✋ Ask before creating any file
- ✋ Ask before editing any file
- ✋ Ask before all commands
- ✋ Ask before git operations
- ✅ Auto-allow: Read, Glob, Grep

**Best for:**
- Learning Squad
- Critical projects
- Strict change management

---

#### ⚖️ Balanced (平衡) - **Recommended**
**Philosophy:** Trust but verify critical operations

**Behavior:**
- ✅ Auto-allow: Create/edit files, run tests, git commit
- ✋ Ask before: Deleting files, git push, destructive commands
- ✋ Ask before: Config changes

**Best for:**
- Daily development
- Most projects
- Balancing speed and safety

---

#### 🚀 Autonomous (自主)
**Philosophy:** Full automation, minimal interruption

**Behavior:**
- ✅ Auto-allow: All operations
- ⚠️ Logging: All actions logged
- 🛟 Safety net: Auto-backup before destructive ops

**Best for:**
- Long-running projects (24+ hours)
- Prototyping
- Trusted automation
- Solo projects

**⚠️ Warning:** Use with caution. Requires high trust level.

---

### Router Customization

Edit `~/.squad/router.yaml` to customize routing:

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

## Examples

### Example 1: Fix a Bug

```bash
/squad fix the login button not responding

🎯 @engineer:frontend

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

🎯 @researcher:codebase

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

🎯 @tester:unit

[Agent runs test suite]
[Parses results]
[Reports status]

✅ Test Results:
  - Total: 42 tests
  - Passed: 42 ✅
  - Failed: 0
  - Build: ✅ Success
```

### Example 4: Persistent Mode Workflow

```bash
# Enter persistent mode
/squad

# Work on multiple tasks naturally
fix login button              → 🎯 @engineer:frontend
optimize database queries     → 🎯 @engineer:backend
run all tests                 → 🎯 @tester:unit
find API documentation        → 🎯 @researcher:documentation

# Exit when done
/exit
```

---

## Roadmap

### v0.1.0 (MVP) ✅
- [x] 3 core agents (Researcher, Engineer, Tester)
- [x] Tag system for specialization
- [x] Keyword-based routing
- [x] Bilingual support (EN/ZH)
- [x] Serial execution

### v0.2.0 (Enhanced UX) ✅
- [x] Persistent mode
- [x] Routing visibility (🎯 display)
- [x] Configuration wizard
- [x] Permission levels (3 modes)
- [x] Reflection & evolution system

### v0.3.0 (Advanced Routing)
- [ ] Pattern matching (regex)
- [ ] Confidence scoring
- [ ] User confirmation for low confidence
- [ ] Routing analytics

### v0.4.0 (More Agents)
- [ ] Architect agent (system design)
- [ ] Reviewer agent (code review)
- [ ] Security specialist
- [ ] Performance optimizer

### v0.5.0 (Advanced Features)
- [ ] Multi-agent workflows (serial chains)
- [ ] Context persistence
- [ ] Learning from corrections
- [ ] Project-specific routing

See [ROADMAP.md](ROADMAP.md) for details.

---

## Project Structure

```
squad/
├── README.md                    # English documentation
├── README.zh.md                 # Chinese documentation
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
│   ├── commands/                # Command implementations
│   │   ├── squad.md            # /squad command
│   │   ├── config.md           # /squad config
│   │   ├── reflect.md          # /squad reflect
│   │   └── exit.md             # Exit command
│   │
│   ├── skills/                  # Skills
│   │   └── translate.md        # Translation skill
│   │
│   └── router/
│       └── router.yaml         # Routing rules (extensible)
│
└── tests/                       # Tests (coming soon)
    └── test_router.py
```

**After installation:**

Squad installs to **both** IDE directories:

**Claude Code:**
```
~/.claude/
├── rules/00-squad-core.md      # Auto-loaded by Claude Code
├── agents/                      # Available to Task tool
│   ├── researcher.md
│   ├── engineer.md
│   └── tester.md
├── commands/                    # Squad commands
│   ├── squad.md
│   ├── config.md
│   ├── reflect.md
│   └── exit.md
└── skills/                      # Squad skills
    └── translate.md
```

**Cursor IDE:**
```
~/.cursor/
├── rules/00-squad-core.md       # Auto-loaded by Cursor
├── agents/                      # Available to Task tool
│   ├── researcher.md
│   ├── engineer.md
│   └── tester.md
├── commands/                    # Squad commands
│   ├── squad.md
│   ├── config.md
│   ├── reflect.md
│   └── exit.md
└── skills/                      # Squad skills
    └── translate.md
```

**Shared Configuration (both IDEs):**
```
~/.squad/
├── config.yaml                  # User configuration
├── router.yaml                  # Routing rules
├── session.yaml                 # Persistent mode session
├── evolution/                   # Evolution logs
├── backups/                     # Backup files
└── logs/                        # Action logs (autonomous mode)
```

**Runtime Detection:**
When you run `/squad`, it automatically detects whether you're in Claude Code or Cursor IDE and uses the correct directory.

---

## FAQ

### Why not just use Claude directly?

You can! Squad is for when you want:
- **Specialized behavior** (frontend vs backend)
- **Consistent quality** (dedicated agent for testing)
- **Better organization** (clear separation of concerns)
- **Routing visibility** (see decision-making process)

### Why serial instead of parallel?

**Token efficiency.** Running 5 agents in parallel consumes 5x tokens. For most development tasks, serial execution is fast enough and much cheaper.

### How do I know which agent handled my task?

Squad shows routing decisions with 🎯 before execution:
```
🎯 @engineer:frontend
```

### Can I customize routing rules?

Yes! Edit `~/.squad/router.yaml` to add keywords, patterns, and weights.

### What's the difference between modes?

- **Persistent Mode** - Stay in Squad, all messages auto-routed (recommended)
- **Single-Shot Mode** - Run one task and exit

### How does the permission system work?

Choose a permission level in `/squad config`:
- **Conservative** - Ask before every operation
- **Balanced** - Auto-allow common ops, ask for critical ones (recommended)
- **Autonomous** - Full automation for long tasks

### Can Squad improve itself?

Yes! Use `/squad reflect` to analyze performance and apply improvements. Use `/squad rollback` to undo changes.

### Can I add my own agents?

Yes! See [CLAUDE.md](CLAUDE.md) for developer guide.

### Does it work with other Claude Code tools?

Yes! Squad is just a command and some agents. Use it alongside other skills and commands.

### Is Squad multilingual?

Yes! Full English and Chinese support. Use `/squad config` or `/squad set-lang` to switch.

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
