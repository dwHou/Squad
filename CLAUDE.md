# Squad Development Guide (for Claude)

> This file provides context for Claude (or other AI assistants) to develop and extend Squad correctly.

---

## Core Concepts

### What is Squad?

Squad is a **token-efficient multi-agent orchestration framework** for Claude Code. Unlike Wukong (which emphasizes parallel execution), Squad prioritizes:

1. **Token efficiency** - Serial execution, one agent at a time
2. **Simplicity** - Keyword routing, not complex DAGs
3. **Gradual complexity** - Start with 3 agents, add features as needed
4. **Clear boundaries** - Each agent has specific tools and responsibilities

---

## Architecture Overview

```
User
  ↓
/squad command (commands/squad.md)
  ↓
Router (keyword matching via router.yaml)
  ↓
Agent selection + Tag injection
  ↓
Task tool invocation (Claude Code native)
  ↓
Agent execution (agents/*.md)
  ↓
Results back to user
```

**Key Insight:** Squad is a **thin orchestration layer** on top of Claude Code's native Task tool. It doesn't replace the Task tool—it intelligently decides when and how to use it.

---

## Directory Structure

```
Squad/
├── squad-dist/              # Source files (edit here!)
│   ├── rules/
│   │   └── 00-squad-core.md        # Core rules (auto-loaded by Claude Code)
│   │
│   ├── agents/              # Agent definitions
│   │   ├── researcher.md
│   │   ├── engineer.md
│   │   └── tester.md
│   │
│   ├── commands/
│   │   └── squad.md         # /squad command implementation
│   │
│   └── router/
│       └── router.yaml      # Routing rules (extensible)
│
├── install.sh               # Installation script
├── README.md                # User-facing documentation
├── ROADMAP.md               # Feature roadmap
└── CLAUDE.md                # This file (development guide)
```

**After installation:**

```
~/.claude/
├── rules/00-squad-core.md   # Auto-loaded (defines Squad behavior)
├── agents/*.md              # Available to Task tool (subagent_type)
└── commands/squad.md        # /squad command (user entry point)

~/.squad/
├── config.yaml              # User configuration
└── router.yaml              # Routing rules (extensible)
```

---

## Development Workflow

### 1. Edit Source Files

```bash
# Edit files in squad-dist/
vim squad-dist/agents/engineer.md
vim squad-dist/router/router.yaml
```

### 2. Install to Local Claude

```bash
# Sync changes to installed location
./install.sh

# Or clean install (removes old files first)
./install.sh --clean
```

### 3. Test Changes

```bash
# In Claude Code
/squad test task

# Verify routing
/squad --verbose test task
```

### 4. Commit Changes

```bash
git add squad-dist/
git commit -m "Add new feature"
git push
```

**Important:** Always edit `squad-dist/`, not `~/.claude/` directly. The source of truth is the repo.

---

## Key Files Explained

### `squad-dist/rules/00-squad-core.md`

**Purpose:** Core rules that define Squad's behavior. Auto-loaded by Claude Code.

**What it contains:**
- Overview of Squad architecture
- Agent definitions (high-level)
- Routing rules (high-level)
- Command syntax
- Execution model

**When to edit:**
- Adding new agents (update agent list)
- Changing routing priorities
- Updating core behavior

**Example change:**
```markdown
# Add new agent to list
### 4. Architect / 架构师
**Purpose:** System design and technical decisions
**Tags:** system, database, api
**Model:** Opus
```

---

### `squad-dist/agents/*.md`

**Purpose:** Detailed agent definitions. These files are read by the Task tool when spawning agents.

**What each contains:**
- Agent role and purpose
- Tag-specific behavior
- Available tools
- Working style and best practices
- Output format
- Examples

**When to edit:**
- Changing agent behavior
- Adding new tags
- Updating tool permissions
- Refining instructions

**Example change:**
```markdown
# Add new tag to engineer.md

### Tag: `mobile`

**Focus:** Mobile app development (iOS, Android, React Native)

**Responsibilities:**
- Build mobile UI components
- Handle mobile-specific APIs
- Optimize for mobile performance
```

---

### `squad-dist/commands/squad.md`

**Purpose:** Implementation of the `/squad` command. This is the user's entry point.

**What it contains:**
- Command parsing logic
- --help implementation
- Routing logic (calls router.yaml)
- Agent invocation
- Error handling

**When to edit:**
- Adding new command options
- Changing help text
- Modifying routing algorithm
- Adding new features

**Example change:**
```markdown
# Add new option

### `--dry-run` Flag

Shows what agent would be selected without executing:

```bash
/squad --dry-run fix login button
→ Would route to: Engineer:frontend
```
```

---

### `squad-dist/router/router.yaml`

**Purpose:** Keyword-based routing rules. Extensible by users.

**What it contains:**
- Keywords for each agent/tag combination
- Default tags
- Comments for future extensibility

**When to edit:**
- Adding new keywords
- Adding new tags
- Refining routing accuracy
- Adding patterns (Phase 2)

**Example change:**
```yaml
engineer:
  frontend:
    keywords:
      # ... existing keywords ...
      - svelte        # Add new framework
      - solid         # Add new framework
      - qwik          # Add new framework
```

---

## Adding a New Agent

### Step 1: Create Agent Definition

```bash
# Create new file
touch squad-dist/agents/architect.md
```

**Template:**
```markdown
# Architect Agent / 架构师

**Type:** `architect` / `架构师`
**Model:** Opus
**Purpose:** System design and technical decisions

---

## Role Definition
[Description of agent's role]

---

## Tag-Specific Behavior

### Tag: `system` (default)
[Behavior description]

---

## Available Tools
[List of tools]

---

## Best Practices
[Guidelines]
```

### Step 2: Update Core Rules

Edit `squad-dist/rules/00-squad-core.md`:

```markdown
### 4. Architect / 架构师
**Purpose:** System design and technical decisions

**Tags:**
- `system` (default) - High-level architecture
- `database` - Database schema design

**Tools:** Read, Write, Glob, Grep
**Model:** Opus
```

### Step 3: Update Router

Edit `squad-dist/router/router.yaml`:

```yaml
architect:
  system:
    keywords:
      - architecture
      - design
      - system design
      - high-level
      - tech stack
    default: true

  database:
    keywords:
      - schema
      - database design
      - data model
```

### Step 4: Update Command Help

Edit `squad-dist/commands/squad.md` to include new agent in help text.

### Step 5: Install and Test

```bash
./install.sh --clean
# Test in Claude Code
/squad design user authentication system
```

---

## Adding a New Tag

### Step 1: Update Agent Definition

Edit the agent's `.md` file to add tag-specific behavior:

```markdown
### Tag: `mobile`

**Focus:** Mobile app development

**Responsibilities:**
- Build mobile UI components
- Handle mobile-specific APIs
- Optimize for mobile performance

**Example prompts:**
- "Add push notifications"
- "Implement offline mode"
```

### Step 2: Update Router Keywords

Edit `router.yaml`:

```yaml
engineer:
  mobile:
    keywords:
      - mobile
      - ios
      - android
      - react native
      - flutter
      - push notification
      - offline
```

### Step 3: Test

```bash
/squad add push notifications
→ Engineer:mobile
```

---

## Modifying Routing Logic

### Current Implementation (MVP)

**Simple keyword matching:**

```python
def route(task):
    task_lower = task.lower()

    # Check explicit agent
    if "@agent" in task:
        return parse_explicit(task)

    # Load keywords from router.yaml
    rules = load_yaml("~/.squad/router.yaml")

    # Match keywords
    for agent, tags in rules.items():
        for tag, config in tags.items():
            keywords = config.get("keywords", [])
            if any(kw in task_lower for kw in keywords):
                return agent, tag

    # Fallback
    return "engineer", "fullstack"
```

### Future Enhancement (Phase 2)

**Pattern matching + confidence:**

```python
def route(task):
    # 1. Explicit agent
    # 2. Pattern matching (regex)
    # 3. Keyword matching with weights
    # 4. Confidence scoring
    # 5. User confirmation if low confidence
    # 6. Fallback
```

---

## Testing Guidelines

### Manual Testing

```bash
# Test automatic routing
/squad fix login button
→ Should route to: Engineer:frontend

/squad optimize database query
→ Should route to: Engineer:backend

/squad find authentication code
→ Should route to: Researcher:codebase

# Test manual override
/squad @engineer:backend fix login button
→ Should force: Engineer:backend

# Test help
/squad --help
→ Should show comprehensive help

# Test verbose
/squad --verbose fix login button
→ Should show routing details
```

### Automated Testing

(Coming in future versions)

```bash
# Run routing tests
python tests/test_router.py

# Run integration tests
./tests/integration_test.sh
```

---

## Common Pitfalls

### ❌ Wrong: Editing installed files directly

```bash
# DON'T do this
vim ~/.claude/agents/engineer.md
```

**Problem:** Changes will be lost on next install.

**Solution:** Edit source files in `squad-dist/`.

---

### ❌ Wrong: Overcomplicating routing

```python
# DON'T do this (yet)
def route(task):
    # Use ML model
    # Check project context
    # Analyze git history
    # Call external API
    ...
```

**Problem:** MVP should be simple. Complexity comes later.

**Solution:** Start with keyword matching. Add features in Phase 2+.

---

### ❌ Wrong: Breaking backward compatibility

```yaml
# DON'T do this
engineer:
  frontend:
    # Removed all old keywords!
    keywords: [only-new-keywords]
```

**Problem:** Users' existing tasks will break.

**Solution:** Add new keywords, don't remove old ones (unless deprecated).

---

## Design Principles

### 1. Token Efficiency First

**Always ask:** "Does this consume more tokens?"

**Example:**
- ✅ Serial execution (one agent at a time)
- ❌ Parallel execution (multiple agents)

### 2. Progressive Complexity

**Start simple, add complexity when needed.**

**Example:**
- v0.1: Keyword matching
- v0.2: Pattern matching
- v0.3: ML classification

### 3. User Choice

**Advanced features should be opt-in.**

**Example:**
```yaml
# Default: simple
routing: keywords

# Opt-in: advanced
routing: ml-classification
```

### 4. Clear Over Clever

**Readable code > clever hacks**

**Example:**
```python
# Good: Clear
if "button" in task:
    return "engineer", "frontend"

# Bad: Clever
return ("engineer", "frontend") if re.search(r'\b(button|ui|page)\b', task, re.I) else ("engineer", "fullstack")
```

### 5. Extensible by Default

**Design for future without implementing it now.**

**Example:**
```yaml
# MVP: Only keywords
engineer:
  frontend:
    keywords: [button, ui, page]

# Future: Patterns (commented out)
# patterns:
#   - "add .* to .* page"
```

---

## Version Control Best Practices

### Commit Messages

```bash
# Good
git commit -m "Add mobile tag to engineer agent"
git commit -m "Fix routing for authentication tasks"
git commit -m "Update help text for --verbose flag"

# Bad
git commit -m "Update stuff"
git commit -m "Fix bug"
```

### Branch Strategy

```bash
# Feature branches
git checkout -b feature/add-architect-agent
git checkout -b feature/pattern-matching
git checkout -b fix/routing-bug

# Merge to main when done
git checkout main
git merge feature/add-architect-agent
```

---

## Documentation Standards

### Agent Definitions

Every agent file must have:
- Clear role definition
- Tag-specific behavior
- Tool list with restrictions
- Best practices
- Examples
- Language support

### Configuration Files

Every YAML file must have:
- Version number
- Purpose comment
- Clear structure
- Examples
- Extensibility hooks (commented out)

### User-Facing Docs

Must include:
- What it does
- Why it exists
- How to use it
- Examples
- Common mistakes

---

## FAQ for Developers

### Q: How do I add a new keyword?

Edit `router.yaml`, add to appropriate section, test, commit.

### Q: How do I change agent behavior?

Edit agent's `.md` file in `squad-dist/agents/`, install, test.

### Q: How do I test changes?

Run `./install.sh`, then use `/squad` in Claude Code.

### Q: Can I add Python code for routing?

Not in MVP. Keep it YAML-based. Python routing comes in Phase 2.

### Q: How do I handle multilingual keywords?

Add both English and Chinese keywords to `router.yaml`.

---

## Getting Help

- **Issues:** [GitHub Issues](https://github.com/yourusername/squad/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/squad/discussions)
- **Code Review:** Submit a PR and request review

---

<p align="center">
  <b>Squad Development Guide</b><br>
  Building a token-efficient multi-agent framework
</p>
