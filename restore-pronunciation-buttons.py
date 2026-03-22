#!/usr/bin/env python3
"""
恢復發音按鈕腳本
在拼音標註修正中不小心刪除了發音按鈕，需要恢復
"""

import re
import os
from pathlib import Path

def restore_pronunciation_buttons(filepath):
    """恢復檔案中的發音按鈕"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 恢復基本讀音的發音按鈕
    # 匹配：<ruby>夢<rt>ゆめ</rt></ruby>
    # 替換為：<ruby>夢<rt>ゆめ</rt></ruby> <button class="pronunciation-play-btn" data-text="ゆめ">🔊 播放</button>
    basic_pronunciation_pattern = re.compile(r'(<ruby>([^<]+)<rt>([^<]+)</rt></ruby>)(?!.*?pronunciation-play-btn)')
    
    def add_basic_button(match):
        ruby_tag = match.group(1)
        text = match.group(3)  # 假名部分
        # 檢查是否已經有按鈕
        if 'pronunciation-play-btn' not in match.group(0):
            return f'{ruby_tag} <button class="pronunciation-play-btn" data-text="{text}">🔊 播放</button>'
        return match.group(0)
    
    content = basic_pronunciation_pattern.sub(add_basic_button, content)
    
    # 恢復例句的發音按鈕
    # 匹配日文例句行（包含中文翻譯）
    japanese_sentence_pattern = re.compile(r'([^<]*<ruby>[^<]+</ruby>[^<]*—[^<]*)(\n|$)')
    
    # 這部分比較複雜，需要根據具體檔案手動處理
    # 暫時先標記需要手動恢復的句子
    
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    
    return False

def main():
    # 受影響的檔案列表
    affected_files = [
        "src/content/posts/japanese-learning/vocabulary/yume.md",
        "src/content/posts/japanese-learning/lyrics/lemon-full-lyrics.md",
        "src/content/posts/japanese-learning/lyrics/lemon-yume-naraba.md",
        "src/content/posts/japanese-learning/grammar/hypothetical-expression.md",
        "src/content/posts/japanese-learning/lemon-song/vocabulary-grammar-review.md"
    ]
    
    print("🔧 恢復發音按鈕...")
    
    restored_count = 0
    for filepath in affected_files:
        if Path(filepath).exists():
            if restore_pronunciation_buttons(filepath):
                print(f"✅ 已恢復: {filepath}")
                restored_count += 1
            else:
                print(f"⚠️  無需恢復: {filepath} (可能已正確或需要手動處理)")
        else:
            print(f"❌ 檔案不存在: {filepath}")
    
    print(f"\n📊 總結: 恢復了 {restored_count} 個檔案")
    
    if restored_count > 0:
        print("\n🔍 注意: 這個腳本只恢復基本的發音按鈕")
        print("對於複雜的句子和發音練習區塊，需要手動恢復")
        print("\n🎯 需要手動檢查的項目:")
        print("1. lemon-full-lyrics.md 中的歌詞發音按鈕")
        print("2. 發音練習區塊 (pronunciation-widget)")
        print("3. 相關連結到發音功能演示")
        
        print("\n📝 手動恢復指南:")
        print("1. 使用 git show 76f967b:檔案路徑 查看原始內容")
        print("2. 比較當前內容和原始內容")
        print("3. 恢復被刪除的發音按鈕和功能區塊")

if __name__ == '__main__':
    main()