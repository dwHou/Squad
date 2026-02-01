# Non-ASCII Scanner - Usage Guide

## Quick Start

The scan feature helps you find all non-English characters in your codebase, making it easy to identify Chinese comments, Japanese strings, or any non-ASCII text that needs translation.

### Basic Usage

```bash
# Scan a single file
python3 scan_non_ascii.py path/to/file.py

# Scan entire directory
python3 scan_non_ascii.py src/

# Scan specific file types
python3 scan_non_ascii.py --type py src/
python3 scan_non_ascii.py --type js frontend/

# Convert UTF-8 BOM files while scanning
python3 scan_non_ascii.py --convert-bom src/
```

---

## Through Translation Skill

When using Squad's translation skill, you can invoke the scanner:

```bash
# User command
/translate scan src/

# Agent programmatic call
Task(skill="translate", args="scan src/")
Task(skill="translate", args="scan --type py src/")
```

---

## Output Format

The scanner provides detailed location information:

```
找到 15 处非英文字符 (共 5 个文件)
Found 15 non-ASCII locations in 5 files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
src/auth.py:
    23: # 用户认证模块
    45: # 验证 token 有效性
    67: error_msg = "连接失败"

src/database.py:
    12: # 数据库连接池配置
    34: # 查询优化
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ 扫描完成 | Scan complete
```

**Format:** `<file_path>:<line_number>: <line_content>`

---

## Supported File Types

By default, the scanner checks these file types:

### Programming Languages
- **C/C++**: `.h`, `.cpp`, `.c`, `.cc`, `.cxx`
- **Objective-C**: `.mm`, `.m`
- **Python**: `.py`
- **JavaScript/TypeScript**: `.js`, `.jsx`, `.ts`, `.tsx`
- **Java**: `.java`
- **Go**: `.go`
- **Rust**: `.rs`
- **Ruby**: `.rb`
- **PHP**: `.php`
- **Swift**: `.swift`
- **Kotlin**: `.kt`, `.kts`

### Others
- **Assembly**: `.asm`, `.S`
- **Shell**: `.sh`, `.bash`
- **Documentation**: `.txt`, `.md`, `.markdown`, `.README`
- **Config**: `.yml`, `.yaml`

---

## Automatic Directory Exclusions

The scanner automatically skips common build/dependency directories:

- `node_modules/` - Node.js packages
- `vendor/`, `vendors/` - Third-party dependencies
- `third_party/` - Third-party code
- `.git/`, `.svn/`, `.hg/` - Version control
- `build/`, `dist/`, `target/` - Build outputs
- `__pycache__/`, `.pytest_cache/` - Python caches
- `venv/`, `env/`, `.env/` - Virtual environments

---

## Common Workflows

### 1. Pre-Translation Audit

Before translating, find all non-English text:

```bash
# Step 1: Scan to find all locations
/translate scan src/

# Output shows exact locations:
# src/auth.py:23 # 用户认证模块
# src/auth.py:45 # 验证 token 有效性

# Step 2: Review and decide
# → Yes, translate all Chinese comments to English

# Step 3: Batch translate
/translate comments-batch src/ zh en

# Step 4: Verify completion
/translate scan src/
# → ✓ No non-ASCII characters found
```

### 2. Code Review for Language Consistency

Ensure codebase uses consistent language:

```bash
# Check if any Chinese comments remain in production code
/translate scan src/ --type py

# Check JavaScript/TypeScript files
/translate scan frontend/ --type tsx

# Check all source files
/translate scan .
```

### 3. Localization Audit

Find hard-coded non-English strings:

```bash
# Scan for all non-ASCII strings
/translate scan src/

# Review output for user-facing strings
# Example findings:
# - Error messages in Chinese
# - UI labels in Japanese
# - Log messages in Korean

# Extract for i18n/l10n
```

### 4. Quality Assurance After Translation

Verify translation completed successfully:

```bash
# Before translation
/translate scan src/
# → Found 50 non-ASCII locations

# Translate all comments
/translate comments-batch src/ zh en

# Verify completion
/translate scan src/
# → ✓ No non-ASCII characters found (Success!)
```

---

## Command-Line Options

### `--type <extension>`

Filter scan by file extension:

```bash
# Python files only
python3 scan_non_ascii.py --type py src/

# JavaScript files only
python3 scan_non_ascii.py --type js frontend/

# Markdown files only
python3 scan_non_ascii.py --type md docs/

# Extension with or without dot works
python3 scan_non_ascii.py --type .cpp src/
```

### `--convert-bom`

Convert UTF-8 BOM files to pure UTF-8:

```bash
# Auto-convert BOM files while scanning
python3 scan_non_ascii.py --convert-bom src/

# Output when BOM files found:
# 🔄 Converting UTF-8 BOM to UTF-8: src/main.py
```

**What is UTF-8 BOM?**
- BOM = Byte Order Mark (U+FEFF)
- UTF-8 BOM files start with bytes: `EF BB BF`
- Can cause issues with some tools/parsers
- Pure UTF-8 is more compatible

---

## Integration with Squad Agents

### Engineer Agent

Use scan before and after translation:

```python
# Before: Find all Chinese comments
Task(skill="translate", args="scan src/")

# Translate
Task(skill="translate", args="comments-batch src/ zh en")

# After: Verify completion
Task(skill="translate", args="scan src/")
```

### Researcher Agent

Use scan to understand codebase language mix:

```python
# Scan to find language distribution
Task(skill="translate", args="scan .")

# Analyze results:
# - Which files have Chinese comments?
# - Which directories are bilingual?
# - Where is documentation in multiple languages?
```

---

## Troubleshooting

### Issue: Too Many False Positives

**Problem:** Finding non-ASCII in URLs, emojis, symbols

**Solution:** Currently scans all non-ASCII (Unicode > 127). Future versions will add comment-only mode:

```bash
# Future feature (v0.3.0)
/translate scan --comments-only src/
```

### Issue: Missing Files

**Problem:** Expected files not scanned

**Cause:** File extension not in default list

**Solution:** Use `--type` to explicitly specify:

```bash
# Scan .vue files
python3 scan_non_ascii.py --type vue src/
```

### Issue: Encoding Errors

**Problem:** `Error reading file: ...`

**Cause:** File is binary or has incompatible encoding

**Solution:** Scanner automatically skips binary files. This is expected behavior.

---

## Performance Notes

- **Fast:** Scans ~1000 files/second on typical hardware
- **Memory efficient:** Streams files line-by-line
- **Safe:** Read-only operation (unless `--convert-bom` used)

**Example timings:**
- Small project (~100 files): < 1 second
- Medium project (~1000 files): 1-2 seconds
- Large project (~10000 files): 10-15 seconds

---

## Examples

### Example 1: Clean Python Project

```bash
$ python3 scan_non_ascii.py src/

找到 23 处非英文字符 (共 8 个文件)
Found 23 non-ASCII locations in 8 files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
src/auth.py:
    23: # 用户认证模块
    45: # 验证 token 有效性
    67: error_msg = "连接失败"

src/utils.py:
    12: # 工具函数集
    34: # 数据验证
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ 扫描完成 | Scan complete
```

### Example 2: JavaScript Project

```bash
$ python3 scan_non_ascii.py --type tsx frontend/src/

找到 12 处非英文字符 (共 3 个文件)
Found 12 non-ASCII locations in 3 files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
frontend/src/components/Button.tsx:
    15: // 按钮组件
    23: const label = "提交"; // 按钮文字

frontend/src/utils/format.ts:
    8: // 格式化工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ 扫描完成 | Scan complete
```

### Example 3: No Non-ASCII Found

```bash
$ python3 scan_non_ascii.py src/

✓ 未找到非英文字符
✓ No non-ASCII characters found
```

---

## Best Practices

### 1. Scan Before Translation
Always scan first to understand scope:
```bash
/translate scan src/ > before.txt
# Review locations, decide translation strategy
/translate comments-batch src/ zh en
/translate scan src/ > after.txt
# Compare to ensure completion
```

### 2. Use Type Filters for Large Projects
Avoid scanning unnecessary files:
```bash
# Only Python
/translate scan --type py src/

# Only TypeScript/React
/translate scan --type tsx frontend/
```

### 3. Document Findings
Save scan results for reference:
```bash
python3 scan_non_ascii.py src/ > scan_report.txt
```

### 4. Regular Audits
Run periodic scans to maintain consistency:
```bash
# Weekly cron job
0 9 * * 1 python3 scan_non_ascii.py /path/to/project > weekly_scan.txt
```

---

## Roadmap

### Current (v0.2.0)
- ✅ Scan files and directories
- ✅ File type filtering
- ✅ UTF-8 BOM conversion
- ✅ Detailed location reporting
- ✅ Auto-skip build directories

### Planned (v0.3.0)
- 🔄 Comment-only mode (ignore strings/literals)
- 🔄 JSON output format for automation
- 🔄 Custom skip patterns (exclude specific files/dirs)
- 🔄 Language detection (distinguish Chinese/Japanese/Korean)
- 🔄 Integration with git diff (scan only changed files)

---

## FAQ

**Q: Does scan modify files?**
A: No, scan is read-only by default. Only `--convert-bom` modifies files (converts encoding).

**Q: Can I scan a single file?**
A: Yes! Just provide the file path: `scan_non_ascii.py src/main.py`

**Q: Why are some files skipped?**
A: Binary files and files with unsupported encoding are automatically skipped to prevent errors.

**Q: Can I customize excluded directories?**
A: Not yet, but planned for v0.3.0. Currently uses sensible defaults.

**Q: Does it work on Windows?**
A: Yes, Python 3 is cross-platform. Uses pathlib for compatibility.

---

## Support

For issues or feature requests:
- GitHub Issues: [Squad Repository](https://github.com/yourusername/squad/issues)
- Discord: [Squad Community](#)

---

<p align="center">
  <b>Squad Translation Skill - Non-ASCII Scanner</b><br>
  Find every non-English character with precision
</p>
