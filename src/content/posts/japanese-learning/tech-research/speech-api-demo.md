---
title: "日文發音功能演示"
description: "使用Web Speech API實現日文單字和例句發音播放的技術演示"
pubDate: 2026-03-22
author: 小波
tags: ["技術演示", "發音功能", "Web Speech API", "日文學習"]
draft: true
---

# 日文發音功能演示

> 使用瀏覽器原生語音合成技術實現日文發音播放

## 🎯 演示說明

這個頁面展示如何使用Web Speech API為日文單字和例句添加發音播放功能。所有功能都在瀏覽器中運行，無需伺服器端處理。

## 🔧 技術基礎

### 支援的瀏覽器
- ✅ Chrome 33+
- ✅ Edge 14+
- ✅ Safari 7+
- ✅ Firefox 49+
- ❌ Internet Explorer

### 功能限制
- 發音品質取決於瀏覽器和作業系統
- 日文支援可能有限
- 語調和情感表達較機械

## 🎵 發音演示

### 單字發音測試

#### 基本單字
<button class="pronounce-btn" data-text="夢" data-kana="ゆめ">播放：<ruby>夢<rt>ゆめ</rt></ruby></button>
<button class="pronounce-btn" data-text="あなた" data-kana="あなた">播放：<ruby>あなた<rt>あなた</rt></ruby></button>
<button class="pronounce-btn" data-text="幸せ" data-kana="しあわせ">播放：<ruby>幸せ<rt>しあわせ</rt></ruby></button>

#### 《Lemon》相關單字
<button class="pronounce-btn" data-text="レモン" data-kana="れもん">播放：<ruby>レモン<rt>れもん</rt></ruby></button>
<button class="pronounce-btn" data-text="思い出" data-kana="おもいで">播放：<ruby>思い出<rt>おもいで</rt></ruby></button>
<button class="pronounce-btn" data-text="悲しみ" data-kana="かなしみ">播放：<ruby>悲しみ<rt>かなしみ</rt></ruby></button>

### 例句朗讀測試

#### 基本例句
<button class="pronounce-btn" data-text="こんにちは、元気ですか？">播放：こんにちは、元気ですか？</button>
<button class="pronounce-btn" data-text="私は日本語を勉強しています">播放：私は日本語を勉強しています</button>

#### 《Lemon》歌詞例句
<button class="pronounce-btn" data-text="夢ならばどれほどよかったでしょう">播放：夢ならばどれほどよかったでしょう</button>
<button class="pronounce-btn" data-text="未だにあなたのことを夢にみる">播放：未だにあなたのことを夢にみる</button>
<button class="pronounce-btn" data-text="忘れた物を取りに帰るように">播放：忘れた物を取りに帰るように</button>

## ⚙️ 控制面板

### 語速調整
<div class="control-panel">
  <label>語速：</label>
  <button class="speed-btn" data-speed="0.5">慢速 (0.5x)</button>
  <button class="speed-btn" data-speed="0.8">稍慢 (0.8x)</button>
  <button class="speed-btn" data-speed="1.0" disabled>常速 (1.0x)</button>
  <button class="speed-btn" data-speed="1.2">稍快 (1.2x)</button>
  <button class="speed-btn" data-speed="1.5">快速 (1.5x)</button>
</div>

### 播放控制
<div class="control-panel">
  <button id="pause-btn">暫停</button>
  <button id="resume-btn">繼續</button>
  <button id="stop-btn">停止</button>
</div>

## 📊 瀏覽器支援檢測

<div id="browser-support">
  <p>正在檢測瀏覽器支援...</p>
</div>

## 💡 使用方式

### 在現有頁面中添加發音功能

#### 單字卡片範例
```html
<!-- 單字卡片模板 -->
<div class="vocabulary-card">
  <h2><ruby>夢<rt>ゆめ</rt></ruby></h2>
  <button onclick="speakJapanese('ゆめ')" class="pronounce-btn">
    🔊 播放發音
  </button>
  <p>意思：夢、夢想</p>
</div>
```

#### 例句範例
```html
<!-- 例句模板 -->
<div class="example-sentence">
  <p><ruby>夢ならばどれほどよかったでしょう<rt>ゆめならばどれほどよかったでしょう</rt></ruby></p>
  <button onclick="speakJapanese('夢ならばどれほどよかったでしょう')" class="pronounce-btn">
    🔊 朗讀例句
  </button>
  <p>翻譯：如果是夢該有多好</p>
</div>
```

## 🚀 整合建議

### 漸進增強策略
1. **基礎功能**：所有單字和例句添加播放按鈕
2. **瀏覽器檢測**：不支援時隱藏按鈕或顯示替代方案
3. **使用者回饋**：提供視覺回饋（播放中、完成）
4. **錯誤處理**：優雅的錯誤訊息

### 效能優化
1. **預加載語音**：常用單字預先初始化
2. **隊列管理**：避免同時播放多個語音
3. **記憶體管理**：及時清理語音物件
4. **離線支援**：考慮預錄音頻作為備用

## 🔗 相關內容
- [[posts/japanese-learning/tech-research/pronunciation-feature-test|發音功能技術研究]]
- [[posts/japanese-learning/vocabulary/yume|夢 - 單字卡片]]
- [[posts/japanese-learning/lyrics/lemon-yume-naraba|Lemon歌詞解析]]

## 📝 技術實現程式碼

```javascript
// 日文語音播放函數
function speakJapanese(text, speed = 1.0) {
  if (!('speechSynthesis' in window)) {
    console.warn('瀏覽器不支援語音合成');
    return false;
  }
  
  // 停止當前播放
  speechSynthesis.cancel();
  
  // 創建語音實例
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = 'ja-JP';
  utterance.rate = speed;
  
  // 事件處理
  utterance.onstart = () => {
    console.log('開始播放:', text);
  };
  
  utterance.onend = () => {
    console.log('播放完成:', text);
  };
  
  utterance.onerror = (event) => {
    console.error('播放錯誤:', event);
  };
  
  // 開始播放
  speechSynthesis.speak(utterance);
  return true;
}

// 控制函數
function pauseSpeech() {
  speechSynthesis.pause();
}

function resumeSpeech() {
  speechSynthesis.resume();
}

function stopSpeech() {
  speechSynthesis.cancel();
}
```

<style>
.pronounce-btn {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 8px 16px;
  margin: 4px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.pronounce-btn:hover {
  background-color: #45a049;
}

.control-panel {
  margin: 20px 0;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 6px;
}

.speed-btn {
  background-color: #2196F3;
  color: white;
  border: none;
  padding: 6px 12px;
  margin: 2px;
  border-radius: 3px;
  cursor: pointer;
}

.speed-btn:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.speed-btn:hover:not(:disabled) {
  background-color: #0b7dda;
}
</style>

<script>
// 檢測瀏覽器支援
function checkBrowserSupport() {
  const supportDiv = document.getElementById('browser-support');
  const hasSupport = 'speechSynthesis' in window;
  
  if (hasSupport) {
    supportDiv.innerHTML = `
      <p style="color: green;">✅ 您的瀏覽器支援Web Speech API</p>
      <p>可用語音：${speechSynthesis.getVoices().length} 種</p>
      <p>日文語音：${speechSynthesis.getVoices().filter(v => v.lang.startsWith('ja')).length} 種</p>
    `;
  } else {
    supportDiv.innerHTML = `
      <p style="color: red;">❌ 您的瀏覽器不支援Web Speech API</p>
      <p>建議使用Chrome、Edge、Safari或Firefox最新版本</p>
    `;
  }
}

// 初始化語音
function initSpeech() {
  // 等待語音列表加載
  speechSynthesis.onvoiceschanged = () => {
    checkBrowserSupport();
  };
  
  // 如果語音已經加載
  if (speechSynthesis.getVoices().length > 0) {
    checkBrowserSupport();
  }
}

// 日文語音播放函數
function speakJapanese(text, speed = 1.0) {
  if (!('speechSynthesis' in window)) {
    alert('您的瀏覽器不支援語音合成功能');
    return false;
  }
  
  // 停止當前播放
  speechSynthesis.cancel();
  
  // 創建語音實例
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = 'ja-JP';
  utterance.rate = speed;
  
  // 選擇日文語音（如果可用）
  const voices = speechSynthesis.getVoices();
  const japaneseVoice = voices.find(voice => voice.lang.startsWith('ja'));
  if (japaneseVoice) {
    utterance.voice = japaneseVoice;
  }
  
  // 事件處理
  utterance.onstart = () => {
    console.log('開始播放:', text);
  };
  
  utterance.onend = () => {
    console.log('播放完成:', text);
  };
  
  utterance.onerror = (event) => {
    console.error('播放錯誤:', event);
    alert('播放失敗，請檢查瀏覽器設定或嘗試其他瀏覽器');
  };
  
  // 開始播放
  speechSynthesis.speak(utterance);
  return true;
}

// 控制函數
function pauseSpeech() {
  if ('speechSynthesis' in window) {
    speechSynthesis.pause();
  }
}

function resumeSpeech() {
  if ('speechSynthesis' in window) {
    speechSynthesis.resume();
  }
}

function stopSpeech() {
  if ('speechSynthesis' in window) {
    speechSynthesis.cancel();
  }
}

// 頁面加載完成後初始化
document.addEventListener('DOMContentLoaded', function() {
  // 初始化語音
  initSpeech();
  
  // 綁定發音按鈕
  document.querySelectorAll('.pronounce-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const text = this.getAttribute('data-text');
      speakJapanese(text);
    });
  });
  
  // 綁定語速按鈕
  document.querySelectorAll('.speed-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const speed = parseFloat(this.getAttribute('data-speed'));
      // 更新所有按鈕狀態
      document.querySelectorAll('.speed-btn').forEach(b => {
        b.disabled = false;
      });
      this.disabled = true;
      // 這裡可以設定全域語速
      window.currentSpeechSpeed = speed;
    });
  });
  
  // 綁定控制按鈕
  document.getElementById('pause-btn')?.addEventListener('click', pauseSpeech);
  document.getElementById('resume-btn')?.addEventListener('click', resumeSpeech);
  document.getElementById('stop-btn')?.addEventListener('click', stopSpeech);
});
</script>