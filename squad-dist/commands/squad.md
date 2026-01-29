# Squad Command

**Command:** `/squad`
**Version:** 0.1.0 (MVP)
**Purpose:** Token-efficient multi-agent task orchestration

---

## Command Invocation

When the user types `/squad`, this command activates the Squad framework and handles task routing to specialized agents.

---

## Syntax

```bash
# Basic usage
/squad [task description]

# Agent specification
/squad @agent[:tag] [task description]

# Options
/squad --help
/squad --verbose [task]
/squad --lang <en|zh> [task]
/squad set-lang <en|zh>
```

---

## Behavior

### Step 1: Parse Command

**Extract components:**
- Options: `--help`, `--verbose`, `--lang`
- Agent override: `@engineer:frontend`
- Task description: remaining text

---

### Step 2: Handle Special Commands

#### `--help` Flag

Display comprehensive help message:

```
═══════════════════════════════════════════════════════
Squad - AI Multi-Agent Orchestration Framework
═══════════════════════════════════════════════════════

DESCRIPTION
  Squad is a token-efficient multi-agent framework for Claude Code.
  It coordinates specialized AI agents (Researcher, Engineer, Tester)
  to handle development tasks through intelligent routing and tagging.

  Features:
  • Automatic task routing based on keywords
  • Tag-based agent specialization (frontend/backend/etc)
  • Bilingual support (English/中文)
  • Token-efficient serial execution

USAGE
  /squad [OPTIONS] [TASK_DESCRIPTION]
  /squad @agent[:tag] [TASK_DESCRIPTION]

OPTIONS
  --help, -h           Show this help message
  --verbose, -v        Show detailed routing decisions
  --version            Show version information
  --lang <en|zh>       Temporarily set language for this command
  set-lang <en|zh>     Save language preference to config

AGENTS & TAGS
  @researcher / @研究员
    Explore codebase, search files, understand architecture
    Tags: codebase* | documentation
    Model: Haiku (cost-efficient)

  @engineer / @工程师
    Implement features, fix bugs, write code
    Tags: fullstack* | frontend | backend
    Model: Sonnet/Opus (task-dependent)

  @tester / @测试员
    Run tests, verify results, check builds
    Tags: unit* | integration | e2e
    Model: Haiku (cost-efficient)

  * = default tag when not specified

ROUTING EXAMPLES
  Automatic routing (recommended):
    /squad fix login button
      → Auto-detects: Engineer:frontend

    /squad optimize database queries
      → Auto-detects: Engineer:backend

    /squad find authentication implementation
      → Auto-detects: Researcher:codebase

  Manual routing (precise control):
    /squad @engineer:frontend add dark mode
      → Force: Engineer:frontend

    /squad @researcher:documentation find API reference
      → Force: Researcher:documentation

LANGUAGE SWITCHING
  /squad set-lang zh        # Switch to Chinese (persistent)
  /squad set-lang en        # Switch to English (persistent)
  /squad --lang zh [task]   # Use Chinese for this command only

CONFIGURATION
  Config file: ~/.squad/config.yaml
  Router rules: ~/.squad/router.yaml
  Agents: ~/.claude/agents/

VERSION
  Squad v0.1.0 (MVP)

LEARN MORE
  GitHub: https://github.com/yourusername/squad
  Docs: ~/.squad/README.md
  Report bugs: https://github.com/yourusername/squad/issues
```

#### `set-lang` Command

```bash
/squad set-lang zh   # Switch to Chinese
/squad set-lang en   # Switch to English
```

**Action:**
1. Read `~/.squad/config.yaml`
2. Update `language: zh` or `language: en`
3. Write back to file
4. Confirm: "✓ Language set to Chinese" / "✓ 语言已切换为中文"

---

### Step 3: Route Task to Agent

**Priority order:**

1. **Manual override** (if `@agent[:tag]` specified)
   ```bash
   /squad @engineer:frontend add button
   → Force: Engineer:frontend
   ```

2. **Keyword matching** (from router.yaml)
   - Check task against keyword lists
   - Match agent and tag
   - Calculate confidence (optional in MVP)

3. **Fallback** (if no match)
   ```
   → Engineer:fullstack (default)
   ```

---

### Step 4: Display Routing Decision

**Default mode (token-efficient):**
```
→ Engineer:frontend
```

**Verbose mode:**
```
→ Task analysis:
  - Keywords detected: [button, login, fix]
  - Matched pattern: frontend
  - Confidence: high
→ Routing: Engineer:frontend
```

---

### Step 5: Invoke Agent

Use the Task tool to call the selected agent:

```python
Task(
    subagent_type="engineer",
    prompt=f"[TAG: frontend]\n\n{task_description}",
    model="sonnet",  # or "haiku", "opus"
    description="Implement feature"
)
```

**Tag injection:**
- Prepend tag context to agent prompt
- Agent reads tag and adjusts behavior
- See agent definition files for tag-specific instructions

---

## Router Logic (MVP - Simple Keyword Matching)

### Load routing rules from `~/.squad/router.yaml`

**Pseudo-code:**
```python
def route_task(task: str) -> (agent, tag):
    task_lower = task.lower()

    # 1. Check for explicit agent
    if match := parse_explicit_agent(task):
        return match.agent, match.tag

    # 2. Load router.yaml rules
    rules = load_yaml("~/.squad/router.yaml")

    # 3. Match keywords
    for agent_name, agent_rules in rules.items():
        for tag, tag_rules in agent_rules.items():
            keywords = tag_rules.get("keywords", [])
            if any(kw in task_lower for kw in keywords):
                return agent_name, tag

    # 4. Fallback
    return "engineer", "fullstack"
```

---

## Example Flows

### Flow 1: Automatic Routing

```
User: /squad fix login button

→ Parse: task = "fix login button"
→ Match keywords: ["button", "login", "fix"]
→ Route: Engineer:frontend (button → frontend)
→ Invoke: Task(subagent_type="engineer", prompt="[TAG: frontend]\n\nfix login button")
```

### Flow 2: Manual Override

```
User: /squad @researcher:documentation find API docs

→ Parse: agent="researcher", tag="documentation", task="find API docs"
→ Route: Researcher:documentation (manual override)
→ Invoke: Task(subagent_type="researcher", prompt="[TAG: documentation]\n\nfind API docs")
```

### Flow 3: Verbose Mode

```
User: /squad --verbose optimize database query

→ Parse: verbose=true, task="optimize database query"
→ Match keywords: ["database", "query", "optimize"]
→ Output:
  → Task analysis:
    - Keywords detected: [database, query, optimize]
    - Matched pattern: backend
    - Confidence: high
  → Routing: Engineer:backend
→ Invoke: Task(subagent_type="engineer", prompt="[TAG: backend]\n\noptimize database query")
```

---

## Error Handling

### Invalid Agent

```
User: /squad @invalid-agent do something

Response:
❌ Unknown agent: invalid-agent

Available agents:
- @researcher / @研究员
- @engineer / @工程师
- @tester / @测试员

Use /squad --help for more information
```

### Invalid Tag

```
User: /squad @engineer:invalid-tag do something

Response:
❌ Unknown tag for engineer: invalid-tag

Available tags for engineer:
- fullstack (default)
- frontend
- backend

Use /squad --help for more information
```

### Missing Task

```
User: /squad

Response:
❌ No task specified

Usage: /squad [task description]

Examples:
  /squad fix login bug
  /squad @researcher explore codebase

Use /squad --help for more information
```

---

## Language Support

**Detect user's language preference:**
1. Check command `--lang` flag
2. Check `~/.squad/config.yaml`
3. Default to English

**Bilingual alias resolution:**
```
@研究员 → researcher
@工程师 → engineer
@测试员 → tester

探索 → explore
实现 → implement
测试 → test
```

---

## Configuration Files

### `~/.squad/config.yaml`
```yaml
language: en  # en | zh
verbose: false
```

### `~/.squad/router.yaml`
See router.yaml for keyword routing rules.

---

## Implementation Notes

**For Claude implementing this command:**

1. **Keep it simple (MVP)** - Don't over-engineer
2. **Token efficiency** - Minimal output
3. **Clear routing** - Show what was decided
4. **Error gracefully** - Help user fix mistakes
5. **Extensible design** - Easy to add features later

---

## Version

- **v0.1.0** - Initial command implementation (MVP)
