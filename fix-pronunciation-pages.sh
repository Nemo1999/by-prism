#!/bin/bash

# 修復發音功能頁面腳本
# 移除無效的script和link標籤，更新連結

set -e

PROJECT_DIR="/home/nemo/.openclaw/workspace/blog-by-prism"
CONTENT_DIR="$PROJECT_DIR/src/content/posts/japanese-learning"

echo "開始修復發音功能頁面..."

# 1. 移除所有頁面中的無效script和link標籤
echo "移除無效的script和link標籤..."
find "$CONTENT_DIR" -name "*.md" -type f | while read file; do
    if grep -q "pronunciation.js\|pronunciation.css" "$file"; then
        echo "  修復: $(basename "$file")"
        
        # 移除script和link標籤
        sed -i '/<script.*pronunciation.js.*>/d' "$file"
        sed -i '/<link.*pronunciation.css.*>/d' "$file"
        sed -i '/<!-- 發音功能腳本和樣式 -->/d' "$file"
    fi
done

# 2. 更新發音功能演示連結
echo "更新發音功能演示連結..."
find "$CONTENT_DIR" -name "*.md" -type f | while read file; do
    if grep -q "speech-api-demo" "$file"; then
        echo "  更新連結: $(basename "$file")"
        sed -i 's|speech-api-demo|pronunciation-demo|g' "$file"
    fi
done

# 3. 為重要頁面添加發音功能演示連結
echo "為重要頁面添加發音功能演示連結..."
IMPORTANT_FILES=(
    "vocabulary/yume.md"
    "lyrics/lemon-full-lyrics.md"
    "lyrics/lemon-yume-naraba.md"
    "lemon-song/index.md"
    "tech-research/pronunciation-integration-guide.md"
)

for file in "${IMPORTANT_FILES[@]}"; do
    full_path="$CONTENT_DIR/$file"
    if [ -f "$full_path" ]; then
        echo "  更新: $file"
        
        # 檢查是否已經有發音功能演示連結
        if ! grep -q "pronunciation-demo" "$full_path"; then
            # 在相關內容部分添加連結
            if grep -q "## 🔗 相關內容" "$full_path"; then
                sed -i '/## 🔗 相關內容/a\
- [[posts/japanese-learning/tech-research/pronunciation-demo|發音功能演示]] — 測試發音功能' "$full_path"
            fi
        fi
    fi
done

# 4. 重新建置測試
echo "重新建置測試..."
cd "$PROJECT_DIR"
if npm run build 2>&1 | grep -q "error"; then
    echo "建置失敗，請檢查錯誤訊息"
    exit 1
else
    echo "建置成功"
fi

# 5. 檢查生成的HTML中是否有發音按鈕
echo "檢查生成的HTML..."
HTML_FILES=(
    "dist/posts/japanese-learning/tech-research/pronunciation-demo/index.html"
    "dist/posts/japanese-learning/vocabulary/yume/index.html"
)

for html_file in "${HTML_FILES[@]}"; do
    if [ -f "$html_file" ]; then
        echo "  檢查: $html_file"
        
        # 檢查是否有發音按鈕
        if grep -q "pronunciation-play-btn" "$html_file"; then
            echo "    ✅ 包含發音按鈕"
        else
            echo "    ❌ 缺少發音按鈕"
        fi
        
        # 檢查是否有發音功能JavaScript
        if grep -q "PronunciationManager" "$html_file"; then
            echo "    ✅ 包含發音功能JavaScript"
        else
            echo "    ❌ 缺少發音功能JavaScript"
        fi
        
        # 檢查是否有發音功能CSS
        if grep -q "pronunciation-play-btn.*{" "$html_file"; then
            echo "    ✅ 包含發音功能CSS"
        else
            echo "    ❌ 缺少發音功能CSS"
        fi
    else
        echo "    ⚠️ 檔案不存在: $html_file"
    fi
done

echo "修復完成！"
echo ""
echo "已完成的修復："
echo "1. 移除所有頁面中的無效script和link標籤"
echo "2. 更新發音功能演示連結"
echo "3. 為重要頁面添加發音功能演示連結"
echo "4. 重新建置並測試"
echo ""
echo "下一步："
echo "1. 在瀏覽器中測試發音功能演示頁面"
echo "2. 測試yume頁面的發音按鈕"
echo "3. 為更多頁面手動添加發音按鈕"