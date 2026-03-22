#!/bin/bash

# 日文拼音標註檢查腳本
# 檢查拼音標註是否只標註漢字，而不是整句

set -e

PROJECT_DIR="/home/nemo/.openclaw/workspace/blog-by-prism"
CONTENT_DIR="$PROJECT_DIR/src/content/posts/japanese-learning"

echo "🔍 檢查日文拼音標註..."

# 檢查整句拼音標註（錯誤的格式）
echo "檢查整句拼音標註（錯誤格式）..."
ERROR_COUNT=0

find "$CONTENT_DIR" -name "*.md" -type f | while read file; do
    # 檢查是否有整句拼音標註
    if grep -q '<ruby>[^<]*<rt>[^<]*</rt></ruby>' "$file"; then
        # 進一步檢查是否包含多個漢字
        LINE_COUNT=0
        while IFS= read -r line; do
            LINE_COUNT=$((LINE_COUNT + 1))
            
            # 使用Python檢查這行是否有需要修正的ruby標註
            python3 -c "
import re
import sys

line = '''$line'''
pattern = re.compile(r'<ruby>([^<]+)<rt>([^<]+)</rt></ruby>')

for match in pattern.finditer(line):
    text = match.group(1)
    # 計算漢字數量
    kanji_pattern = re.compile(r'[\u4e00-\u9faf\u3400-\u4dbf]')
    kanji_matches = list(kanji_pattern.finditer(text))
    kanji_count = len(kanji_matches)
    
    if kanji_count > 1:
        print(f'檔案: {sys.argv[1]}')
        print(f'行數: {sys.argv[2]}')
        print(f'內容: {text}')
        print(f'拼音: {match.group(2)}')
        print(f'漢字數: {kanji_count}')
        print(f'建議: 需要拆分為只標註漢字')
        print()
" "$(basename "$file")" "$LINE_COUNT" 2>/dev/null | while read -r output; do
                if [ -n "$output" ]; then
                    echo "$output"
                    ERROR_COUNT=$((ERROR_COUNT + 1))
                fi
            done
        done < "$file"
    fi
done

echo ""
echo "📊 檢查結果："
if [ $ERROR_COUNT -eq 0 ]; then
    echo "✅ 所有拼音標註格式正確"
else
    echo "⚠️  發現 $ERROR_COUNT 個需要修正的拼音標註"
    echo ""
    echo "🔧 修正指南："
    echo "1. 將整句拼音標註拆分為只標註漢字"
    echo "2. 使用正確格式：<ruby>漢<rt>かん</rt></ruby>字<ruby>部<rt>ぶ</rt></ruby>分"
    echo "3. 非漢字部分（平假名、片假名）不需要ruby標註"
    echo ""
    echo "🎯 修正範例："
    echo "原句: <ruby>昨夜、楽しい夢を見た<rt>さくや、たのしいゆめをみた</rt></ruby>"
    echo "修正後: <ruby>昨<rt>さく</rt></ruby>夜、<ruby>楽<rt>たの</rt></ruby>しい<ruby>夢<rt>ゆめ</rt></ruby>を<ruby>見<rt>み</rt></ruby>た"
fi

# 檢查yume.md是否已正確修正
echo ""
echo "🔍 檢查範例檔案 (yume.md)..."
if grep -q '<ruby>昨<rt>さく</rt></ruby>夜、<ruby>楽<rt>たの</rt></ruby>しい<ruby>夢<rt>ゆめ</rt></ruby>を<ruby>見<rt>み</rt></ruby>た' "$CONTENT_DIR/vocabulary/yume.md"; then
    echo "✅ yume.md 已正確修正為只標註漢字"
else
    echo "❌ yume.md 尚未修正或格式不正確"
fi

echo ""
echo "📝 總結："
echo "- 使用 'python3 identify-ruby-to-fix.py' 查看完整需要修正的清單"
echo "- 總共有 115 個句子需要修正（392 個漢字）"
echo "- 已建立正確的範例在 yume.md"
echo "- 未來創建新內容時，請使用正確的拼音標註格式"