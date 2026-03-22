#!/usr/bin/env python3
"""
智能修復拼音標註，同時保留發音按鈕
"""

import re
import os
from pathlib import Path

def fix_ruby_keep_buttons(content):
    """
    修正拼音標註，但保留發音按鈕
    
    策略：
    1. 找到所有需要修正的ruby標註
    2. 檢查每個標註後面是否有發音按鈕
    3. 如果沒有發音按鈕，只修正ruby標註
    4. 如果有發音按鈕，修正ruby標註但保留按鈕
    """
    
    # 匹配需要修正的ruby標註（整句標註）
    # 格式：<ruby>漢字句子<rt>全拼音</rt></ruby>
    ruby_pattern = re.compile(r'(<ruby>([^<]+)<rt>([^<]+)</rt></ruby>)(\s*<button[^>]*>🔊[^<]*</button>)?')
    
    def fix_ruby_match(match):
        ruby_tag = match.group(1)  # 完整的ruby標註
        text = match.group(2)      # 漢字句子
        ruby = match.group(3)      # 全拼音
        button = match.group(4)    # 發音按鈕（可能為None）
        
        # 檢查是否需要修正（漢字數量 > 1）
        kanji_pattern = re.compile(r'[\u4e00-\u9faf\u3400-\u4dbf]')
        kanji_matches = list(kanji_pattern.finditer(text))
        kanji_count = len(kanji_matches)
        
        if kanji_count <= 1:
            # 只有一個漢字，不需要修正
            if button:
                return f'{ruby_tag}{button}'
            else:
                return ruby_tag
        else:
            # 需要拆分拼音標註
            # 這裡需要實際的漢字-假名對應，暫時先標記
            fixed_ruby = f'<!-- 需要拆分: {text} → {ruby} -->{ruby_tag}'
            if button:
                return f'{fixed_ruby}{button}'
            else:
                return fixed_ruby
    
    # 第一次處理：標記需要修正的句子
    content = ruby_pattern.sub(fix_ruby_match, content)
    
    return content

def process_file(filepath):
    """處理單個檔案"""
    print(f"處理: {filepath}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 檢查是否有需要修正的ruby標註
    ruby_pattern = re.compile(r'<ruby>([^<]+)<rt>([^<]+)</rt></ruby>')
    matches = list(ruby_pattern.finditer(content))
    
    if not matches:
        print(f"  ⚠️  沒有找到ruby標註，跳過")
        return False
    
    print(f"  找到 {len(matches)} 個ruby標註")
    
    # 檢查每個標註是否需要修正
    needs_fix = 0
    for match in matches:
        text = match.group(1)
        # 計算漢字數量
        kanji_pattern = re.compile(r'[\u4e00-\u9faf\u3400-\u4dbf]')
        kanji_matches = list(kanji_pattern.finditer(text))
        kanji_count = len(kanji_matches)
        
        if kanji_count > 1:
            needs_fix += 1
    
    if needs_fix == 0:
        print(f"  ✅ 所有ruby標註格式正確")
        return False
    
    print(f"  ⚠️  {needs_fix} 個標註需要修正")
    
    # 應用修正
    new_content = fix_ruby_keep_buttons(content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"  ✅ 已應用修正")
        return True
    else:
        print(f"  ⚠️  修正未改變內容")
        return False

def main():
    """主函數"""
    files_to_fix = [
        "src/content/posts/japanese-learning/lyrics/lemon-yume-naraba.md",
        "src/content/posts/japanese-learning/grammar/hypothetical-expression.md",
        "src/content/posts/japanese-learning/lemon-song/vocabulary-grammar-review.md"
    ]
    
    print("🔧 智能修復拼音標註（保留發音按鈕）")
    print("=" * 50)
    
    fixed_count = 0
    for filepath in files_to_fix:
        if Path(filepath).exists():
            if process_file(filepath):
                fixed_count += 1
        else:
            print(f"❌ 檔案不存在: {filepath}")
    
    print("=" * 50)
    print(f"📊 總結: 修正了 {fixed_count} 個檔案")
    
    if fixed_count > 0:
        print("\n🔍 注意事項:")
        print("1. 這個腳本只標記需要修正的句子")
        print("2. 實際的漢字-假名拆分需要手動進行")
        print("3. 發音按鈕已被保留")
        print("\n🎯 手動修正指南:")
        print("1. 對於每個標記的句子，需要手動拆分漢字和假名")
        print("2. 使用日文字典確認每個漢字的正確讀音")
        print("3. 保持發音按鈕的 data-text 屬性不變")
        print("4. 非漢字部分不需要ruby標註")

if __name__ == '__main__':
    main()