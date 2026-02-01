#!/usr/bin/env python3
"""
Non-ASCII Character Scanner for Translation Skill
Finds all non-English characters in code files to support comprehensive translation.
"""

import os
import sys
import argparse
from pathlib import Path


# Default file extensions to scan
DEFAULT_EXTENSIONS = [
    '.h', '.cpp', '.c', '.cc', '.cxx',  # C/C++
    '.mm', '.m',  # Objective-C
    '.py',  # Python
    '.js', '.jsx', '.ts', '.tsx',  # JavaScript/TypeScript
    '.java',  # Java
    '.go',  # Go
    '.rs',  # Rust
    '.rb',  # Ruby
    '.php',  # PHP
    '.swift',  # Swift
    '.kt', '.kts',  # Kotlin
    '.asm', '.S',  # Assembly
    '.sh', '.bash',  # Shell
    '.txt', '.md', '.markdown',  # Documentation
    '.README', '.yml', '.yaml',  # Config
]

# Directories to skip (common third-party/build directories)
SKIP_DIRECTORIES = [
    'node_modules', 'vendor', 'vendors', 'third_party',
    '.git', '.svn', '.hg',
    'build', 'dist', 'target',
    '__pycache__', '.pytest_cache',
    'venv', 'env', '.env',
    'cldnn',  # Original skip directory
]


def check_non_ascii(file_path, results):
    """Check a single file for non-ASCII characters."""
    line_num = 0
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            for line in file:
                line_num += 1
                if any(ord(char) > 127 for char in line):
                    results.append({
                        'file': file_path,
                        'line': line_num,
                        'content': line.strip()
                    })
    except UnicodeDecodeError:
        # Skip binary files or files with encoding issues
        pass
    except Exception as e:
        print(f"⚠️  Error reading {file_path}: {e}", file=sys.stderr)


def convert_utf8_bom_to_utf8(file_path):
    """Convert UTF-8 BOM files to pure UTF-8."""
    try:
        with open(file_path, 'rb') as file:
            file_bytes = file.read()

        if file_bytes[:3] == b'\xef\xbb\xbf':
            print(f"🔄 Converting UTF-8 BOM to UTF-8: {file_path}")
            file_content = file_bytes[3:].decode('utf-8')
            with open(file_path, 'w', encoding='utf-8', newline='') as file:
                file.write(file_content)
    except Exception as e:
        print(f"⚠️  Error converting {file_path}: {e}", file=sys.stderr)


def scan_path(path, extensions=None, convert_bom=False):
    """Scan a file or directory for non-ASCII characters."""
    results = []
    path = Path(path).resolve()

    if extensions is None:
        extensions = DEFAULT_EXTENSIONS

    # Single file
    if path.is_file():
        if any(str(path).endswith(ext) for ext in extensions):
            if convert_bom:
                convert_utf8_bom_to_utf8(str(path))
            check_non_ascii(str(path), results)
        return results

    # Directory
    if path.is_dir():
        for root, dirs, files in os.walk(path):
            # Skip excluded directories
            dirs[:] = [d for d in dirs if d not in SKIP_DIRECTORIES]

            for file_name in files:
                if any(file_name.endswith(ext) for ext in extensions):
                    file_path = os.path.join(root, file_name)
                    if convert_bom:
                        convert_utf8_bom_to_utf8(file_path)
                    check_non_ascii(file_path, results)

    return results


def format_results(results):
    """Format scan results for display."""
    if not results:
        print("✓ 未找到非英文字符")
        print("✓ No non-ASCII characters found")
        return

    # Group by file
    by_file = {}
    for result in results:
        file_path = result['file']
        if file_path not in by_file:
            by_file[file_path] = []
        by_file[file_path].append(result)

    # Print results
    total_count = len(results)
    file_count = len(by_file)

    print(f"\n找到 {total_count} 处非英文字符 (共 {file_count} 个文件)")
    print(f"Found {total_count} non-ASCII locations in {file_count} files\n")
    print("━" * 80)

    for file_path in sorted(by_file.keys()):
        print(f"\n{file_path}:")
        for result in by_file[file_path]:
            line_num = result['line']
            content = result['content']
            print(f"  {line_num:4d}: {content}")

    print("\n" + "━" * 80)
    print(f"\n✓ 扫描完成 | Scan complete")


def main():
    parser = argparse.ArgumentParser(
        description='Scan code files for non-ASCII characters (Chinese comments, etc.)'
    )
    parser.add_argument(
        'path',
        help='File or directory to scan'
    )
    parser.add_argument(
        '--type',
        help='File extension filter (e.g., py, js, cpp)',
        default=None
    )
    parser.add_argument(
        '--convert-bom',
        action='store_true',
        help='Convert UTF-8 BOM files to pure UTF-8'
    )

    args = parser.parse_args()

    # Build extension list
    extensions = None
    if args.type:
        # User specified type
        ext = args.type if args.type.startswith('.') else f'.{args.type}'
        extensions = [ext]

    # Scan
    results = scan_path(args.path, extensions=extensions, convert_bom=args.convert_bom)

    # Display results
    format_results(results)


if __name__ == '__main__':
    main()
