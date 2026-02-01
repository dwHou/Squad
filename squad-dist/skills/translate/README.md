# Translate Skill

**Version:** 0.2.0
**Purpose:** Intelligent translation for code, documentation, and natural language

---

## Files in This Directory

```
translate/
├── translate.md          # Main skill definition (comprehensive documentation)
├── scan_non_ascii.py     # Python script for finding non-ASCII characters
├── SCAN_USAGE.md         # Detailed usage guide for scanner
├── test_sample.py        # Sample file with Chinese comments for testing
└── README.md             # This file (quick reference)
```

---

## Quick Start

### 1. Scan for Non-English Characters

Find all Chinese comments, Japanese text, or any non-ASCII characters:

```bash
# Scan entire directory
python3 scan_non_ascii.py src/

# Scan specific file types
python3 scan_non_ascii.py --type py src/

# Scan single file
python3 scan_non_ascii.py path/to/file.py
```

**Output format:**
```
found 15 non-ASCII locations in 5 files

src/auth.py:
    23: # 用户认证模块
    45: # 验证 token 有效性

src/utils.py:
    12: # 工具函数
```

### 2. Translate Comments

Translate code comments while preserving code:

```bash
# Through Squad
/translate comments "src/**/*.py" zh en

# Batch translate directory
/translate comments-batch src/ zh en
```

### 3. Translate Documents

Translate entire files:

```bash
/translate file README.md en zh
→ Creates README.zh.md
```

---

## Usage Through Squad

### From User

```bash
# Scan for Chinese comments
/translate scan src/

# Translate comments
/translate comments "src/**/*.py" zh en

# Translate README
/translate file README.md en zh
```

### From Agent (Programmatic)

```python
# Engineer agent: Find Chinese comments before translation
Task(skill="translate", args="scan src/")

# Translate all comments
Task(skill="translate", args="comments-batch src/ zh en")

# Verify completion
Task(skill="translate", args="scan src/")
```

---

## Key Features

### 1. Non-ASCII Scanner

- **Fast:** Scans ~1000 files/second
- **Precise:** Shows exact file:line locations
- **Smart:** Auto-skips build directories (node_modules, vendor, etc.)
- **Flexible:** Filter by file type (--type py, js, cpp, etc.)

**Use cases:**
- Pre-translation audit (find all non-English text)
- Post-translation verification (ensure nothing missed)
- Code review (check language consistency)
- Localization audit (find hard-coded strings)

### 2. Code Comment Translation

- **Safe:** Code is NEVER modified, only comments
- **Smart:** Detects comment types (inline, block, docstring)
- **Multi-language:** Python, JS, Go, Rust, Java, C++, etc.
- **Batch mode:** Translate entire directories

**Critical rule:** Function names, variable names, and code logic are never changed.

### 3. Smart Interactive Translation

When user language ≠ English:
- Agent outputs auto-translated to user's language
- Technical terms use bilingual format: `译文 (Original)`
- Code, paths, commands remain unchanged

---

## Complete Workflow Example

```bash
# Step 1: Pre-translation audit
$ /translate scan src/

Output:
Found 23 non-ASCII locations in 8 files
src/auth.py:23 # 用户认证模块
src/auth.py:45 # 验证 token 有效性
...

# Step 2: Batch translate all comments
$ /translate comments-batch src/ zh en

Output:
✓ Translated 23 comments in 8 files
  src/auth.py (3 comments)
  src/utils.py (5 comments)
  ...

# Step 3: Verify completion
$ /translate scan src/

Output:
✓ No non-ASCII characters found
✓ Translation complete!
```

---

## Documentation

- **[translate.md](./translate.md)** - Full skill definition with all features, examples, and technical details
- **[SCAN_USAGE.md](./SCAN_USAGE.md)** - Comprehensive scanner usage guide with workflows and troubleshooting
- **[test_sample.py](./test_sample.py)** - Sample file for testing scanner (has Chinese comments)

---

## Testing

### Test the Scanner

```bash
# Test on sample file
python3 scan_non_ascii.py test_sample.py

# Expected: Find 15 locations with Chinese text

# Test help
python3 scan_non_ascii.py --help

# Test file type filter
python3 scan_non_ascii.py --type py ../
```

### Test Translation Flow

```bash
# 1. Scan before translation
python3 scan_non_ascii.py test_sample.py > before.txt

# 2. Translate (through Squad)
/translate comments test_sample.py zh en

# 3. Scan after translation
python3 scan_non_ascii.py test_sample.py > after.txt

# 4. Compare
diff before.txt after.txt
# → Should show no non-ASCII chars in after.txt
```

---

## Technical Details

### Scanner Implementation

**File:** `scan_non_ascii.py`

**Algorithm:**
1. Walk directory tree recursively
2. Skip excluded directories (node_modules, vendor, etc.)
3. Filter by file extension
4. Read each file line by line (UTF-8)
5. Check each character: if ord(char) > 127, it's non-ASCII
6. Output: `<file_path>:<line_num> <line_content>`

**Performance:**
- Memory efficient: Streams files line-by-line
- Fast: ~1000 files/second on typical hardware
- Safe: Read-only (unless --convert-bom used)

### Supported File Types

By default scans:
- Programming: `.py`, `.js`, `.ts`, `.tsx`, `.jsx`, `.go`, `.rs`, `.rb`, `.php`, `.java`, `.swift`, `.kt`
- C/C++: `.h`, `.cpp`, `.c`, `.cc`, `.cxx`, `.mm`, `.m`
- Shell: `.sh`, `.bash`
- Docs: `.md`, `.txt`, `.markdown`, `.README`
- Config: `.yml`, `.yaml`
- Assembly: `.asm`, `.S`

### Auto-Excluded Directories

- `node_modules/`, `vendor/`, `vendors/`, `third_party/`
- `.git/`, `.svn/`, `.hg/`
- `build/`, `dist/`, `target/`
- `__pycache__/`, `.pytest_cache/`
- `venv/`, `env/`, `.env/`

---

## Roadmap

### v0.2.0 (Current)
- ✅ Non-ASCII character scanner
- ✅ Pre-translation audit workflow
- ✅ Post-translation verification
- ✅ File type filtering
- ✅ UTF-8 BOM conversion

### v0.3.0 (Planned)
- 🔄 Comment-only scan mode (ignore strings/literals)
- 🔄 JSON output format for automation
- 🔄 Custom exclude patterns
- 🔄 Language detection (distinguish Chinese/Japanese/Korean)
- 🔄 Git integration (scan only changed files)

---

## Command Reference

### Scanner Commands

```bash
# Basic scan
python3 scan_non_ascii.py <path>

# Filter by file type
python3 scan_non_ascii.py --type <ext> <path>

# Convert UTF-8 BOM to UTF-8
python3 scan_non_ascii.py --convert-bom <path>

# Show help
python3 scan_non_ascii.py --help
```

### Translation Commands

```bash
# Scan (via Squad)
/translate scan <path>
/translate scan --type <ext> <path>

# Translate comments
/translate comments <pattern> <src_lang> <tgt_lang>
/translate comments-batch <dir> <src_lang> <tgt_lang>

# Translate files
/translate file <path> <src_lang> <tgt_lang>
/translate text <src_lang> <tgt_lang> <content>
```

---

## Best Practices

### 1. Always Scan First
Before translating, scan to understand scope:
```bash
/translate scan src/
# → Review locations
/translate comments-batch src/ zh en
# → Verify completion
/translate scan src/
```

### 2. Use File Type Filters
Avoid unnecessary files:
```bash
# Only Python
/translate scan --type py src/

# Only TypeScript
/translate scan --type tsx frontend/
```

### 3. Verify After Translation
Always scan again after translation to ensure nothing missed:
```bash
/translate comments-batch src/ zh en
/translate scan src/
# → Should show: ✓ No non-ASCII characters found
```

### 4. Document Findings
Save scan results for reference:
```bash
python3 scan_non_ascii.py src/ > scan_report.txt
```

---

## Troubleshooting

### Issue: Too Many Results

**Problem:** Scanner finds non-ASCII in URLs, emojis, etc.

**Solution:** Future versions will add comment-only mode. Current workaround: Review output and filter manually.

### Issue: Missing Files

**Problem:** Expected files not scanned

**Solution:** Check if file extension is in supported list, or use `--type`:
```bash
python3 scan_non_ascii.py --type vue src/
```

### Issue: Permission Denied

**Problem:** Cannot read certain files

**Solution:** Scanner automatically skips unreadable files. Check file permissions if needed.

---

## Contributing

To add new features or fix bugs:

1. Edit source files in `squad-dist/skills/translate/`
2. Test changes:
   ```bash
   python3 scan_non_ascii.py test_sample.py
   ```
3. Update documentation (translate.md, SCAN_USAGE.md)
4. Run installation:
   ```bash
   cd ../../..
   ./install.sh
   ```

---

## Support

For issues or questions:
- **Documentation:** Read [translate.md](./translate.md) and [SCAN_USAGE.md](./SCAN_USAGE.md)
- **GitHub Issues:** [Squad Repository](https://github.com/yourusername/squad/issues)
- **Testing:** Use `test_sample.py` to verify scanner functionality

---

<p align="center">
  <b>Squad Translation Skill</b><br>
  Intelligent translation with comprehensive non-ASCII detection
</p>
