# Auto-Routing Detection Mechanism

**Version:** 0.1.0
**Purpose:** Automatic routing for Squad persistent mode

---

## Overview

When Squad is in **persistent mode**, all user input (except commands) should be automatically routed to the Squad orchestration system. This document describes how the auto-routing detection works.

---

## Detection Flow

```
User Input
    ↓
Check: Is /squad session active?
    ↓
[YES] → Check: Is input a command?
    |        ↓
    |     [NO] → Auto-route to Squad
    |        ↓
    |     Route task → Select agent → Execute
    |
    ↓
[NO] → Normal Claude conversation
```

---

## Implementation

### 1. Session State Check

**Every time Claude processes user input**, check if persistent mode is active:

```python
# Pseudo-code
def is_squad_session_active() -> bool:
    session_file = "~/.squad/session.yaml"

    if not file_exists(session_file):
        return False

    session = read_yaml(session_file)
    return session.get("active", False) == True
```

---

### 2. Command Detection

**Commands are NOT auto-routed**. Detect if input is a command:

```python
def is_command(user_input: str) -> bool:
    # Starts with slash = command
    return user_input.strip().startswith("/")
```

**Commands to recognize:**
- `/exit`, `/quit` - Exit persistent mode
- `/squad ...` - Explicit Squad invocation (overrides auto-routing)
- `/help`, `/clear`, etc. - Other Claude commands
- Any other `/...` - Pass through to Claude

---

### 3. Auto-Routing Logic

**Main logic:**

```python
def handle_user_input(user_input: str):
    # Step 1: Check if in persistent mode
    if is_squad_session_active():

        # Step 2: Check if it's a command
        if is_command(user_input):
            # Handle commands normally
            if user_input in ["/exit", "/quit"]:
                exit_persistent_mode()
                return
            elif user_input.startswith("/squad"):
                # Explicit Squad command (overrides auto-routing)
                handle_squad_command(user_input)
                return
            else:
                # Other commands - pass through
                handle_other_command(user_input)
                return

        # Step 3: Not a command → Auto-route to Squad
        else:
            auto_route_to_squad(user_input)
            return

    # Not in persistent mode → Normal conversation
    else:
        handle_normal_conversation(user_input)
```

---

### 4. Auto-Routing Function

```python
def auto_route_to_squad(user_input: str):
    """
    Automatically route user input to Squad orchestration.
    This is equivalent to typing: /squad [user_input]
    """

    # Step 1: Load session config
    session = read_yaml("~/.squad/session.yaml")
    language = session.get("language", "en")

    # Step 2: Display routing indicator
    print(f"→ [Squad编排]")  # or "→ [Squad orchestration]"

    # Step 3: Analyze task and route to agent
    agent, tag = route_task(user_input)

    # Step 4: Display routing decision
    print(f"→ {agent.capitalize()}:{tag}")

    # Step 5: Invoke agent (same as /squad command)
    invoke_agent(
        agent=agent,
        tag=tag,
        task=user_input,
        language=language
    )

    # Step 6: Update session with last agent used
    session["last_agent"] = f"{agent}:{tag}"
    session["last_task_at"] = current_timestamp()
    write_yaml("~/.squad/session.yaml", session)
```

---

## Session File Format

```yaml
# ~/.squad/session.yaml
active: true
started_at: 2026-01-29T10:30:00Z
mode: persistent
language: zh                    # from config.yaml
last_agent: engineer:frontend   # last agent used (optional)
last_task_at: 2026-01-29T10:35:00Z  # last task timestamp (optional)
```

---

## Exit Persistent Mode

**Commands:**
- `/exit`
- `/quit`
- `/squad exit`

**Action:**
```python
def exit_persistent_mode():
    session_file = "~/.squad/session.yaml"

    if file_exists(session_file):
        # Option 1: Delete file
        os.remove(session_file)

        # Option 2: Set active=false (keep history)
        # session = read_yaml(session_file)
        # session["active"] = False
        # session["ended_at"] = current_timestamp()
        # write_yaml(session_file, session)

    # Display confirmation
    config = read_yaml("~/.squad/config.yaml")
    language = config.get("language", "en")

    if language == "zh":
        print("✓ 已退出 Squad 持久模式")
    else:
        print("✓ Exited Squad persistent mode")
```

---

## Edge Cases

### Case 1: User forgets to exit

**Problem:** Session persists across conversations

**Solution:** Add timestamp check. If session is > 24 hours old, prompt user:

```
⚠️ Squad 持久模式已运行 25 小时

   是否继续使用？
   [继续] [退出]
```

### Case 2: Explicit /squad command in persistent mode

**Behavior:** Allow explicit command to override auto-routing

```bash
# In persistent mode:
fix login bug              # Auto-routed

/squad @researcher find docs   # Explicit override
```

**Implementation:** When `/squad` command is detected, handle it normally (skip auto-routing).

### Case 3: Multiple conversations

**Problem:** Session file is global, affects all Claude conversations

**Solution (Future):** Use conversation ID in session file:

```yaml
sessions:
  conv_12345:
    active: true
    started_at: ...
  conv_67890:
    active: false
```

**MVP:** Single global session (acceptable)

---

## Integration with squad.md

**In squad.md command definition, add:**

```markdown
### Step 0: Auto-Routing Check (NEW)

**Before handling /squad command, check if auto-routing applies:**

If user input does NOT start with `/squad`, check for auto-routing:
1. Read `~/.squad/session.yaml`
2. If `active: true`, auto-route to Squad
3. Otherwise, proceed normally

**This check happens BEFORE Step 1.**
```

---

## Testing

### Test 1: Enter and exit persistent mode
```bash
/squad
# Should show: "✓ Squad 持久模式已启动"

fix login bug
# Should auto-route to Engineer:frontend

/exit
# Should show: "✓ 已退出 Squad 持久模式"

fix login bug
# Should be normal conversation (no routing)
```

### Test 2: Explicit command overrides
```bash
/squad
# Enter persistent mode

/help
# Should show Claude help (not routed)

/squad @researcher explore code
# Should route to Researcher:codebase (explicit override)
```

### Test 3: Session persistence
```bash
/squad
# Enter persistent mode

# Close Claude and reopen

fix bug
# Should still auto-route (session persists)

/exit
# Exit
```

---

## Version History

- **v0.1.0** - Initial auto-routing design (MVP)
