#!/bin/bash

# 日文發音功能批量更新腳本
# 為所有日文學習頁面添加發音播放功能

set -e

PROJECT_DIR="/home/nemo/.openclaw/workspace/blog-by-prism"
CONTENT_DIR="$PROJECT_DIR/src/content/posts/japanese-learning"

echo "開始更新日文學習頁面的發音功能..."

# 1. 檢查必要的檔案是否存在
echo "檢查必要檔案..."
if [ ! -f "$CONTENT_DIR/_includes/pronunciation.js" ]; then
    echo "錯誤: pronunciation.js 不存在"
    exit 1
fi

if [ ! -f "$CONTENT_DIR/_includes/pronunciation.css" ]; then
    echo "錯誤: pronunciation.css 不存在"
    exit 1
fi

# 2. 更新單字頁面
echo "更新單字頁面..."
find "$CONTENT_DIR/vocabulary" -name "*.md" -type f | while read file; do
    if grep -q "draft: false" "$file"; then
        echo "  更新: $(basename "$file")"
        
        # 檢查是否已經有發音功能
        if ! grep -q "pronunciation-play-btn" "$file"; then
            # 在檔案末尾添加發音功能
            echo "" >> "$file"
            echo "<!-- 發音功能腳本和樣式 -->" >> "$file"
            echo "<script src=\"/posts/japanese-learning/_includes/pronunciation.js\"></script>" >> "$file"
            echo "<link rel=\"stylesheet\" href=\"/posts/japanese-learning/_includes/pronunciation.css\">" >> "$file"
        fi
    fi
done

# 3. 更新歌詞頁面
echo "更新歌詞頁面..."
find "$CONTENT_DIR/lyrics" -name "*.md" -type f | while read file; do
    if grep -q "draft: false" "$file"; then
        echo "  更新: $(basename "$file")"
        
        # 檢查是否已經有發音功能
        if ! grep -q "pronunciation-play-btn" "$file"; then
            # 在檔案末尾添加發音功能
            echo "" >> "$file"
            echo "<!-- 發音功能腳本和樣式 -->" >> "$file"
            echo "<script src=\"/posts/japanese-learning/_includes/pronunciation.js\"></script>" >> "$file"
            echo "<link rel=\"stylesheet\" href=\"/posts/japanese-learning/_includes/pronunciation.css\">" >> "$file"
        fi
    fi
done

# 4. 更新文法頁面
echo "更新文法頁面..."
find "$CONTENT_DIR/grammar" -name "*.md" -type f | while read file; do
    if grep -q "draft: false" "$file"; then
        echo "  更新: $(basename "$file")"
        
        # 檢查是否已經有發音功能
        if ! grep -q "pronunciation-play-btn" "$file"; then
            # 在檔案末尾添加發音功能
            echo "" >> "$file"
            echo "<!-- 發音功能腳本和樣式 -->" >> "$file"
            echo "<script src=\"/posts/japanese-learning/_includes/pronunciation.js\"></script>" >> "$file"
            echo "<link rel=\"stylesheet\" href=\"/posts/japanese-learning/_includes/pronunciation.css\">" >> "$file"
        fi
    fi
done

# 5. 更新Lemon專案頁面
echo "更新Lemon專案頁面..."
find "$CONTENT_DIR/lemon-song" -name "*.md" -type f | while read file; do
    if grep -q "draft: false" "$file"; then
        echo "  更新: $(basename "$file")"
        
        # 檢查是否已經有發音功能
        if ! grep -q "pronunciation-play-btn" "$file"; then
            # 在檔案末尾添加發音功能
            echo "" >> "$file"
            echo "<!-- 發音功能腳本和樣式 -->" >> "$file"
            echo "<script src=\"/posts/japanese-learning/_includes/pronunciation.js\"></script>" >> "$file"
            echo "<link rel=\"stylesheet\" href=\"/posts/japanese-learning/_includes/pronunciation.css\">" >> "$file"
        fi
    fi
done

# 6. 更新標籤
echo "更新頁面標籤..."
find "$CONTENT_DIR" -name "*.md" -type f | while read file; do
    if grep -q "draft: false" "$file" && ! grep -q "發音功能" "$file"; then
        # 在tags中添加"發音功能"
        if grep -q "tags:" "$file"; then
            sed -i '/tags:/s/\]/, "發音功能"]/' "$file"
        fi
    fi
done

# 7. 建立發音功能演示頁面（非草稿）
echo "建立發音功能演示頁面..."
DEMO_FILE="$CONTENT_DIR/tech-research/pronunciation-demo.md"
if [ ! -f "$DEMO_FILE" ]; then
    cat > "$DEMO_FILE" << 'EOF'
---
title: "日文發音功能演示"
description: "日文單字和例句發音播放功能演示"
pubDate: 2026-03-22
author: 小波
tags: ["技術演示", "發音功能", "Web Speech API", "日文學習"]
draft: false
---

# 日文發音功能演示

> 使用瀏覽器原生語音合成技術實現日文發音播放

## 🎯 功能說明

這個頁面展示如何為日文單字和例句添加發音播放功能。所有功能都在瀏覽器中運行，無需伺服器端處理。

## 🎵 發音演示

### 基本單字
<button class="pronunciation-play-btn" data-text="夢">播放：<ruby>夢<rt>ゆめ</rt></ruby></button>
<button class="pronunciation-play-btn" data-text="あなた">播放：<ruby>あなた<rt>あなた</rt></ruby></button>
<button class="pronunciation-play-btn" data-text="幸せ">播放：<ruby>幸せ<rt>しあわせ</rt></ruby></button>

### 《Lemon》相關單字
<button class="pronunciation-play-btn" data-text="レモン">播放：<ruby>レモン<rt>れもん</rt></ruby></button>
<button class="pronunciation-play-btn" data-text="思い出">播放：<ruby>思い出<rt>おもいで</rt></ruby></button>
<button class="pronunciation-play-btn" data-text="悲しみ">播放：<ruby>悲しみ<rt>かなしみ</rt></ruby></button>

### 例句朗讀
<button class="pronunciation-play-btn" data-text="こんにちは、元気ですか？">播放：こんにちは、元気ですか？</button>
<button class="pronunciation-play-btn" data-text="私は日本語を勉強しています">播放：私は日本語を勉強しています</button>

### 《Lemon》歌詞例句
<button class="pronunciation-play-btn" data-text="夢ならばどれほどよかったでしょう">播放：夢ならばどれほどよかったでしょう</button>
<button class="pronunciation-play-btn" data-text="未だにあなたのことを夢にみる">播放：未だにあなたのことを夢にみる</button>
<button class="pronunciation-play-btn" data-text="忘れた物を取りに帰るように">播放：忘れた物を取りに帰るように</button>

## ⚙️ 控制面板

### 語速調整
<div class="pronunciation-widget">
  <div class="controls">
    <div class="speed-controls">
      <span class="speed-label">語速：</span>
      <button class="pronunciation-speed-btn" data-speed="0.5">0.5x</button>
      <button class="pronunciation-speed-btn" data-speed="0.8">0.8x</button>
      <button class="pronunciation-speed-btn active" data-speed="1.0">1.0x</button>
      <button class="pronunciation-speed-btn" data-speed="1.2">1.2x</button>
      <button class="pronunciation-speed-btn" data-speed="1.5">1.5x</button>
    </div>
  </div>
</div>

### 播放控制
<div class="pronunciation-widget">
  <div class="controls">
    <div class="main-controls">
      <button class="pronunciation-play-btn" data-text="これはテストです">🔊 測試播放</button>
      <button class="pronunciation-stop-btn">⏹️ 停止</button>
    </div>
  </div>
</div>

## 💡 使用方式

### 在頁面中添加發音按鈕

#### 單字發音按鈕
```html
<ruby>夢<rt>ゆめ</rt></ruby>
<button class="pronunciation-play-btn" data-text="ゆめ">🔊 播放</button>
```

#### 例句朗讀按鈕
```html
<p>
  <ruby>夢ならばどれほどよかったでしょう<rt>ゆめならばどれほどよかったでしょう</rt></ruby>
  <button class="pronunciation-play-btn" data-text="夢ならばどれほどよかったでしょう">🔊 朗讀</button>
</p>
```

### 發音小部件
```html
<div class="pronunciation-widget">
  <div class="text">
    <ruby>夢<rt>ゆめ</rt></ruby>
  </div>
  <div class="controls">
    <div class="main-controls">
      <button class="pronunciation-play-btn" data-text="ゆめ">🔊 播放</button>
      <button class="pronunciation-stop-btn">⏹️ 停止</button>
    </div>
    <div class="speed-controls">
      <span class="speed-label">語速：</span>
      <button class="pronunciation-speed-btn" data-speed="0.5">0.5x</button>
      <button class="pronunciation-speed-btn" data-speed="0.8">0.8x</button>
      <button class="pronunciation-speed-btn active" data-speed="1.0">1.0x</button>
      <button class="pronunciation-speed-btn" data-speed="1.2">1.2x</button>
      <button class="pronunciation-speed-btn" data-speed="1.5">1.5x</button>
    </div>
  </div>
</div>
```

## 🔗 相關內容
- [[posts/japanese-learning/tech-research/pronunciation-integration-guide|發音功能整合指南]]
- [[posts/japanese-learning/vocabulary/yume|夢 - 單字卡片]]
- [[posts/japanese-learning/lyrics/lemon-yume-naraba|Lemon歌詞解析]]

<!-- 發音功能腳本和樣式 -->
<script src="/posts/japanese-learning/_includes/pronunciation.js"></script>
<link rel="stylesheet" href="/posts/japanese-learning/_includes/pronunciation.css">
EOF
    echo "  建立: pronunciation-demo.md"
fi

# 8. 測試建置
echo "測試建置..."
cd "$PROJECT_DIR"
if npm run build 2>&1 | grep -q "error"; then
    echo "建置失敗，請檢查錯誤訊息"
    exit 1
else
    echo "建置成功"
fi

echo "更新完成！"
echo ""
echo "已更新的內容："
echo "1. 為所有非草稿頁面添加發音功能腳本和樣式"
echo "2. 更新頁面標籤包含'發音功能'"
echo "3. 建立發音功能演示頁面 (pronunciation-demo.md)"
echo "4. 測試建置成功"
echo ""
echo "下一步："
echo "1. 手動為重要單字和例句添加播放按鈕"
echo "2. 測試發音功能在不同瀏覽器的表現"
echo "3. 收集使用者反饋進行優化"