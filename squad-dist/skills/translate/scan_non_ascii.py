#!/usr/bin/env python

import os
import io


def check_non_ascii(file_path):
    line_num = 1
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            for line in file.readlines():
                if any(ord(char) > 127 for char in line):
                    print(f'{file_path}:{line_num} {line.strip()}')
                line_num += 1
    except:
        print(f'{file_path}:{line_num}')


def convert_utf8_bom_to_utf8(file_path):
    with open(file_path, 'rb') as file:
        file_bytes = file.read()

    if file_bytes[:3] == b'\xef\xbb\xbf':
        print(f"{file_path} is UTF-8 BOM")
        file_content = file_bytes[3:].decode('utf-8')
        with io.open(file_path, 'w', encoding='utf-8', newline='') as file:
            file.write(file_content)


def check_directory(directory):
    for root, _, files in os.walk(directory):
        is_skip = False
        for skip in ['cldnn', 'third_party', 'vendors']:
            if skip in root:
                is_skip = True
        if is_skip:
            continue
        for file_name in files:
            for ext in ['.h', '.cpp', '.mm', '.asm', '.S', '.py', '.README', '.sh', '.txt']:
                if file_name.endswith(ext):
                    file_path = os.path.join(root, file_name)
                    convert_utf8_bom_to_utf8(file_path)
                    check_non_ascii(file_path)
