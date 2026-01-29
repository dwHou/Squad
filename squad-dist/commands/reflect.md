# Squad Reflect Command / 回顾命令

**Command:** `/squad reflect` / `/squad 回顾`
**Version:** 0.1.0
**Purpose:** Self-reflection and continuous improvement mechanism

---

## Overview

The Reflect command enables Squad to analyze its own performance in the current conversation, identify improvement opportunities, and cautiously evolve its behavior by updating its own documentation.

**Core Principle:** Cautious self-improvement without regression

---

## Command Invocation

```bash
/squad reflect        # Analyze current conversation performance
/squad 回顾           # Chinese alias
```

---

## Execution Flow

```
User invokes /squad reflect
        ↓
Step 1: Performance Analysis
        ├─ What went well
        ├─ What could be better
        ├─ Satisfying responses
        └─ Unsatisfying responses
        ↓
Step 2: Identify Improvement Opportunities
        ├─ Routing accuracy
        ├─ Agent selection
        ├─ Translation quality
        ├─ Permission handling
        └─ Response clarity
        ↓
Step 3: Generate Improvement Proposals
        ├─ Filter by confidence level
        ├─ Avoid regressions
        └─ Prioritize high-impact changes
        ↓
Step 4: Ask User for Approval
        ├─ Show proposed changes
        └─ Use AskUserQuestion
        ↓
Step 5: Apply Approved Changes (if any)
        ├─ Update routing rules
        ├─ Update agent definitions
        └─ Log all changes
```

---

## Step 1: Performance Analysis

### Analyze Conversation History

Review the current conversation and assess:

#### ✅ What Went Well

**Checklist:**
```
□ Task routing was accurate
□ Agent selection was appropriate
□ Agent completed task successfully
□ Translation quality was good (if applicable)
□ Permission handling was smooth
□ Response clarity was high
□ User didn't need to correct or clarify often
```

**Output example:**
```markdown
## ✅ What Went Well

1. **Routing Accuracy**
   - Task: "add translation skill"
   - Routed to: Engineer:fullstack
   - Result: ✅ Correct agent selected

2. **Translation Quality**
   - All technical terms used bilingual format
   - Code was never modified
   - User-facing output in Chinese was natural

3. **Task Completion**
   - All requested features implemented
   - Files created: translate.md, config.md
   - No critical bugs reported
```

---

#### ⚠️ What Could Be Better

**Checklist:**
```
□ Routing mistakes (wrong agent selected)
□ Agent struggled with task
□ Translation had issues
□ Permission requests were too frequent/infrequent
□ Responses were unclear or verbose
□ User had to provide many clarifications
□ Performance was slow
```

**Output example:**
```markdown
## ⚠️ What Could Be Better

1. **Routing Hesitation**
   - Issue: Initially unclear which agent to use for config command
   - Impact: Minor delay in execution
   - Potential fix: Add "config" keyword to routing rules

2. **Verbose Output**
   - Issue: Some explanations were longer than necessary
   - Impact: Token inefficiency
   - Potential fix: Add conciseness guideline to agent definitions
```

---

#### 😊 Satisfying Responses

**Identify responses that user reacted positively to:**

```markdown
## 😊 Satisfying Responses

1. **Translation Skill Design**
   - User feedback: Opened translate.md file (interest signal)
   - Why satisfying: Comprehensive, clear examples, bilingual format rules

2. **Permission System Design**
   - User feedback: No corrections needed
   - Why satisfying: Three clear levels, good defaults, safety focus
```

---

#### 😐 Unsatisfying Responses

**Identify responses that user corrected or seemed unsatisfied with:**

```markdown
## 😐 Unsatisfying Responses

1. **Initial Translation Spec**
   - User correction: "代码翻译需要要求不修改任何代码"
   - Issue: Didn't emphasize code immutability strongly enough
   - Lesson: Critical rules need 🚨 emphasis and multiple examples

2. **Missing Bilingual Format**
   - User correction: "专业的词汇...可以在翻译的文本后，用括号保留原语言词汇"
   - Issue: Didn't proactively suggest bilingual format
   - Lesson: Anticipate best practices from similar systems
```

---

## Step 2: Identify Improvement Opportunities

### Improvement Categories

| Category | Examples | Confidence Level |
|----------|----------|------------------|
| **Routing Keywords** | Add missing keywords | High ✅ |
| **Agent Instructions** | Clarify responsibilities | High ✅ |
| **Translation Rules** | Add emphasis/examples | Medium ⚠️ |
| **Permission Defaults** | Adjust default settings | Low ⚠️ |
| **Error Messages** | Improve clarity | High ✅ |

### Confidence Assessment

**High Confidence (✅) - Safe to apply:**
- Adding missing keywords to router.yaml
- Adding examples to documentation
- Emphasizing existing rules
- Fixing typos or formatting issues
- Adding clarifications without changing behavior

**Medium Confidence (⚠️) - Needs careful review:**
- Changing agent behavior descriptions
- Modifying default settings
- Adding new capabilities
- Changing permission logic

**Low Confidence (🚫) - Avoid unless critical:**
- Removing existing rules
- Changing core architecture
- Modifying routing priority
- Changing agent tool access

---

## Step 3: Generate Improvement Proposals

### Proposal Format

```markdown
## Improvement Proposals

### Proposal 1: Add "config" keyword to router
**Confidence:** ✅ High
**Category:** Routing Keywords
**Impact:** Low risk, high benefit
**Change:**
- File: `router.yaml`
- Action: Add "config", "configure", "配置" to general keywords
- Reason: Improve routing for configuration tasks

**Diff:**
```yaml
# router.yaml
general:
  keywords:
    - config       # NEW
    - configure    # NEW
    - 配置         # NEW
    - settings
    - preferences
```

**Risk Assessment:** No regression risk (only adding keywords)

---

### Proposal 2: Emphasize code immutability in all agent files
**Confidence:** ✅ High
**Category:** Agent Instructions
**Impact:** Low risk, high benefit
**Change:**
- Files: `agents/researcher.md`, `agents/engineer.md`, `agents/tester.md`
- Action: Add prominent warning about code immutability
- Reason: User emphasized this is critical

**Diff:**
```markdown
# In each agent file

## 🚨 CRITICAL RULE: Code Immutability

**NEVER translate, modify, or change:**
- Function names
- Variable names
- Class names
- File paths
- Code logic

**ONLY translate:**
- Comments
- Docstrings
- Documentation strings
```

**Risk Assessment:** No regression risk (only emphasizing existing rule)

---

### Proposal 3: Change default permission level to autonomous
**Confidence:** 🚫 Low (REJECT)
**Category:** Permission Defaults
**Impact:** HIGH RISK ⚠️
**Reason for rejection:**
- Could cause unintended destructive operations
- Goes against "trust but verify" philosophy
- User didn't request this change
- Would be a regression for safety-conscious users

**Decision:** DO NOT IMPLEMENT
```

---

## Step 4: Ask User for Approval

**CRITICAL: Always show detailed diffs before applying changes**

### 4.1: Display All Proposed Changes with Diffs

For each proposal, show:
1. Title and confidence level
2. Files affected
3. Complete diff (before/after)
4. Risk assessment

```python
# Filter proposals by confidence level
high_confidence_proposals = [p for p in proposals if p.confidence == "high"]

if len(high_confidence_proposals) > 0:
    # Display proposals with full diffs
    for i, proposal in enumerate(high_confidence_proposals):
        print(f"\n## 提案 {i+1}: {proposal.title}")
        print(f"**置信度 (Confidence):** {'✅ 高' if proposal.confidence == 'high' else '⚠️ 中'}")
        print(f"**影响的文件 (Files):** {proposal.file_paths}")
        print(f"\n**改动详情 (Diff):**")
        print("```diff")
        print(proposal.diff)  # Show full diff
        print("```")
        print(f"\n**风险评估 (Risk):** {proposal.risk_assessment}")
        print("---")
```

### 4.2: Ask User to Approve/Reject Each Change

**Three-option workflow for maximum control:**

```python
    # First: Let user select which changes to apply
    selection_answer = AskUserQuestion(
        questions=[{
            "question": "请选择您想要应用的改进 (您可以选择多个或不选)",
            "header": "选择改进",
            "options": [
                {
                    "label": f"提案 {i+1}: {p.title}",
                    "description": f"文件: {p.file_paths[0]} | 风险: {p.risk_level}"
                }
                for i, p in enumerate(high_confidence_proposals)
            ],
            "multiSelect": true  # Allow multiple selections
        }]
    )

    # Extract selected proposals
    selected_proposals = [
        high_confidence_proposals[i]
        for i in selection_answer.selected_indices
    ]

    # If user selected at least one change, ask about sync strategy
    if len(selected_proposals) > 0:
        sync_answer = AskUserQuestion(
            questions=[{
                "question": "您希望如何应用这些改进？",
                "header": "同步策略",
                "options": [
                    {
                        "label": "✅ 仅更新本地 (Local only)",
                        "description": "只更新 ~/.claude/ 运行时文件。改进立即生效，但不会同步到 squad-dist/ 仓库源文件。适合个人实验性改进。"
                    },
                    {
                        "label": "🚀 更新本地并同步到仓库 (Local + Repo)",
                        "description": "同时更新 ~/.claude/ 和 squad-dist/。改进立即生效，且可以 commit 分享给团队。适合确认有效的改进。(推荐)"
                    },
                    {
                        "label": "❌ 取消 (Cancel)",
                        "description": "不应用任何改动。"
                    }
                ],
                "multiSelect": false
            }]
        )

        # Determine sync mode based on user choice
        sync_mode = parse_sync_mode(sync_answer)
        # sync_mode: "local_only" | "local_and_repo" | "cancel"

        if sync_mode != "cancel":
            apply_improvements(selected_proposals, sync_mode)
    else:
        print("未选择任何改进，跳过演进。")
```

---

## Step 5: Apply Approved Changes

### Configurable Sync Architecture

**Three sync modes for maximum flexibility:**

#### Mode 1: Local Only (本地仅)
```
User approves change + selects "仅更新本地"
        ↓
1. Update ~/.claude/ (runtime) → Takes effect immediately
        ↓
2. Create backup for runtime
        ↓
3. Log changes (local-only mode)
        ↓
4. Display summary + warning about ./install.sh override
```

**Use case:** Experimental improvements, personal tweaks

**Trade-off:**
- ✅ Quick to apply
- ✅ Private (not shared with team)
- ⚠️ Will be overwritten if you run `./install.sh` later
- ⚠️ Not shared with other users

---

#### Mode 2: Local + Repo (本地并同步到仓库) [Recommended]
```
User approves change + selects "更新本地并同步到仓库"
        ↓
1. Update ~/.claude/ (runtime) → Takes effect immediately
        ↓
2. Update squad-dist/ (source) → Can be committed to git
        ↓
3. Create backups for both locations
        ↓
4. Verify both files match
        ↓
5. Log changes (dual-path mode)
        ↓
6. Display summary + git commit suggestion
```

**Use case:** Confirmed improvements worth sharing with team

**Trade-off:**
- ✅ Immediate effect + permanent
- ✅ Shareable via git
- ✅ Survives `./install.sh` reinstall
- ✅ Benefits the whole team

---

#### Mode 3: Cancel (取消)
```
User selects "取消"
        ↓
No changes applied
        ↓
Reflection report saved for future reference
```

### Change Application Process

```python
def apply_improvements(approved_proposals, sync_mode):
    """Apply approved improvements with configurable sync strategy.

    Args:
        approved_proposals: List of proposals to apply
        sync_mode: "local_only" | "local_and_repo"
    """

    changes_log = []
    REPO_ROOT = "/Applications/Programming/code/GitProj/Squad"

    for proposal in approved_proposals:
        runtime_path = proposal.file_path  # e.g., ~/.claude/agents/engineer.md
        source_path = get_source_path(runtime_path, REPO_ROOT) if sync_mode == "local_and_repo" else None

        try:
            # 1. Backup runtime file (always)
            runtime_backup = backup_file(runtime_path)
            source_backup = None

            # 2. Apply change to runtime (immediate effect)
            apply_change(runtime_path, proposal.change)

            # 3. Conditionally apply to source (based on sync_mode)
            if sync_mode == "local_and_repo" and source_path:
                source_backup = backup_file(source_path) if os.path.exists(source_path) else None
                apply_change(source_path, proposal.change)

                # Verify both files match
                if not files_match(runtime_path, source_path):
                    raise Exception("Runtime and source files don't match after sync")

            # 4. Log success
            log_entry = {
                "proposal_id": proposal.id,
                "runtime_file": runtime_path,
                "action": proposal.action,
                "status": "success",
                "timestamp": now(),
                "runtime_backup": runtime_backup,
                "sync_mode": sync_mode
            }

            if sync_mode == "local_and_repo":
                log_entry["source_file"] = source_path
                log_entry["source_backup"] = source_backup
                log_entry["sync"] = "dual-path-completed"
            else:
                log_entry["sync"] = "local-only"

            changes_log.append(log_entry)

        except Exception as e:
            # 5. Rollback on error
            restore_backup(runtime_path, runtime_backup)
            if source_backup:
                restore_backup(source_path, source_backup)

            changes_log.append({
                "proposal_id": proposal.id,
                "runtime_file": runtime_path,
                "source_file": source_path if sync_mode == "local_and_repo" else None,
                "status": "failed",
                "error": str(e),
                "rollback": "completed",
                "sync_mode": sync_mode
            })

    # 6. Write evolution log
    write_evolution_log(changes_log)

    # 7. Display summary based on sync mode
    display_evolution_summary(changes_log)

    # 8. Display mode-specific instructions
    successful_changes = [log for log in changes_log if log["status"] == "success"]

    if len(successful_changes) > 0:
        if sync_mode == "local_only":
            print("\n✅ 改动已应用到本地:")
            print("   - ~/.claude/ (运行时) → 立即生效 ✓")
            print("\n📝 注意:")
            print("   - 这些改动仅在您的本地环境生效")
            print("   - 未同步到 squad-dist/ 仓库源文件")
            print("   - 如果将来运行 ./install.sh，这些改动可能会被覆盖")
            print("\n💡 如果测试有效，建议稍后运行:")
            print("   /squad reflect  # 重新选择这些改进")
            print("   选择 '更新本地并同步到仓库' 以永久保存")

        elif sync_mode == "local_and_repo":
            print("\n✅ 改动已应用到两个位置:")
            print("   - ~/.claude/ (运行时) → 立即生效 ✓")
            print("   - squad-dist/ (源文件) → 可以 commit 到 git ✓")
            print("\n💡 建议操作:")
            print("   git add squad-dist/")
            print("   git commit -m \"evolve: [描述改进内容]\"")
            print("   git push  # 分享给其他用户")


def get_source_path(runtime_path, repo_root):
    """Convert runtime path to source path."""
    # ~/.claude/agents/engineer.md → squad-dist/agents/engineer.md
    # ~/.squad/router.yaml → squad-dist/router/router.yaml

    if "/.claude/agents/" in runtime_path:
        filename = os.path.basename(runtime_path)
        return os.path.join(repo_root, "squad-dist/agents", filename)

    elif "/.claude/commands/" in runtime_path:
        filename = os.path.basename(runtime_path)
        return os.path.join(repo_root, "squad-dist/commands", filename)

    elif "/.claude/skills/" in runtime_path:
        filename = os.path.basename(runtime_path)
        return os.path.join(repo_root, "squad-dist/skills", filename)

    elif "/.squad/router.yaml" in runtime_path:
        return os.path.join(repo_root, "squad-dist/router/router.yaml")

    else:
        # Unknown path - log warning
        return None
```

### Evolution Log

Store all changes in `~/.squad/evolution/`:

```
~/.squad/evolution/
├── 2024-01-29-session-abc123.json    # This session's changes
└── history.log                        # All-time change history
```

**Log format:**
```json
{
  "session_id": "abc123",
  "timestamp": "2024-01-29T16:00:00Z",
  "trigger": "user_invoked_reflect",
  "analysis": {
    "what_went_well": [...],
    "what_could_be_better": [...],
    "satisfying_responses": [...],
    "unsatisfying_responses": [...]
  },
  "proposals": [
    {
      "id": "P001",
      "title": "Add config keyword to router",
      "confidence": "high",
      "category": "routing_keywords",
      "file": "~/.squad/router.yaml",
      "status": "applied",
      "backup": "~/.squad/backups/router.yaml.20240129160000"
    }
  ],
  "user_approval": "apply_all_high_confidence",
  "results": {
    "successful_changes": 3,
    "failed_changes": 0,
    "rollbacks": 0
  }
}
```

---

## Safety Mechanisms

### 1. Confidence Filtering

```python
# Only suggest high-confidence improvements by default
CONFIDENCE_THRESHOLD = "high"

# Medium and low confidence require explicit user opt-in
def filter_proposals(proposals, user_confidence_level="high"):
    if user_confidence_level == "high":
        return [p for p in proposals if p.confidence == "high"]
    elif user_confidence_level == "medium":
        return [p for p in proposals if p.confidence in ["high", "medium"]]
    else:  # Show all (dangerous!)
        return proposals
```

### 2. Regression Detection

```python
# Check for potential regressions
REGRESSION_PATTERNS = [
    "remove",        # Removing functionality
    "delete",        # Deleting rules
    "disable",       # Disabling features
    "less",          # Making things less capable
    "restrict",      # Adding restrictions
]

def detect_regression(proposal):
    description_lower = proposal.description.lower()
    for pattern in REGRESSION_PATTERNS:
        if pattern in description_lower:
            proposal.confidence = "low"  # Downgrade confidence
            proposal.regression_risk = True
            proposal.requires_explicit_approval = True
```

### 3. Scope Limitation

```python
# Limit what can be modified (both runtime and source paths)
ALLOWED_RUNTIME_FILES = [
    "~/.squad/router.yaml",           # Routing rules
    "~/.claude/agents/*.md",          # Agent definitions
    "~/.claude/skills/*.md",          # Skill definitions
    "~/.claude/commands/*.md",        # Command definitions
    # "~/.squad/config.yaml",         # NOT allowed (user config)
    # "~/.claude/rules/*.md",         # NOT allowed (core rules)
]

ALLOWED_SOURCE_FILES = [
    "squad-dist/router/router.yaml",  # Routing rules
    "squad-dist/agents/*.md",         # Agent definitions
    "squad-dist/skills/*.md",         # Skill definitions
    "squad-dist/commands/*.md",       # Command definitions
    # "squad-dist/config.yaml.template", # NOT allowed (template only)
    # "squad-dist/rules/*.md",        # NOT allowed (core rules)
]

def validate_change(proposal):
    runtime_path = proposal.file_path
    source_path = get_source_path(runtime_path)

    if not is_allowed_file(runtime_path, ALLOWED_RUNTIME_FILES):
        raise SecurityError(f"Cannot modify runtime file: {runtime_path}")

    if source_path and not is_allowed_file(source_path, ALLOWED_SOURCE_FILES):
        raise SecurityError(f"Cannot modify source file: {source_path}")
```

### 4. Atomic Changes

```python
# All changes in a proposal are applied atomically
# If any change fails, all changes rollback

def apply_proposal_atomically(proposal):
    with atomic_transaction():
        for change in proposal.changes:
            apply_change(change)

        # Only commit if all changes succeed
        commit_transaction()
```

### 5. Backup Everything

```python
# Backup before every change
def backup_file(file_path):
    timestamp = now().strftime("%Y%m%d%H%M%S")
    backup_path = f"~/.squad/backups/{basename(file_path)}.{timestamp}"
    copy_file(file_path, backup_path)
    return backup_path
```

---

## Reflection Report Template

```markdown
# Squad Reflection Report
**Session ID:** {session_id}
**Date:** {date}
**Language:** {language}

---

## 📊 Performance Summary

| Metric | Score | Notes |
|--------|-------|-------|
| Routing Accuracy | 9/10 | 1 routing hesitation |
| Task Completion | 10/10 | All tasks completed |
| Translation Quality | 8/10 | Initial spec lacked emphasis |
| Response Clarity | 9/10 | Mostly clear, some verbosity |
| User Satisfaction | 9/10 | Minor corrections needed |

**Overall:** 9.0/10 ✅

---

## ✅ What Went Well

1. **Comprehensive Translation Skill Design**
   - Created detailed translate.md with examples
   - Implemented bilingual format for technical terms
   - Added code immutability rules

2. **Permission System Design**
   - Three clear permission levels
   - Good defaults (Balanced mode)
   - Autonomous mode with safety measures

3. **Translation Auto-Injection**
   - Seamlessly integrated into agent prompts
   - Smart bilingual format rules
   - Code immutability emphasized

---

## ⚠️ What Could Be Better

1. **Initial Code Immutability Emphasis**
   - Issue: Didn't emphasize strongly enough initially
   - User correction: Required explicit request
   - Lesson: Critical rules need 🚨 markers

2. **Proactive Bilingual Format**
   - Issue: Didn't suggest bilingual format proactively
   - User correction: Had to request it
   - Lesson: Anticipate best practices from domain knowledge

---

## 😊 Satisfying Responses

1. **Translation Skill Documentation** (translate.md)
   - User opened file to review (positive signal)
   - Comprehensive examples and guidelines

2. **Permission System** (config command)
   - No corrections needed
   - Well-structured three-level system

---

## 😐 Unsatisfying Responses

1. **Initial Translation Spec**
   - User had to request code immutability emphasis
   - Learned: Be more explicit about critical rules

2. **Bilingual Format**
   - User had to request this feature
   - Learned: Proactively suggest best practices

---

## 💡 Improvement Opportunities

### High Confidence (Safe to Apply)

1. **Add "config" keyword to router**
   - Improve routing for configuration tasks
   - Zero regression risk

2. **Emphasize code immutability in all agents**
   - Add 🚨 CRITICAL RULE sections
   - Reinforce critical constraint

3. **Add translation quality checklist**
   - Help agents verify bilingual format usage
   - Improve consistency

### Medium Confidence (Need Review)

1. **Add conciseness guideline**
   - Help reduce token usage
   - Risk: Might reduce clarity

### Rejected (Low Confidence)

1. **Change default permission to autonomous**
   - REJECTED: Safety regression risk
   - Current default (Balanced) is appropriate

---

## 🎯 Proposed Changes

### Change 1: Add config keywords to router
**Confidence:** ✅ High
**File:** `~/.squad/router.yaml`

```diff
general:
  keywords:
+   - config
+   - configure
+   - configuration
+   - 配置
    - settings
    - preferences
```

**Risk:** None (only adding keywords)
**Benefit:** Better routing for config tasks

---

### Change 2: Emphasize code immutability
**Confidence:** ✅ High
**Files:** All agent definitions

```diff
+ ## 🚨 CRITICAL RULE: Code Immutability
+
+ **NEVER modify code:**
+ - Function/variable/class names
+ - File paths
+ - Code logic
+
+ **ONLY translate:**
+ - Comments and docstrings
```

**Risk:** None (only adding emphasis)
**Benefit:** Prevent code modification errors

---

## 🤔 Recommendation

Apply **2 high-confidence improvements** that enhance routing and reinforce critical rules.

**Next step:** Ask user for approval.

---

*Generated by Squad Reflect v0.1.0*
```

---

## User Approval Flow

### Option 1: Apply All (Recommended for High-Confidence)

```markdown
✅ I'll apply these 2 high-confidence improvements:

1. Add "config" keywords to router
2. Emphasize code immutability in agents

All changes will be logged and backed up.
You can rollback anytime using: /squad rollback {session_id}
```

### Option 2: Show Details First

```markdown
Let me show you the exact diffs for each change...

[Show detailed diffs with before/after]

Which changes would you like to apply?
□ Change 1: Add config keywords
□ Change 2: Emphasize code immutability
```

### Option 3: No Changes

```markdown
No problem! The reflection report has been saved to:
~/.squad/evolution/2024-01-29-session-abc123.json

You can review it anytime and apply improvements later.
```

---

## Rollback Command

```bash
/squad rollback {session_id}   # Rollback specific session changes
/squad rollback last           # Rollback last evolution
```

**Rollback process:**
1. Read evolution log for session
2. Restore backup files
3. Verify restoration
4. Log rollback action

---

## Evolution Philosophy

### Kaizen (改善) - Continuous Improvement

**Principles:**
1. **Small, incremental changes** - Not big rewrites
2. **High confidence only** - Avoid regressions
3. **User-approved** - Never auto-evolve without permission
4. **Reversible** - Always keep backups
5. **Logged** - Full audit trail

### What NOT to Change

**Never modify:**
- Core architecture (serial execution, routing priority)
- User configuration (language, permissions)
- Breaking changes (removing features)
- Experimental features (without explicit testing)

**Safe to modify:**
- Adding keywords to router
- Adding examples to documentation
- Emphasizing existing rules
- Fixing typos
- Improving clarity

---

## Configurable Sync Mechanism / 可配置同步机制

### Three Sync Modes

Squad evolution now offers **three sync modes** to give you maximum control:

#### 1. **仅更新本地 (Local Only)**
- **What:** Only update ~/.claude/ runtime files
- **When:** Experimental improvements, personal customizations
- **Pros:** Quick, private, no git noise
- **Cons:** Lost on `./install.sh`, not shared with team

#### 2. **更新本地并同步到仓库 (Local + Repo)** ⭐ Recommended
- **What:** Update both ~/.claude/ and squad-dist/
- **When:** Confirmed valuable improvements
- **Pros:** Immediate effect + permanent + shareable
- **Cons:** Requires git commit/push to share

#### 3. **取消 (Cancel)**
- **What:** Don't apply any changes
- **When:** Uncertain, need more time to think
- **Pros:** Safe, reversible decision
- **Cons:** No improvements applied

### Architecture Diagram

```
User approves evolution change
        ↓
┌───────────────────────────────────────────┐
│  Apply Change (with dual-path sync)       │
├───────────────────────────────────────────┤
│                                           │
│  Path 1: Runtime (immediate effect)      │
│  └─ Edit ~/.claude/agents/engineer.md   │
│     Effect: Next /squad invocation       │
│                                           │
│  Path 2: Source (can commit)             │
│  └─ Edit squad-dist/agents/engineer.md  │
│     Effect: git commit → other users     │
│                                           │
└───────────────────────────────────────────┘
        ↓
Verify both files match
        ↓
Log changes to ~/.squad/evolution/
        ↓
Suggest git commit to user
```

### File Path Mappings

| Runtime Path | Source Path |
|--------------|-------------|
| `~/.claude/agents/engineer.md` | `squad-dist/agents/engineer.md` |
| `~/.claude/agents/researcher.md` | `squad-dist/agents/researcher.md` |
| `~/.claude/agents/tester.md` | `squad-dist/agents/tester.md` |
| `~/.claude/commands/squad.md` | `squad-dist/commands/squad.md` |
| `~/.claude/skills/translate.md` | `squad-dist/skills/translate.md` |
| `~/.squad/router.yaml` | `squad-dist/router/router.yaml` |

**NOT synced (user-specific):**
- `~/.squad/config.yaml` (user configuration)
- `~/.claude/rules/*.md` (core rules - too risky)

### Benefits

1. **Immediate Effect** - Changes to ~/.claude/ take effect instantly
2. **Shareable** - Changes to squad-dist/ can be committed and pushed
3. **Collaborative** - Team members benefit from each other's improvements
4. **Atomic** - Both paths updated together (all or nothing)
5. **Reversible** - Both paths backed up and can be rolled back

### Workflow Examples

#### Example 1: Experimental Improvement (Local Only)

```bash
# You discover a potential improvement
/squad reflect

# Claude shows you proposed changes with diffs
## 提案 1: Add "optimize" keyword to backend routing
**改动详情 (Diff):**
```diff
# router.yaml
engineer:
  backend:
    keywords:
+     - optimize
+     - performance
```

# Step 1: Select which changes to apply
[✓] 提案 1: Add "optimize" keyword to backend routing

# Step 2: Choose sync strategy
→ 您选择: ✅ 仅更新本地 (Local only)

# Claude applies to local only
✅ 改动已应用到本地:
   - ~/.claude/ (运行时) → 立即生效 ✓

📝 注意:
   - 这些改动仅在您的本地环境生效
   - 未同步到 squad-dist/ 仓库源文件
   - 如果将来运行 ./install.sh，这些改动可能会被覆盖

# You test it for a few days...
# If it works well, run /squad reflect again and choose "Local + Repo"
```

---

#### Example 2: Confirmed Improvement (Local + Repo)

```bash
# You've tested the improvement and it works great
/squad reflect

# Claude shows the same proposal
## 提案 1: Add "optimize" keyword to backend routing

# Step 1: Select changes
[✓] 提案 1: Add "optimize" keyword to backend routing

# Step 2: Choose sync strategy
→ 您选择: 🚀 更新本地并同步到仓库 (Local + Repo)

# Claude applies to both locations
✅ 改动已应用到两个位置:
   - ~/.claude/ (运行时) → 立即生效 ✓
   - squad-dist/ (源文件) → 可以 commit 到 git ✓

💡 建议操作:
   git add squad-dist/
   git commit -m "evolve: Add optimize keyword to improve backend routing"
   git push  # 分享给其他用户

# You commit and push
$ git add squad-dist/router/router.yaml
$ git commit -m "evolve: Add optimize keyword to backend routing"
$ git push

# Your teammates pull the update
$ git pull
$ ./install.sh  # Sync to their ~/.claude/

# They now have your improvement! 🎉
```

---

#### Example 3: Multiple Changes with Mixed Strategies

```bash
/squad reflect

# Claude proposes 3 improvements
## 提案 1: Add "optimize" keyword (High confidence)
## 提案 2: Change default model to Opus (Medium confidence)
## 提案 3: Add verbose logging (Low confidence)

# Step 1: Select only high-confidence changes
[✓] 提案 1: Add "optimize" keyword
[ ] 提案 2: Change default model
[ ] 提案 3: Add verbose logging

# Step 2: Choose Local + Repo for confirmed improvement
→ 您选择: 🚀 更新本地并同步到仓库 (Local + Repo)

# Result: Only proposal 1 applied and synced to repo
```

### Safety Guarantees

1. **Atomic Updates** - Both paths updated together or neither
2. **Backup Both** - Both runtime and source backed up before changes
3. **Verify Match** - After sync, verify runtime == source
4. **Rollback Both** - On error, rollback both paths
5. **Audit Trail** - Log which files changed in both locations

### Failure Handling

```python
# Scenario: Runtime update succeeds, source update fails
try:
    apply_change("~/.claude/agents/engineer.md", change)
    apply_change("squad-dist/agents/engineer.md", change)
except Exception:
    # Rollback BOTH files
    restore_backup("~/.claude/agents/engineer.md")
    restore_backup("squad-dist/agents/engineer.md")
    # Log failure
    # User sees: "Change failed, rolled back both locations"
```

---

## Integration with Squad

### When to Invoke Reflect

**Recommended:**
- After completing a complex task
- When user provides corrections
- End of work session
- Weekly (for active projects)

**Not recommended:**
- After every small task (too frequent)
- When no issues encountered (waste of tokens)

### Auto-Reflect (Optional)

```yaml
# ~/.squad/config.yaml
reflection:
  auto_reflect: false  # Don't auto-reflect (user-initiated only)
  frequency: weekly    # If enabled, how often
  confidence_threshold: high  # Only apply high-confidence changes
```

---

## Version

- **v0.1.0** - Initial reflection and evolution system
