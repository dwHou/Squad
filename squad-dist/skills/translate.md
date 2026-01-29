# Translate Skill / 翻译技能

**Skill:** `translate` / `翻译`
**Version:** 0.1.0
**Purpose:** Intelligent translation for code, documentation, and natural language

---

## Overview

The Translate skill provides intelligent translation capabilities for Squad agents, enabling seamless multilingual interactions and code documentation translation.

翻译技能为 Squad 智能体提供智能翻译能力，支持多语言交互和代码文档翻译。

---

## Core Capabilities

### 1. Full Text Translation / 全文翻译

**Purpose:** Translate complete documents, articles, or papers

**Sub-commands:**
- `/translate text [source_lang] [target_lang] <content>`
- `/translate file <file_path> [source_lang] [target_lang]`

**Features:**
- Context-aware translation
- Preserves formatting (markdown, LaTeX, etc.)
- Handles technical terminology
- Maintains code blocks unchanged

**Example:**
```bash
/translate text en zh "This is a technical document about AI agents."
→ "这是一篇关于 AI 智能体的技术文档。"

/translate file README.md en zh
→ Creates README.zh.md
```

---

### 2. Code Comment Translation / 代码注释翻译

**Purpose:** Find and translate all comments in code files from one language to another

**Sub-commands:**
- `/translate comments <file_pattern> [source_lang] [target_lang]`
- `/translate comments-batch <directory> [source_lang] [target_lang]`

**Features:**
- Language detection for comments
- **CRITICAL: Code itself is NEVER modified** - only comments/docstrings are translated
- Preserves code structure exactly
- Handles inline comments, block comments, docstrings
- Supports multiple programming languages (Python, JS, Go, Rust, Java, etc.)

**Example:**
```bash
# Translate all Chinese comments in Python files to English
/translate comments "src/**/*.py" zh en

# Before:
def calculate_sum(a, b):
    """计算两个数的和"""
    return a + b  # 返回结果

# After:
def calculate_sum(a, b):
    """Calculate the sum of two numbers"""
    return a + b  # Return result
```

**🚨 Critical Rule: Code Immutability**
```python
# ✅ CORRECT: Only comments translated
def getUserData(userId):  # 获取用户数据 → Get user data
    return database.query(userId)

# ❌ WRONG: Function name changed (NEVER do this)
def 获取用户数据(userId):  # This would break the code!
    return database.query(userId)
```

---

### 3. Smart Interactive Translation / 智能交互翻译

**Purpose:** Auto-translate agent outputs based on user language preference

**Activation:** Automatically enabled when `~/.squad/config.yaml` has `language: zh`

**Behavior:**
- Agent outputs in English → Auto-translate to Chinese
- Technical terms → Keep original with Chinese explanation
- Code snippets → Unchanged
- File paths → Unchanged
- Commands → Unchanged

**Example:**
```
# User language: zh
Agent (English): "I found 3 files that match your query."
Auto-translated: "我找到了 3 个匹配您查询的文件。"

Agent (English): "The function `calculateTotal()` is defined in src/utils.js:42"
Smart-translated: "函数 `calculateTotal()` 定义在 src/utils.js:42"
```

---

### 4. Paper Translation / 论文翻译

**Purpose:** Translate academic papers while preserving citations, equations, and technical terms

**Sub-commands:**
- `/translate paper <file_path> [source_lang] [target_lang]`

**Features:**
- Preserves citations (APA, MLA, IEEE)
- Keeps mathematical equations unchanged
- Maintains figure/table references
- Handles technical terminology dictionary
- Bilingual glossary generation

**Example:**
```bash
/translate paper paper.pdf en zh
→ Creates paper.zh.pdf with bilingual glossary
```

---

## Agent Integration

### When Agents Should Use Translation

| Agent | Use Case | Translation Type |
|-------|----------|------------------|
| Researcher | Reading English papers | Paper translation |
| Researcher | Analyzing foreign code | Comment translation |
| Engineer | Writing bilingual docs | Full text translation |
| Tester | Translating test reports | Full text translation |
| Any | User language ≠ English | Smart interactive |

---

## Professional Terminology Handling / 专业词汇处理

### Bilingual Format for Technical Terms

**Purpose:** Preserve original terminology in parentheses for clarity and reference

**Rule:** When translating technical/professional terms, use format: `译文 (Original)`

### What Qualifies as Professional Terminology?

Use this checklist to determine if a term should get bilingual treatment:

```
□ Technical jargon (API, JWT, OAuth, etc.)
□ Domain-specific terms (machine learning → 机器学习)
□ Borrowed words commonly used in original language
□ Ambiguous translations with multiple meanings
□ Terms where precision is critical
□ New/emerging concepts without standard translations
```

### Translation Levels by Term Type

| Term Type | Translation Approach | Example |
|-----------|---------------------|---------|
| **Common tech terms** | Translate + keep original | "应用程序接口 (API)" |
| **Framework names** | Keep original only | "React", "Vue.js" |
| **Well-established terms** | Translate only | "文件" (file), "函数" (function) |
| **Ambiguous terms** | Translate + original | "上下文 (context)" |
| **Company/product names** | Keep original only | "GitHub", "Claude" |

### Examples

#### Good: Bilingual Format
```markdown
zh-CN:
"这个系统使用微服务架构 (microservices architecture)，
通过应用程序接口 (API) 进行通信。每个服务都有独立的
数据库 (database)，使用容器 (containers) 部署。"

ja-JP:
"このシステムはマイクロサービスアーキテクチャ (microservices architecture) を使用し、
API (アプリケーションプログラミングインターフェース) で通信します。"
```

#### Bad: Missing Original Terms
```markdown
❌ "这个系统使用微服务架构，通过应用程序接口进行通信。"
(User may not understand what specific architecture is meant)
```

### Judgment Criteria for Bilingual Format

**Use bilingual format when:**
1. **Technical precision matters** - "认证 (authentication) vs 授权 (authorization)"
2. **Term is commonly used in original language** - "API", "token", "cache"
3. **Multiple valid translations exist** - "context" → 上下文/语境/背景
4. **Searchability is important** - Original term helps code/doc search
5. **International collaboration** - Team has mixed language speakers

**Don't use bilingual format when:**
1. **Term has standard, unambiguous translation** - "文件 (file)"
2. **Common everyday word** - "用户 (user)", "数据 (data)"
3. **Translation is widely accepted** - "计算机 (computer)"
4. **Would clutter readability** - Too many parentheses

### Automatic Detection Heuristics

The translation system should automatically apply bilingual format for:

```python
# Technical term patterns
BILINGUAL_PATTERNS = {
    # ALL CAPS acronyms
    r'\b[A-Z]{2,}\b': True,  # API, JWT, HTTP, REST

    # CamelCase (likely code identifiers)
    r'\b[A-Z][a-z]+[A-Z]\w*': True,  # UserService, AuthToken

    # snake_case (likely code identifiers)
    r'\b[a-z]+_[a-z_]+\b': True,  # get_user, auth_token

    # Tech stack names (with version numbers)
    r'\b\w+\s*\d+(\.\d+)*': True,  # Python 3.11, Node.js 18

    # Common tech terms (dictionary-based)
    'authentication', 'authorization', 'middleware',
    'orchestration', 'serialization', 'deserialization',
    'refactoring', 'polymorphism', 'encapsulation'
}
```

### Custom Terminology Dictionary

Users can define project-specific terms in `~/.squad/translation.yaml`:

```yaml
glossary:
  # Always use bilingual format for these
  - source: "circuit breaker"
    target_zh: "断路器 (circuit breaker)"
    bilingual: true

  - source: "saga pattern"
    target_zh: "Saga 模式 (saga pattern)"
    bilingual: true

  # Standard translation (no bilingual)
  - source: "user"
    target_zh: "用户"
    bilingual: false
```

### Context-Aware Bilingual Decisions

```python
# Example: Decide based on context
def should_use_bilingual(term, context):
    # In technical documentation → use bilingual
    if context == "documentation":
        if is_technical_term(term):
            return True

    # In code comments → use bilingual
    if context == "code_comment":
        if is_technical_term(term):
            return True

    # In user-facing UI → avoid bilingual (cleaner)
    if context == "ui_text":
        return False

    # In academic papers → use bilingual
    if context == "paper":
        if is_academic_term(term):
            return True
```

---

## Translation Quality Levels

### Level 1: Literal Translation
- Direct word-for-word translation
- Fast, suitable for quick understanding

### Level 2: Context-Aware (Default)
- Considers surrounding context
- Natural phrasing
- Balanced speed/quality

### Level 3: Professional Translation
- Domain-specific terminology
- Publication-ready quality
- Slower, for important documents

**Usage:**
```bash
/translate text --quality=3 en zh <content>
```

---

## Technical Implementation

### Language Detection

Auto-detect source language if not specified:
```python
def detect_language(text: str) -> str:
    # Use language detection library or LLM
    # Priority: code comments > natural text
    return lang_code
```

### Comment Extraction Patterns

| Language | Comment Types | Regex Patterns |
|----------|--------------|----------------|
| Python | `#`, `"""`, `'''` | `#.*$`, `""".*?"""` |
| JavaScript | `//`, `/* */` | `//.*$`, `/\*.*?\*/` |
| Go | `//`, `/* */` | `//.*$`, `/\*.*?\*/` |
| Rust | `//`, `/* */`, `///` | `///.*$`, `//.*$` |
| Java | `//`, `/* */`, `/** */` | `/** .*? */` |

### Preserve Code Blocks

```markdown
# Markdown code blocks
```python
# Don't translate code
```

# Inline code
Keep `function_name` unchanged
```

---

## Configuration

### Translation Engine

```yaml
# ~/.squad/translation.yaml
engine: claude  # claude | openai | google | deepl
model: sonnet   # for claude
fallback: google

# Terminology dictionary
glossary:
  - source: "agent"
    target: "智能体"
  - source: "orchestration"
    target: "编排"

# Quality settings
default_quality: 2  # 1-3
preserve_formatting: true
```

---

## Smart Translation Rules

### Auto-Inject Translation Prompt

When `language: zh` in config, inject this into agent prompts:

```markdown
## 🌐 Translation Instruction

User language preference: Chinese (zh)

**Response Format:**
1. Generate your response in English (for clarity)
2. Auto-translate user-facing output to Chinese
3. **CRITICAL: Keep unchanged:**
   - **Code snippets** (NEVER translate code)
   - **Function/variable/class names** (keep as-is)
   - File paths
   - Command syntax
   - Technical identifiers
   - URLs

**Smart Translation with Bilingual Terms:**
- Professional/technical terms: Use bilingual format `译文 (Original)`
- Examples:
  - "智能体 (agent)"
  - "路由器 (router)"
  - "应用程序接口 (API)"
  - "身份验证 (authentication)"
- Well-established terms: Translate only
  - "文件" (file), "函数" (function), "用户" (user)
- Error messages: Translate explanation + keep original error
- File references: Keep as-is

**Professional Term Criteria:**
Use bilingual format `译文 (Original)` when:
- Technical jargon (API, JWT, OAuth)
- Domain-specific terms (microservices, orchestration)
- Ambiguous translations (context → 上下文/语境)
- Terms commonly used in English
- Precision is critical

**Code Translation Rules:**
```python
# ✅ CORRECT: Only comments translated
def getUserData(userId):  # 获取用户数据
    """Get user data from database"""
    return db.query(userId)

# ❌ WRONG: Code modified (NEVER do this)
def 获取用户数据(用户ID):  # This breaks the code!
    return db.query(用户ID)
```

**Example Output:**
```
✅ Good:
"函数 `calculateTotal()` 在 src/utils.js:42 中定义。
它使用了路由器 (router) 来处理应用程序接口 (API) 请求。"

❌ Bad (code translated):
"函数 `计算总数()` 在 源/工具.js:42 中定义"
(NEVER translate code!)

❌ Bad (missing original terms):
"函数 `calculateTotal()` 在 src/utils.js:42 中定义。
它使用了路由器来处理应用程序接口请求。"
(Should keep original: "路由器 (router)", "应用程序接口 (API)")
```
```

---

## Command Reference

### Invoke Translation Skill

```bash
# From user
/translate <subcommand> [options]

# From agent (programmatic)
Task(
    skill="translate",
    args="comments src/**/*.py zh en"
)
```

### Sub-commands

| Command | Description |
|---------|-------------|
| `text` | Translate plain text or documents |
| `file` | Translate entire file |
| `comments` | Translate code comments |
| `comments-batch` | Batch translate comments in directory |
| `paper` | Translate academic paper |
| `help` | Show translation help |

---

## Examples

### Example 1: Researcher Reading English Paper

```bash
# User (zh): 帮我读这篇论文
/squad @researcher:documentation 分析 paper.pdf

# Researcher invokes:
Task(skill="translate", args="paper paper.pdf en zh")

# Result: paper.zh.md with Chinese translation
```

### Example 2: Engineer Writing Bilingual Docs

```bash
# User: 把 README 翻译成英文
/squad @engineer:fullstack 翻译 README.md

# Engineer invokes:
Task(skill="translate", args="file README.md zh en")

# Result: README.en.md created
```

### Example 3: Code Comment Translation

```bash
# User: 把代码注释翻译成英文
/translate comments "src/**/*.py" zh en

# Before:
# 这是一个工具函数
def helper():
    pass

# After:
# This is a helper function
def helper():
    pass
```

---

## Error Handling

### Unsupported Language Pair

```
❌ Translation from {source_lang} to {target_lang} is not supported.

Supported languages: en, zh, ja, ko, fr, de, es, ru

Use /translate help to see all options.
```

### Failed Detection

```
⚠️ Could not detect source language. Please specify:
/translate text <source_lang> <target_lang> <content>
```

---

## Performance Optimization

### Caching Strategy

```python
# Cache translations to avoid re-translating
cache_key = f"{source_lang}:{target_lang}:{hash(text)}"
if cache_key in translation_cache:
    return translation_cache[cache_key]
```

### Batch Processing

```python
# Translate multiple comments in one API call
comments = extract_all_comments(file)
translated = translate_batch(comments, source_lang, target_lang)
replace_comments(file, translated)
```

---

## Integration with Agents

### Researcher Agent

```markdown
# In researcher.md

## Available Skills

### Translation
When reading foreign language documentation or papers:
- Use `/translate paper` for academic papers
- Use `/translate file` for technical docs
- Use `/translate text` for code comments

Example:
Task(skill="translate", args="paper arxiv-paper.pdf en zh")
```

### Engineer Agent

```markdown
# In engineer.md

## Available Skills

### Translation
When creating bilingual documentation:
- Use `/translate file` for README translation
- Use `/translate comments` for code comment translation

Example:
Task(skill="translate", args="comments src/**/*.py zh en")
```

---

## Roadmap

### v0.1.0 (MVP)
- ✅ Full text translation
- ✅ Code comment translation
- ✅ Smart interactive translation
- ✅ Auto-inject translation prompt

### v0.2.0 (Planned)
- Terminology dictionary
- Translation memory
- Quality levels (1-3)
- Batch processing optimization

### v0.3.0 (Planned)
- Paper translation (PDF support)
- Bilingual glossary generation
- Custom translation engine support

---

## Best Practices

### For Agents

1. **Always check user language preference** before generating output
2. **Use smart translation** for technical content (keep code, paths unchanged)
3. **Invoke translation skill** for document translation tasks
4. **Preserve formatting** when translating markdown/code

### For Users

1. **Set language preference** using `/squad set-lang zh`
2. **Use specific sub-commands** for different translation needs
3. **Review translations** for technical accuracy
4. **Build terminology glossary** for project-specific terms

---

## Troubleshooting

### Issue: Translation quality poor

**Solution:**
- Increase quality level: `--quality=3`
- Add to terminology glossary
- Specify context: `--context="machine learning"`

### Issue: Code blocks translated

**Solution:**
- Check preserve_formatting setting
- Use `comments` sub-command instead of `text`

### Issue: Technical terms wrong

**Solution:**
- Add to glossary in `~/.squad/translation.yaml`
- Use bilingual format: "agent (智能体)"

---

## Version History

- **v0.1.0** - Initial translation skill (MVP)
  - Full text translation
  - Code comment translation
  - Smart interactive translation
