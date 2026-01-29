# Exit Command

**Command:** `/exit` and `/quit`
**Purpose:** Exit Squad persistent mode

---

## Command Invocation

When the user types `/exit` or `/quit`, this command exits the Squad persistent mode if active.

---

## Syntax

```bash
/exit
/quit
```

**Aliases:**
- `/exit`
- `/quit`
- `/squad exit` (handled by squad.md)

---

## Behavior

### Step 1: Check if in persistent mode

```python
def handle_exit_command():
    session_file = "~/.squad/session.yaml"

    # Check if session file exists
    if not file_exists(session_file):
        # Not in persistent mode
        config = read_yaml("~/.squad/config.yaml")
        language = config.get("language", "en")

        if language == "zh":
            print("⚠️ 当前不在 Squad 持久模式中")
        else:
            print("⚠️ Not in Squad persistent mode")

        return

    # Read session
    session = read_yaml(session_file)

    if not session.get("active", False):
        # Session exists but not active
        if language == "zh":
            print("⚠️ Squad 持久模式未激活")
        else:
            print("⚠️ Squad persistent mode not active")
        return
```

---

### Step 2: Exit persistent mode

```python
    # Session is active - exit
    os.remove(session_file)

    # Or keep history:
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

## Example

```bash
# User enters persistent mode
/squad
# ✓ Squad 持久模式已启动

# User does some work
fix login bug
add dark mode

# User exits
/exit
# ✓ 已退出 Squad 持久模式

# Subsequent messages are normal conversations
hello
# Normal Claude response (not routed to Squad)
```

---

## Integration with Auto-Routing

**In the auto-routing detection logic (`AUTO_ROUTING.md`), handle /exit:**

```python
def handle_user_input(user_input: str):
    if is_squad_session_active():
        if user_input.strip() in ["/exit", "/quit"]:
            exit_persistent_mode()
            return

        # ... rest of auto-routing logic
```

---

## Error Handling

### Not in persistent mode

```
User: /exit

Response: ⚠️ 当前不在 Squad 持久模式中
```

---

## Version

- **v0.1.0** - Initial exit command implementation
