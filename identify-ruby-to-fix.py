#!/usr/bin/env python3
"""
標記需要修正的ruby標註
找出所有整句拼音標註，方便手動處理
"""

import re
import os
from pathlib import Path

def find_ruby_to_fix(content, filepath):
    """找出需要修正的ruby標註"""
    # 匹配 <ruby>漢字句子<rt>全句拼音</rt></ruby>
    pattern = re.compile(r'<ruby>([^<]+)<rt>([^<]+)</rt></ruby>')
    
    results = []
    for match in pattern.finditer(content):
        text = match.group(1)  # 漢字句子
        ruby = match.group(2)  # 全句拼音
        
        # 計算漢字數量
        kanji_pattern = re.compile(r'[\u4e00-\u9faf\u3400-\u4dbf]')
        kanji_matches = list(kanji_pattern.finditer(text))
        kanji_count = len(kanji_matches)
        
        if kanji_count > 1:
            # 需要拆分
            results.append({
                'file': filepath,
                'text': text,
                'ruby': ruby,
                'kanji_count': kanji_count,
                'start': match.start(),
                'end': match.end(),
                'line': content.count('\n', 0, match.start()) + 1
            })
    
    return results

def main():
    # 日文學習內容目錄
    japanese_dir = Path('src/content/posts/japanese-learning')
    
    if not japanese_dir.exists():
        print(f"錯誤: 目錄不存在 {japanese_dir}")
        return
    
    # 找到所有 Markdown 檔案
    md_files = list(japanese_dir.rglob('*.md'))
    
    print(f"掃描 {len(md_files)} 個 Markdown 檔案...\n")
    
    all_results = []
    for filepath in md_files:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        results = find_ruby_to_fix(content, filepath)
        all_results.extend(results)
    
    # 輸出報告
    if not all_results:
        print("✅ 沒有找到需要修正的ruby標註")
        return
    
    print(f"📋 找到 {len(all_results)} 個需要修正的ruby標註：\n")
    
    # 按檔案分組
    files_dict = {}
    for result in all_results:
        file_key = str(result['file'].relative_to('.'))
        if file_key not in files_dict:
            files_dict[file_key] = []
        files_dict[file_key].append(result)
    
    # 輸出每個檔案的結果
    for filepath, results in files_dict.items():
        print(f"📄 {filepath}")
        for i, result in enumerate(results, 1):
            print(f"  {i}. 第{result['line']}行: {result['text']}")
            print(f"     拼音: {result['ruby']}")
            print(f"     漢字數: {result['kanji_count']}")
            
            # 建議的拆分方式（簡單示範）
            kanji_pattern = re.compile(r'([\u4e00-\u9faf\u3400-\u4dbf])')
            kanji_chars = kanji_pattern.findall(result['text'])
            
            print(f"     建議拆分: ", end='')
            for kanji in kanji_chars:
                print(f"<ruby>{kanji}<rt>?</rt></ruby>", end='')
            print()
            print()
    
    # 輸出統計
    total_kanji = sum(r['kanji_count'] for r in all_results)
    print(f"📊 統計:")
    print(f"  需要修正的句子: {len(all_results)}")
    print(f"  總漢字數量: {total_kanji}")
    print(f"  涉及檔案: {len(files_dict)}")
    
    # 生成修復指南
    print(f"\n🔧 修復指南:")
    print(f"  1. 對於每個標記的句子，需要手動拆分漢字和假名")
    print(f"  2. 使用日文字典確認每個漢字的正確讀音")
    print(f"  3. 將 <ruby>整句<rt>全拼音</rt></ruby> 改為 <ruby>漢<rt>かん</rt></ruby>字<ruby>部<rt>ぶ</rt></ruby>分")
    print(f"  4. 非漢字部分（平假名、片假名）不需要ruby標註")
    
    # 輸出範例
    print(f"\n🎯 修復範例:")
    print(f"  原句: <ruby>昨夜、楽しい夢を見た<rt>さくや、たのしいゆめをみた</rt></ruby>")
    print(f"  修復後: <ruby>昨<rt>さく</rt></ruby>夜、<ruby>楽<rt>たの</rt></ruby>しい<ruby>夢<rt>ゆめ</rt></ruby>を<ruby>見<rt>み</rt></ruby>た")

if __name__ == '__main__':
    main()