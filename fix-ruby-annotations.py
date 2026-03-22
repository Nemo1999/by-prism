#!/usr/bin/env python3
"""
日文拼音標註修正工具
將整句的拼音標註改為只標註漢字部分
"""

import re
import os
from pathlib import Path

def split_kanji_ruby(text, ruby):
    """
    將整句的拼音標註拆分為只標註漢字部分
    
    範例：
    輸入: text="昨夜、楽しい夢を見た", ruby="さくや、たのしいゆめをみた"
    輸出: "<ruby>昨<rt>さく</rt></ruby>夜、<ruby>楽<rt>たの</rt></ruby>しい<ruby>夢<rt>ゆめ</rt></ruby>を<ruby>見<rt>み</rt></ruby>た"
    """
    # 簡單的漢字檢測（日文漢字範圍）
    kanji_pattern = re.compile(r'[\u4e00-\u9faf\u3400-\u4dbf]')
    
    result = []
    i = 0  # text 索引
    j = 0  # ruby 索引
    
    while i < len(text):
        char = text[i]
        
        if kanji_pattern.match(char):
            # 找到漢字，需要找到對應的拼音
            # 漢字可能對應多個假名（如：楽→たの）
            kanji_start = i
            kanji_end = i + 1
            
            # 嘗試找到這個漢字對應的拼音
            ruby_start = j
            ruby_end = j + 1
            
            # 簡單規則：漢字通常對應1-3個假名
            # 這裡使用簡單的匹配，實際可能需要更複雜的邏輯
            result.append(f'<ruby>{char}<rt>')
            
            # 添加拼音（這裡需要更智能的匹配，暫時用佔位符）
            result.append(f'拼音</rt></ruby>')
            i += 1
            j += 1  # 簡單假設1:1對應
        else:
            # 非漢字，直接添加
            result.append(char)
            # 如果是日文字符，在ruby中也有對應
            if j < len(ruby) and char == ruby[j]:
                j += 1
            i += 1
    
    return ''.join(result)

def fix_ruby_annotations(content):
    """
    修正內容中的ruby標註
    """
    # 匹配 <ruby>漢字句子<rt>全句拼音</rt></ruby>
    pattern = re.compile(r'<ruby>([^<]+)<rt>([^<]+)</rt></ruby>')
    
    def replace_match(match):
        text = match.group(1)  # 漢字句子
        ruby = match.group(2)  # 全句拼音
        
        # 如果句子中只有一個漢字或很少漢字，可能不需要拆分
        # 這裡先簡單處理，實際需要更複雜的邏輯
        kanji_count = len(re.findall(r'[\u4e00-\u9faf\u3400-\u4dbf]', text))
        
        if kanji_count <= 1:
            # 只有一個漢字，保持原樣
            return match.group(0)
        else:
            # 多個漢字，需要拆分
            # 注意：這裡需要實際的漢字-假名對應關係
            # 暫時先標記需要手動處理
            return f'<!-- 需要手動拆分: {text} → {ruby} -->{match.group(0)}'
    
    return pattern.sub(replace_match, content)

def process_file(filepath):
    """處理單個檔案"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = fix_ruby_annotations(content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

def main():
    # 日文學習內容目錄
    japanese_dir = Path('src/content/posts/japanese-learning')
    
    if not japanese_dir.exists():
        print(f"錯誤: 目錄不存在 {japanese_dir}")
        return
    
    # 找到所有 Markdown 檔案
    md_files = list(japanese_dir.rglob('*.md'))
    
    print(f"找到 {len(md_files)} 個 Markdown 檔案")
    
    modified_count = 0
    for filepath in md_files:
        if process_file(filepath):
            print(f"已修改: {filepath.relative_to('.')}")
            modified_count += 1
    
    print(f"\n總共修改了 {modified_count} 個檔案")
    
    if modified_count > 0:
        print("\n注意：這個工具只標記需要手動處理的句子。")
        print("實際的漢字-假名拆分需要根據具體內容手動進行。")
        print("\n建議的處理方式：")
        print("1. 使用這個工具標記需要處理的句子")
        print("2. 手動拆分每個標記的句子")
        print("3. 使用日文字典確認漢字讀音")

if __name__ == '__main__':
    main()