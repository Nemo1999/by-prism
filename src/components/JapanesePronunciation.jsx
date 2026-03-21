// JapanesePronunciation.jsx
// 日文發音播放組件

import { useState, useEffect } from 'react';

/**
 * 日文發音播放組件
 * @param {Object} props
 * @param {string} props.text - 要播放的日文文本
 * @param {string} props.kana - 假名標註（可選）
 * @param {string} props.label - 按鈕標籤（可選）
 * @param {number} props.speed - 播放速度（0.5-2.0，預設1.0）
 * @param {boolean} props.showKana - 是否顯示假名標註
 */
export default function JapanesePronunciation({
  text,
  kana,
  label = '🔊 播放',
  speed = 1.0,
  showKana = true,
}) {
  const [isSupported, setIsSupported] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentSpeed, setCurrentSpeed] = useState(speed);

  // 檢測瀏覽器支援
  useEffect(() => {
    const hasSpeechSynthesis = 'speechSynthesis' in window;
    setIsSupported(hasSpeechSynthesis);
    
    if (hasSpeechSynthesis) {
      // 預加載語音
      speechSynthesis.getVoices();
    }
  }, []);

  // 播放日文語音
  const playJapanese = () => {
    if (!isSupported) {
      alert('您的瀏覽器不支援語音合成功能。請使用 Chrome、Edge、Safari 或 Firefox 最新版本。');
      return;
    }

    // 停止當前播放
    speechSynthesis.cancel();

    // 創建語音實例
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'ja-JP';
    utterance.rate = currentSpeed;

    // 選擇日文語音（如果可用）
    const voices = speechSynthesis.getVoices();
    const japaneseVoice = voices.find(voice => voice.lang.startsWith('ja'));
    if (japaneseVoice) {
      utterance.voice = japaneseVoice;
    }

    // 播放狀態管理
    utterance.onstart = () => {
      setIsPlaying(true);
    };

    utterance.onend = () => {
      setIsPlaying(false);
    };

    utterance.onerror = () => {
      setIsPlaying(false);
      alert('播放失敗，請檢查瀏覽器設定或嘗試其他瀏覽器。');
    };

    // 開始播放
    speechSynthesis.speak(utterance);
  };

  // 停止播放
  const stopPlaying = () => {
    if (isSupported) {
      speechSynthesis.cancel();
      setIsPlaying(false);
    }
  };

  // 調整語速
  const changeSpeed = (newSpeed) => {
    setCurrentSpeed(newSpeed);
    if (isPlaying) {
      stopPlaying();
      setTimeout(() => playJapanese(), 100);
    }
  };

  if (!isSupported) {
    return null; // 不支援時不顯示
  }

  return (
    <div className="japanese-pronunciation">
      {/* 文本顯示 */}
      <div className="pronunciation-text">
        {showKana && kana ? (
          <ruby>
            {text}
            <rt>{kana}</rt>
          </ruby>
        ) : (
          <span>{text}</span>
        )}
      </div>

      {/* 控制面板 */}
      <div className="pronunciation-controls">
        {/* 播放/停止按鈕 */}
        <button
          onClick={isPlaying ? stopPlaying : playJapanese}
          className={`play-button ${isPlaying ? 'playing' : ''}`}
          aria-label={isPlaying ? '停止播放' : '播放發音'}
        >
          {isPlaying ? '⏹️ 停止' : '🔊 播放'}
        </button>

        {/* 語速控制 */}
        <div className="speed-control">
          <span className="speed-label">語速：</span>
          {[0.5, 0.8, 1.0, 1.2, 1.5].map((speedOption) => (
            <button
              key={speedOption}
              onClick={() => changeSpeed(speedOption)}
              className={`speed-button ${currentSpeed === speedOption ? 'active' : ''}`}
              aria-label={`語速 ${speedOption}x`}
            >
              {speedOption}x
            </button>
          ))}
        </div>
      </div>

      <style jsx>{`
        .japanese-pronunciation {
          margin: 1rem 0;
          padding: 1rem;
          border: 1px solid #e0e0e0;
          border-radius: 8px;
          background-color: #f9f9f9;
        }

        .pronunciation-text {
          font-size: 1.2rem;
          margin-bottom: 0.8rem;
          text-align: center;
        }

        .pronunciation-text ruby {
          ruby-align: center;
        }

        .pronunciation-text rt {
          font-size: 0.8rem;
          color: #666;
        }

        .pronunciation-controls {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
          align-items: center;
        }

        .play-button {
          padding: 0.5rem 1rem;
          background-color: #4CAF50;
          color: white;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-size: 0.9rem;
          transition: background-color 0.2s;
        }

        .play-button:hover {
          background-color: #45a049;
        }

        .play-button.playing {
          background-color: #f44336;
        }

        .play-button.playing:hover {
          background-color: #d32f2f;
        }

        .speed-control {
          display: flex;
          align-items: center;
          gap: 0.3rem;
          flex-wrap: wrap;
          justify-content: center;
        }

        .speed-label {
          font-size: 0.9rem;
          color: #666;
        }

        .speed-button {
          padding: 0.2rem 0.5rem;
          background-color: #e0e0e0;
          border: none;
          border-radius: 3px;
          cursor: pointer;
          font-size: 0.8rem;
          transition: all 0.2s;
        }

        .speed-button:hover {
          background-color: #d0d0d0;
        }

        .speed-button.active {
          background-color: #2196F3;
          color: white;
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
          .pronunciation-controls {
            flex-direction: column;
          }
          
          .speed-control {
            justify-content: center;
          }
        }
      `}</style>
    </div>
  );
}

/**
 * 簡化版發音按鈕（用於單字卡片）
 */
export function PronunciationButton({ text, kana, size = 'medium' }) {
  const [isSupported, setIsSupported] = useState(false);

  useEffect(() => {
    setIsSupported('speechSynthesis' in window);
  }, []);

  const playSound = () => {
    if (!isSupported) return;
    
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'ja-JP';
    
    const voices = speechSynthesis.getVoices();
    const japaneseVoice = voices.find(voice => voice.lang.startsWith('ja'));
    if (japaneseVoice) {
      utterance.voice = japaneseVoice;
    }
    
    speechSynthesis.speak(utterance);
  };

  if (!isSupported) return null;

  return (
    <button
      onClick={playSound}
      className={`pronunciation-button ${size}`}
      aria-label={`播放 ${text} 的發音`}
      title="點擊播放發音"
    >
      <style jsx>{`
        .pronunciation-button {
          background: none;
          border: 1px solid #4CAF50;
          color: #4CAF50;
          border-radius: 4px;
          cursor: pointer;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          transition: all 0.2s;
        }
        
        .pronunciation-button:hover {
          background-color: #4CAF50;
          color: white;
        }
        
        .pronunciation-button.small {
          padding: 0.2rem 0.5rem;
          font-size: 0.8rem;
        }
        
        .pronunciation-button.medium {
          padding: 0.3rem 0.8rem;
          font-size: 0.9rem;
        }
        
        .pronunciation-button.large {
          padding: 0.5rem 1rem;
          font-size: 1rem;
        }
      `}</style>
      🔊 {kana || text}
    </button>
  );
}

/**
 * 例句朗讀組件
 */
export function ExampleSentence({ sentence, translation, showTranslation = true }) {
  const [isPlaying, setIsPlaying] = useState(false);

  const playSentence = () => {
    if (!('speechSynthesis' in window)) return;
    
    const utterance = new SpeechSynthesisUtterance(sentence);
    utterance.lang = 'ja-JP';
    
    utterance.onstart = () => setIsPlaying(true);
    utterance.onend = () => setIsPlaying(false);
    
    speechSynthesis.speak(utterance);
  };

  const stopPlaying = () => {
    speechSynthesis.cancel();
    setIsPlaying(false);
  };

  return (
    <div className="example-sentence">
      <div className="sentence-text">
        {sentence}
      </div>
      
      {showTranslation && (
        <div className="sentence-translation">
          {translation}
        </div>
      )}
      
      <button
        onClick={isPlaying ? stopPlaying : playSentence}
        className={`sentence-button ${isPlaying ? 'playing' : ''}`}
      >
        <style jsx>{`
          .example-sentence {
            margin: 1rem 0;
            padding: 1rem;
            border-left: 3px solid #2196F3;
            background-color: #f5f9ff;
          }
          
          .sentence-text {
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
          }
          
          .sentence-translation {
            font-size: 0.9rem;
            color: #666;
            font-style: italic;
          }
          
          .sentence-button {
            margin-top: 0.5rem;
            padding: 0.3rem 0.8rem;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
          }
          
          .sentence-button:hover {
            background-color: #0b7dda;
          }
          
          .sentence-button.playing {
            background-color: #f44336;
          }
        `}</style>
        {isPlaying ? '⏹️ 停止朗讀' : '🔊 朗讀例句'}
      </button>
    </div>
  );
}