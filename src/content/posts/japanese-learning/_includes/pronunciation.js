// 日文發音功能 - 核心函數庫
// 版本: 1.0.0
// 作者: 小波
// 描述: 為日文學習頁面提供發音播放功能

// 發音管理器
const PronunciationManager = {
  // 配置
  config: {
    defaultSpeed: 1.0,
    minSpeed: 0.5,
    maxSpeed: 2.0,
    voiceLang: 'ja-JP',
    debug: false
  },
  
  // 狀態
  state: {
    isPlaying: false,
    currentSpeed: 1.0,
    isSupported: false,
    voices: []
  },
  
  // 初始化
  init() {
    this.log('初始化發音管理器');
    
    // 檢查瀏覽器支援
    this.state.isSupported = 'speechSynthesis' in window;
    
    if (!this.state.isSupported) {
      this.log('瀏覽器不支援語音合成');
      this.showUnsupportedWarning();
      return false;
    }
    
    // 加載語音列表
    this.loadVoices();
    
    // 設定預設語速
    this.state.currentSpeed = this.config.defaultSpeed;
    
    // 綁定事件
    this.bindEvents();
    
    this.log('發音管理器初始化完成');
    return true;
  },
  
  // 加載語音列表
  loadVoices() {
    if (!this.state.isSupported) return;
    
    // 等待語音列表加載
    speechSynthesis.onvoiceschanged = () => {
      this.state.voices = speechSynthesis.getVoices();
      this.log(`加載了 ${this.state.voices.length} 種語音`);
      this.log(`日文語音: ${this.state.voices.filter(v => v.lang.startsWith('ja')).length} 種`);
    };
    
    // 立即檢查（可能已經加載）
    const voices = speechSynthesis.getVoices();
    if (voices.length > 0) {
      this.state.voices = voices;
      this.log(`立即加載了 ${voices.length} 種語音`);
    }
  },
  
  // 播放語音
  play(text, options = {}) {
    if (!this.state.isSupported) {
      this.log('無法播放：瀏覽器不支援');
      return false;
    }
    
    // 停止當前播放
    this.stop();
    
    // 創建語音實例
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = this.config.voiceLang;
    utterance.rate = options.speed || this.state.currentSpeed;
    
    // 選擇日文語音
    const japaneseVoice = this.state.voices.find(v => v.lang.startsWith('ja'));
    if (japaneseVoice) {
      utterance.voice = japaneseVoice;
      this.log(`使用語音: ${japaneseVoice.name}`);
    }
    
    // 事件處理
    utterance.onstart = () => {
      this.state.isPlaying = true;
      this.log(`開始播放: "${text}"`);
      this.updatePlayButtonStates();
    };
    
    utterance.onend = () => {
      this.state.isPlaying = false;
      this.log(`播放完成: "${text}"`);
      this.updatePlayButtonStates();
    };
    
    utterance.onerror = (event) => {
      this.state.isPlaying = false;
      this.log(`播放錯誤: ${event.error}`, 'error');
      this.updatePlayButtonStates();
      this.showError('播放失敗，請檢查瀏覽器設定或嘗試其他瀏覽器');
    };
    
    // 開始播放
    speechSynthesis.speak(utterance);
    return true;
  },
  
  // 停止播放
  stop() {
    if (this.state.isSupported && speechSynthesis.speaking) {
      speechSynthesis.cancel();
      this.state.isPlaying = false;
      this.log('停止播放');
      this.updatePlayButtonStates();
    }
  },
  
  // 設定語速
  setSpeed(speed) {
    if (speed < this.config.minSpeed || speed > this.config.maxSpeed) {
      this.log(`語速 ${speed} 超出範圍 [${this.config.minSpeed}, ${this.config.maxSpeed}]`, 'warn');
      return false;
    }
    
    this.state.currentSpeed = speed;
    this.log(`設定語速: ${speed}x`);
    
    // 更新UI中的活動按鈕
    document.querySelectorAll('.pronunciation-speed-btn').forEach(btn => {
      const btnSpeed = parseFloat(btn.dataset.speed);
      btn.classList.toggle('active', Math.abs(btnSpeed - speed) < 0.01);
    });
    
    return true;
  },
  
  // 綁定事件
  bindEvents() {
    // 綁定播放按鈕
    document.addEventListener('click', (e) => {
      const playBtn = e.target.closest('.pronunciation-play-btn');
      if (playBtn) {
        e.preventDefault();
        const text = playBtn.dataset.text;
        if (text) {
          this.play(text);
        }
      }
      
      // 綁定語速按鈕
      const speedBtn = e.target.closest('.pronunciation-speed-btn');
      if (speedBtn) {
        e.preventDefault();
        const speed = parseFloat(speedBtn.dataset.speed);
        this.setSpeed(speed);
      }
      
      // 綁定停止按鈕
      const stopBtn = e.target.closest('.pronunciation-stop-btn');
      if (stopBtn) {
        e.preventDefault();
        this.stop();
      }
    });
    
    // 頁面卸載時停止播放
    window.addEventListener('beforeunload', () => {
      this.stop();
    });
  },
  
  // 更新播放按鈕狀態
  updatePlayButtonStates() {
    document.querySelectorAll('.pronunciation-play-btn').forEach(btn => {
      if (this.state.isPlaying) {
        btn.classList.add('playing');
        btn.innerHTML = '⏹️ 停止';
      } else {
        btn.classList.remove('playing');
        btn.innerHTML = '🔊 播放';
      }
    });
  },
  
  // 顯示不支援警告
  showUnsupportedWarning() {
    // 可以選擇性地顯示警告
    if (this.config.debug) {
      console.warn('您的瀏覽器不支援Web Speech API。建議使用Chrome、Edge、Safari或Firefox最新版本。');
    }
  },
  
  // 顯示錯誤訊息
  showError(message) {
    // 可以選擇性地顯示錯誤訊息
    if (this.config.debug) {
      console.error(message);
    }
  },
  
  // 日誌記錄
  log(message, level = 'info') {
    if (!this.config.debug) return;
    
    const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
    const prefix = `[${timestamp}] PronunciationManager:`;
    
    switch (level) {
      case 'error':
        console.error(`${prefix} ${message}`);
        break;
      case 'warn':
        console.warn(`${prefix} ${message}`);
        break;
      default:
        console.log(`${prefix} ${message}`);
    }
  },
  
  // 公開API
  api: {
    // 播放單字
    playWord(kana) {
      return PronunciationManager.play(kana);
    },
    
    // 播放句子
    playSentence(text) {
      return PronunciationManager.play(text);
    },
    
    // 停止播放
    stopPlayback() {
      PronunciationManager.stop();
    },
    
    // 設定語速
    setPlaybackSpeed(speed) {
      return PronunciationManager.setSpeed(speed);
    },
    
    // 檢查支援
    isSupported() {
      return PronunciationManager.state.isSupported;
    },
    
    // 取得狀態
    getStatus() {
      return {
        isPlaying: PronunciationManager.state.isPlaying,
        currentSpeed: PronunciationManager.state.currentSpeed,
        isSupported: PronunciationManager.state.isSupported,
        voicesCount: PronunciationManager.state.voices.length
      };
    }
  }
};

// 簡化函數（兼容舊版）
function speakJapanese(text, speed) {
  return PronunciationManager.play(text, { speed: speed || PronunciationManager.state.currentSpeed });
}

// 頁面加載完成後初始化
document.addEventListener('DOMContentLoaded', () => {
  PronunciationManager.init();
  
  // 全局暴露
  window.PronunciationManager = PronunciationManager.api;
  window.speakJapanese = speakJapanese;
  
  // 自動為帶有特定類名的元素添加播放功能
  setTimeout(() => {
    document.querySelectorAll('.auto-pronounce').forEach(el => {
      if (!el.dataset.text && el.textContent.trim()) {
        el.dataset.text = el.textContent.trim();
      }
      if (!el.classList.contains('pronunciation-play-btn')) {
        el.classList.add('pronunciation-play-btn');
      }
    });
  }, 100);
});

// 導出（如果使用模組系統）
if (typeof module !== 'undefined' && module.exports) {
  module.exports = PronunciationManager;
}