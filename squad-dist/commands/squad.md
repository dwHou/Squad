# Squad Command

**Command:** `/squad`
**Version:** 0.3.0
**Purpose:** Token-efficient multi-agent task orchestration with unified visualization

---

## Command Invocation

When the user types `/squad`, this command activates the Squad framework and handles task routing to specialized agents.

---

## Syntax

```bash
# Persistent mode (NEW)
/squad                     # Enter persistent mode (no task = session mode)
/squad exit                # Exit persistent mode

# Basic usage (single-shot mode)
/squad [task description]

# Agent specification
/squad @agent[:tag] [task description]

# Configuration
/squad config              # Interactive configuration wizard

# Reflection & Evolution
/squad reflect             # Analyze performance and evolve
/squad 回顾                # Chinese alias for reflect
/squad rollback <session>  # Rollback evolution changes

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

#### Persistent Mode (NEW)

**When user types `/squad` with NO parameters:**

```bash
/squad
```

**Action:**
1. Check if already in persistent mode by reading `~/.squad/session.yaml`
2. If already active, show: "✓ Already in Squad persistent mode. Type /exit to quit."
3. If not active:
   - Create `~/.squad/session.yaml`:
     ```yaml
     active: true
     started_at: 2026-01-29T10:30:00Z
     mode: persistent
     language: zh  # from config.yaml
     ```
   - Display welcome message:
     ```
     ✓ Squad 持久模式已启动

     现在所有对话都会通过 Squad 智能体编排。

     示例：
       fix login bug        → 自动路由
       add dark mode        → 自动路由

     退出：输入 /exit 或 /squad exit
     ```

**When user types `/squad exit`:**

```bash
/squad exit
```

**Action:**
1. Check `~/.squad/session.yaml` exists
2. Delete the file or set `active: false`
3. Display: "✓ 已退出 Squad 持久模式"

---

#### `config` Sub-command

When user types `/squad config`, launch interactive configuration wizard:

```bash
/squad config
```

**Action:**
1. Display welcome message
2. Use `AskUserQuestion` for language preference
3. Use `AskUserQuestion` for permission level
4. Update `~/.squad/config.yaml` with answers
5. Display confirmation with settings summary

**See:** `~/.claude/commands/config.md` for full implementation details

---

#### `reflect` Sub-command / `回顾`

When user types `/squad reflect` or `/squad 回顾`, analyze conversation performance and suggest improvements:

```bash
/squad reflect
/squad 回顾      # Chinese alias
```

**Action:**
1. Analyze current conversation:
   - What went well ✅
   - What could be better ⚠️
   - Satisfying responses 😊
   - Unsatisfying responses 😐
2. Identify improvement opportunities
3. Generate high-confidence proposals
4. Use `AskUserQuestion` to request approval
5. Apply approved changes (if any) with logging and backup
6. Display evolution summary

**Safety:**
- Only high-confidence changes by default
- All changes backed up before modification
- Atomic transactions (all or nothing)
- Full audit trail in `~/.squad/evolution/`

**See:** `~/.claude/commands/reflect.md` for full implementation details

---

#### `rollback` Sub-command

Rollback evolution changes:

```bash
/squad rollback <session_id>   # Rollback specific session
/squad rollback last            # Rollback last evolution
```

**Action:**
1. Read evolution log
2. Restore backup files
3. Verify restoration
4. Log rollback action

---

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
  • Persistent mode - Enter once, use continuously
  • Automatic task routing based on keywords
  • Tag-based agent specialization (frontend/backend/etc)
  • Bilingual support (English/中文)
  • Token-efficient serial execution

USAGE
  /squad                              # Enter persistent mode (NEW)
  /squad [OPTIONS] [TASK_DESCRIPTION] # Single-shot mode
  /squad @agent[:tag] [TASK_DESCRIPTION]
  /squad exit                         # Exit persistent mode

OPTIONS
  --help, -h           Show this help message
  --verbose, -v        Show detailed routing decisions
  --version            Show version information
  --lang <en|zh>       Temporarily set language for this command
  set-lang <en|zh>     Save language preference to config

AGENTS & TAGS
  🔍 @researcher / @研究员
    Explore codebase, search files, understand architecture
    Tags: codebase* | documentation
    Model: Haiku (cost-efficient)

  💻 @engineer / @工程师
    Implement features, fix bugs, write code
    Tags: fullstack* | frontend | backend
    Model: Sonnet/Opus (task-dependent)

  🚦 @tester / @测试员
    Run tests, verify results, check builds
    Tags: unit* | integration | e2e
    Model: Haiku (cost-efficient)

  * = default tag when not specified

MODES
  Persistent mode (recommended for continuous work):
    /squad                  # Enter persistent mode
    fix login button        # Auto-routed to Engineer:frontend
    add dark mode           # Auto-routed to Engineer:frontend
    /exit                   # Exit persistent mode

  Single-shot mode (quick tasks):
    /squad fix login button
      → Execute once and exit

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

**🚨 CRITICAL: You MUST display routing decision before executing.**

**Default mode (recommended):**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▸ SQUAD | 路由决策
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💻 @工程师:前端
   原因: UI 组件实现，需要前端开发技能
   预期: 可交互的主题切换按钮

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Format:**
1. Squad header with separator
2. Agent emoji + name + tag
3. 2-part declaration:
   - 原因 (Reason): Why this agent was selected
   - 预期 (Expected): Expected outcome
4. Closing separator

**Verbose mode (when `--verbose` flag is used):**
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
   原因: UI 组件实现，需要前端开发技能
   预期: 修复登录按钮对齐问题

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Why this matters:**
- Users see Squad branding (builds awareness and trust)
- Clear agent identification with emoji
- 2-part declaration provides context and expectations
- Only costs ~25 tokens for full display
- Professional, consistent visual style

**Examples:**
```
🔍 @研究员:代码库
   原因: 需要定位认证模块实现
   预期: 相关文件列表和流程图
```

```
💻 @工程师:后端
   原因: 数据库性能优化
   预期: 查询速度提升 50%
```

```
🚦 @测试员:单元
   原因: 验证代码质量
   预期: 所有测试通过，覆盖率 >80%
```

---

### Step 5: Invoke Agent

**🚨 CRITICAL: You MUST use the Task tool - NEVER handle tasks directly.**

Use the Task tool to call the selected agent. This ensures:
- ✅ Squad agents are actually invoked
- ✅ Tag-specific behavior is applied
- ✅ User sees Squad system in action
- ✅ Consistent agent experience

```python
# Step 5.1: Check language preference
config = read_yaml("~/.squad/config.yaml")
user_language = config.get("language", "en")

# Step 5.2: Build prompt with translation injection
prompt_parts = []

# Add translation instruction if user language is not English
if user_language != "en":
    translation_prompt = f"""
## 🌐 Translation Instruction

User language preference: {get_language_name(user_language)}

**CRITICAL: You MUST follow these translation rules:**

1. **Generate your analysis/thinking in English** (for clarity and accuracy)
2. **Translate ALL user-facing output to {get_language_name(user_language)}** before responding
3. **🚨 NEVER modify code:**
   - Code snippets MUST remain unchanged
   - Function/variable/class names MUST remain unchanged
   - Only comments/docstrings can be translated
   - File paths stay as-is (e.g., src/utils.js)
   - Command syntax stays as-is (e.g., git commit)
   - URLs and links stay as-is

4. **Smart translation with bilingual format for professional terms:**
   - Use format: `译文 (Original)` for technical/professional terms
   - Examples (zh):
     - "智能体 (agent)"
     - "路由器 (router)"
     - "应用程序接口 (API)"
     - "身份验证 (authentication)"
     - "管道 (pipeline)"
   - Well-established terms: translate only (e.g., "文件", "函数", "用户")

5. **When to use bilingual format:**
   - Technical jargon (API, JWT, OAuth, microservices)
   - Domain-specific terms (orchestration, serialization)
   - Ambiguous translations (context → 上下文/语境)
   - Terms commonly used in English in the industry
   - When precision is critical

6. **Error messages:**
   - Translate the explanation
   - Keep original error in code block for reference

**Example Output (zh):**
```
✅ Good:
"我找到了 3 个文件匹配您的查询:
- src/auth/login.js
- src/auth/register.js
- src/auth/utils.js

主要的身份验证 (authentication) 逻辑在 `authenticateUser()` 函数中实现，
定义在 src/auth/login.js:42。该函数使用 JWT 令牌 (token) 进行验证。"

❌ Bad (not translated):
"I found 3 files matching your query..."

❌ Bad (code modified):
"我找到了 3 个文件:
- 源/认证/登录.js  ← WRONG! Never translate paths/code
- `认证用户()` 函数  ← WRONG! Never translate function names

❌ Bad (missing original terms):
"该函数使用 JWT 令牌进行验证。"
(Should be: "JWT 令牌 (token)")
```

---
"""
    prompt_parts.append(translation_prompt)

# Add tag context
prompt_parts.append(f"[TAG: {tag}]")

# Add task description
prompt_parts.append(task_description)

# Combine all parts
full_prompt = "\n\n".join(prompt_parts)

# Step 5.3: Invoke agent
Task(
    subagent_type="engineer",
    prompt=full_prompt,
    model="sonnet",  # or "haiku", "opus"
    description="Implement feature"
)
```

**Prompt injection order:**
1. Translation instruction (if user language ≠ en)
2. Tag context
3. Task description

**Agent behavior:**
- Agent reads translation instruction first
- Applies smart translation rules
- Generates response in user's preferred language
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

### Missing Task (REMOVED)

**Note:** `/squad` without parameters now enters persistent mode, not an error.

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

- **v0.3.0** - Added visualization system (emojis, 2-part declarations, Squad branding)
- **v0.1.0** - Initial command implementation (MVP)
