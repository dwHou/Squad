# Squad Config Command

**Command:** `/squad config`
**Version:** 0.1.0
**Purpose:** Interactive configuration for Squad settings

---

## Command Invocation

When the user types `/squad config`, this command launches an interactive configuration wizard with multiple rounds of questions.

---

## Behavior

### Step 1: Welcome Message

Display welcome message:

```
═══════════════════════════════════════════════════════
Squad Configuration Wizard
═══════════════════════════════════════════════════════

Let's configure Squad to match your preferences.
This wizard will ask you a few questions to customize your experience.

Current configuration: ~/.squad/config.yaml
```

---

### Step 2: Language Preference

Use `AskUserQuestion` tool to ask about language preference:

```python
AskUserQuestion(
    questions=[{
        "question": "What language would you like Squad to use for interactions?",
        "header": "Language",
        "options": [
            {
                "label": "中文 (Chinese)",
                "description": "所有智能体输出将自动翻译为中文。代码和技术术语保持不变，专业词汇使用双语对照。"
            },
            {
                "label": "English",
                "description": "All agent outputs will be in English. This is the default language for maximum clarity and accuracy."
            }
        ],
        "multiSelect": false
    }]
)
```

**Process answer:**
- If user selects "中文 (Chinese)" → Set `language: zh` in config
- If user selects "English" → Set `language: en` in config

---

### Step 3: Permission Level

Use `AskUserQuestion` tool to ask about permission level:

```python
AskUserQuestion(
    questions=[{
        "question": "What permission level should Squad agents have for autonomous operations?",
        "header": "Permissions",
        "options": [
            {
                "label": "🛡️ Conservative (保守)",
                "description": "每次文件操作都需要人工确认。适合重要项目和学习阶段。安全但需要频繁交互。"
            },
            {
                "label": "⚖️ Balanced (平衡) - Recommended",
                "description": "普通操作自动执行，重要操作（删除文件、修改配置、git push）需要确认。适合日常开发。"
            },
            {
                "label": "🚀 Autonomous (自主)",
                "description": "完全自动化，AI 可以自主决策和执行所有操作。适合长时间运行的复杂项目（如 24 小时持续开发）。需要高度信任。"
            }
        ],
        "multiSelect": false
    }]
)
```

**Process answer:**
- If user selects "Conservative" → Set `permission_level: conservative` in config
- If user selects "Balanced" → Set `permission_level: balanced` in config
- If user selects "Autonomous" → Set `permission_level: autonomous` in config

---

## Permission Level Details

### 🛡️ Conservative (保守)

**Philosophy:** Safety first, manual control

**Behavior:**
- ✋ Ask before creating any file
- ✋ Ask before editing any file
- ✋ Ask before deleting any file
- ✋ Ask before running commands
- ✋ Ask before git operations
- ✅ Auto-allow: Read, Glob, Grep (read-only operations)

**Best for:**
- Learning how Squad works
- Critical production codebases
- When you want full visibility and control
- Projects with strict change management

**Trade-off:** Frequent interruptions, slower progress

---

### ⚖️ Balanced (平衡) - Recommended

**Philosophy:** Trust but verify critical operations

**Behavior:**
- ✅ Auto-allow: Create/edit files in common directories (src/, docs/, tests/)
- ✅ Auto-allow: Run tests and builds
- ✅ Auto-allow: Install dependencies (npm install, pip install)
- ✅ Auto-allow: Git add, commit (with review prompt)
- ✋ Ask before: Deleting files
- ✋ Ask before: Modifying configuration files (.env, config.yaml, package.json)
- ✋ Ask before: Git push (show diff first)
- ✋ Ask before: Destructive commands (rm -rf, git reset --hard)

**Best for:**
- Daily development work
- Most software projects
- Balancing speed and safety
- Teams with good testing practices

**Trade-off:** Occasional prompts for critical actions

---

### 🚀 Autonomous (自主)

**Philosophy:** Full automation, minimal interruption

**Behavior:**
- ✅ Auto-allow: All file operations (create, edit, delete)
- ✅ Auto-allow: All commands (including git push)
- ✅ Auto-allow: Configuration changes
- ✅ Auto-allow: Dependency management
- ⚠️ Logging: All actions logged to `~/.squad/logs/actions.log`
- 🛟 Safety net: Auto-backup before destructive operations

**Best for:**
- Long-running projects (24+ hours)
- Trusted AI-driven development
- Prototyping and experimentation
- When you can review changes afterwards
- Solo projects where you're the only stakeholder

**Trade-off:** No manual oversight during execution

**Safety measures:**
- Auto-backup important files before modification
- Detailed logging of all actions
- Git commits with clear messages
- Rollback instructions in logs

**⚠️ Warning:** Only use this mode when:
1. You trust Squad's decision-making
2. You can review changes afterwards
3. You have backups or version control
4. The codebase is not in production

---

## Configuration File Update

After collecting answers, update `~/.squad/config.yaml`:

```yaml
# Squad Configuration
# Version: 0.1.0

# Language preference (en | zh)
language: zh  # or en

# Permission level (conservative | balanced | autonomous)
permission_level: balanced

# Verbose mode (show detailed routing)
verbose: false

# Model preferences (optional overrides)
# models:
#   researcher: haiku
#   engineer: sonnet
#   tester: haiku

# Permission settings (auto-generated based on permission_level)
permissions:
  # File operations
  allow_file_create: true/false
  allow_file_edit: true/false
  allow_file_delete: false  # Always ask for Conservative/Balanced

  # Git operations
  allow_git_commit: true/false
  allow_git_push: false  # Ask for Conservative/Balanced

  # Commands
  allow_commands: true/false
  allow_destructive_commands: false  # Always ask for Conservative/Balanced

  # Configuration
  allow_config_changes: true/false

# Autonomous mode settings (only used if permission_level: autonomous)
autonomous:
  enable_auto_backup: true
  enable_detailed_logging: true
  log_file: ~/.squad/logs/actions.log
  backup_dir: ~/.squad/backups
```

---

## Step 4: Confirmation

Display configuration summary:

```
═══════════════════════════════════════════════════════
Configuration Complete
═══════════════════════════════════════════════════════

Your Squad settings:

🌐 Language: 中文 (Chinese)
   All outputs will be auto-translated to Chinese
   Technical terms will use bilingual format

🛡️ Permission Level: Balanced (平衡)
   Normal operations: Automatic
   Critical operations: Requires confirmation
   Recommended for daily development

📁 Config file: ~/.squad/config.yaml

✅ Configuration saved successfully!

You can reconfigure anytime by running: /squad config
```

---

## Implementation Example

```python
# Pseudo-code for implementation

def squad_config_command():
    # Step 1: Welcome
    print_welcome_message()

    # Step 2: Ask language preference
    lang_answer = AskUserQuestion(
        questions=[{
            "question": "What language would you like Squad to use?",
            "header": "Language",
            "options": [
                {"label": "中文 (Chinese)", "description": "..."},
                {"label": "English", "description": "..."}
            ],
            "multiSelect": false
        }]
    )

    # Process language answer
    if "中文" in lang_answer["answer_0"]["label"]:
        language = "zh"
    else:
        language = "en"

    # Step 3: Ask permission level
    perm_answer = AskUserQuestion(
        questions=[{
            "question": "What permission level should Squad agents have?",
            "header": "Permissions",
            "options": [
                {"label": "🛡️ Conservative", "description": "..."},
                {"label": "⚖️ Balanced", "description": "..."},
                {"label": "🚀 Autonomous", "description": "..."}
            ],
            "multiSelect": false
        }]
    )

    # Process permission answer
    if "Conservative" in perm_answer["answer_0"]["label"]:
        permission_level = "conservative"
    elif "Balanced" in perm_answer["answer_0"]["label"]:
        permission_level = "balanced"
    else:  # Autonomous
        permission_level = "autonomous"

    # Step 4: Update config file
    config = read_yaml("~/.squad/config.yaml")
    config["language"] = language
    config["permission_level"] = permission_level
    config["permissions"] = generate_permissions(permission_level)
    write_yaml("~/.squad/config.yaml", config)

    # Step 5: Show confirmation
    print_confirmation(language, permission_level)

def generate_permissions(level):
    if level == "conservative":
        return {
            "allow_file_create": False,
            "allow_file_edit": False,
            "allow_file_delete": False,
            "allow_git_commit": False,
            "allow_git_push": False,
            "allow_commands": False,
            "allow_destructive_commands": False,
            "allow_config_changes": False
        }
    elif level == "balanced":
        return {
            "allow_file_create": True,
            "allow_file_edit": True,
            "allow_file_delete": False,  # Ask
            "allow_git_commit": True,
            "allow_git_push": False,  # Ask
            "allow_commands": True,
            "allow_destructive_commands": False,  # Ask
            "allow_config_changes": False  # Ask
        }
    else:  # autonomous
        return {
            "allow_file_create": True,
            "allow_file_edit": True,
            "allow_file_delete": True,
            "allow_git_commit": True,
            "allow_git_push": True,
            "allow_commands": True,
            "allow_destructive_commands": True,
            "allow_config_changes": True
        }
```

---

## Integration with Squad Command

Update `/squad` command to check permission level before operations:

```python
# In squad.md, before invoking agent

# Check permission level
config = read_yaml("~/.squad/config.yaml")
permission_level = config.get("permission_level", "balanced")
permissions = config.get("permissions", {})

# Inject permission context into agent prompt
permission_context = f"""
## ⚙️ Permission Context

Current permission level: {permission_level}

**Allowed operations:**
{format_permissions(permissions)}

**Important:**
- Always check permissions before acting
- If operation not allowed, ask user for confirmation
- Log all actions if in autonomous mode
"""

# Add to agent prompt
full_prompt = f"{permission_context}\n\n{translation_prompt}\n\n{task_description}"
```

---

## Autonomous Mode Safeguards

When `permission_level: autonomous`, inject additional safeguards:

```markdown
## 🛟 Autonomous Mode Safeguards

You are in **Autonomous Mode** - you have full permissions to act independently.

**With great power comes great responsibility:**

1. **Before destructive operations:**
   - Create backup: `cp file.txt file.txt.backup`
   - Log action: Append to ~/.squad/logs/actions.log

2. **Git commits:**
   - Use clear, descriptive commit messages
   - Follow format: "[Squad] {action}: {description}"
   - Example: "[Squad] fix: resolve authentication bug in login.js"

3. **File deletion:**
   - Verify file is safe to delete (not critical config)
   - Log deletion with reason

4. **Configuration changes:**
   - Backup existing config before modifying
   - Document what changed and why

5. **Error handling:**
   - If operation fails, log error and reason
   - Consider rollback if needed

**Logging format:**
```json
{
  "timestamp": "2024-01-29T15:30:00Z",
  "action": "file_edit",
  "file": "src/auth/login.js",
  "reason": "Fix authentication bug",
  "backup": "src/auth/login.js.backup.20240129153000",
  "success": true
}
```

**You are trusted to act autonomously. Use this power wisely.**
```

---

## Testing Permission Levels

### Test Conservative Mode
```bash
/squad config  # Select Conservative
/squad @engineer add a new file test.txt
# Expected: Ask user before creating file
```

### Test Balanced Mode
```bash
/squad config  # Select Balanced
/squad @engineer add a new file test.txt
# Expected: Create file automatically (common operation)

/squad @engineer delete config.yaml
# Expected: Ask user before deleting (critical file)
```

### Test Autonomous Mode
```bash
/squad config  # Select Autonomous
/squad @engineer implement user authentication feature
# Expected: Work for 24 hours without interruption, making all decisions autonomously
```

---

## Version

- **v0.1.0** - Initial config command with language and permission level settings
