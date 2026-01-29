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

Use `AskUserQuestion` to present proposals:

```python
# Filter proposals by confidence level
high_confidence_proposals = [p for p in proposals if p.confidence == "high"]
medium_confidence_proposals = [p for p in proposals if p.confidence == "medium"]

if len(high_confidence_proposals) > 0:
    display_proposals_summary(high_confidence_proposals)

    answer = AskUserQuestion(
        questions=[{
            "question": "Would you like Squad to apply these improvements?",
            "header": "Evolution",
            "options": [
                {
                    "label": "✅ Apply all high-confidence improvements",
                    "description": "Low-risk improvements that enhance Squad's performance. All changes will be logged."
                },
                {
                    "label": "📋 Show me details first",
                    "description": "Review detailed diffs before deciding. You can approve individual changes."
                },
                {
                    "label": "❌ No changes this time",
                    "description": "Skip evolution. Squad will not modify any files."
                }
            ],
            "multiSelect": false
        }]
    )
```

---

## Step 5: Apply Approved Changes

### Change Application Process

```python
def apply_improvements(approved_proposals):
    """Apply approved improvements with logging and backup."""

    changes_log = []

    for proposal in approved_proposals:
        # 1. Backup original file
        backup_file(proposal.file_path)

        # 2. Apply change
        try:
            apply_change(proposal)

            # 3. Log success
            changes_log.append({
                "proposal_id": proposal.id,
                "file": proposal.file_path,
                "action": proposal.action,
                "status": "success",
                "timestamp": now(),
                "backup": backup_path
            })

        except Exception as e:
            # 4. Rollback on error
            restore_backup(proposal.file_path)

            changes_log.append({
                "proposal_id": proposal.id,
                "file": proposal.file_path,
                "status": "failed",
                "error": str(e),
                "rollback": "completed"
            })

    # 5. Write evolution log
    write_evolution_log(changes_log)

    # 6. Display summary
    display_evolution_summary(changes_log)
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
# Limit what can be modified
ALLOWED_FILES = [
    "~/.squad/router.yaml",           # Routing rules
    "~/.claude/agents/*.md",          # Agent definitions
    "~/.claude/skills/*.md",          # Skill definitions
    # "~/.squad/config.yaml",         # NOT allowed (user config)
    # "~/.claude/rules/*.md",         # NOT allowed (core rules)
]

def validate_change(proposal):
    if not is_allowed_file(proposal.file_path):
        raise SecurityError(f"Cannot modify {proposal.file_path}")
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
