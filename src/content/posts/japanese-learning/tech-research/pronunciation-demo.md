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
<ruby>夢<rt>ゆめ</rt></ruby> <button class="pronunciation-play-btn" data-text="ゆめ">🔊 播放</button><br>
<ruby>あなた<rt>あなた</rt></ruby> <button class="pronunciation-play-btn" data-text="あなた">🔊 播放</button><br>
<ruby>幸せ<rt>しあわせ</rt></ruby> <button class="pronunciation-play-btn" data-text="しあわせ">🔊 播放</button>

### 《Lemon》相關單字
<ruby>レモン<rt>れもん</rt></ruby> <button class="pronunciation-play-btn" data-text="れもん">🔊 播放</button><br>
<ruby>思い出<rt>おもいで</rt></ruby> <button class="pronunciation-play-btn" data-text="おもいで">🔊 播放</button><br>
<ruby>悲しみ<rt>かなしみ</rt></ruby> <button class="pronunciation-play-btn" data-text="かなしみ">🔊 播放</button>

### 例句朗讀
こんにちは、元気ですか？ <button class="pronunciation-play-btn" data-text="こんにちは、元気ですか？">🔊 朗讀</button><br>
私は日本語を勉強しています <button class="pronunciation-play-btn" data-text="私は日本語を勉強しています">🔊 朗讀</button>

### 《Lemon》歌詞例句
夢ならばどれほどよかったでしょう <button class="pronunciation-play-btn" data-text="夢ならばどれほどよかったでしょう">🔊 朗讀</button><br>
未だにあなたのことを夢にみる <button class="pronunciation-play-btn" data-text="未だにあなたのことを夢にみる">🔊 朗讀</button><br>
忘れた物を取りに帰るように <button class="pronunciation-play-btn" data-text="忘れた物を取りに帰るように">🔊 朗讀</button>

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

