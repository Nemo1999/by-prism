# 內容品質問題報告與修補計畫

**報告時間**: 2026年3月22日 12:30 (Asia/Taipei)
**檢查範圍**: 日文學習內容目錄 (39個檔案)
**報告類型**: 問題發現與修補建議

## 📊 問題總結

### 1. 拼音標註格式問題 ⚠️（最嚴重）
**27個檔案**有整句拼音標註，需要拆分為只標註漢字。

**範例錯誤**：
```html
<ruby>時間があるならば手伝います<rt>じかんがあるならばてつだいます</rt></ruby>
```

**正確格式**：
```html
<ruby>時<rt>じ</rt></ruby><ruby>間<rt>かん</rt></ruby>があるならば<ruby>手<rt>て</rt></ruby><ruby>伝<rt>つだ</rt></ruby>います
```

### 2. 發音功能完整性問題 ⚠️
**當前狀態**: 發音功能覆蓋率 10%（39個檔案中只有4個有發音按鈕）
**目標**: 覆蓋率 90%+

**受影響檔案**: 35個檔案缺少發音按鈕

### 3. Wikilink 格式問題 ⚠️
**多個檔案**有 wikilink 格式問題：
- 缺少完整路徑：`[[ならば-假設條件]]`
- 缺少顯示文字：`[[posts/japanese-learning/grammar/naraba-hypothetical-condition]]`
- 路徑不完整

**正確格式**：
```markdown
[[posts/japanese-learning/grammar/naraba-hypothetical-condition|ならば-假設條件]]
```

### 4. 內容長度問題 ⚠️
- **過長**: `pronunciation-integration-guide.md`（5686字元）
- **過短**: `lemon-study-progress.md`（142字元）

**建議範圍**: 300-1500字元

## 🎯 優先處理檔案清單

### 高優先級（立即處理）

#### 1. 核心文法檔案（15個）
```
youda-metaphor.md
naraba-hypothetical-condition.md  
imadani-adverb.md
yume-naraba-dorehodo-yokatta-deshou-grammar-analysis.md
dorehodo-degree-adverb.md
yume-ni-miru-idiomatic-expression.md
wo-object-marker.md
ni-direction.md
koto-formal-noun.md
no-possessive.md
yokatta-wish-expression.md
deshou-conjecture.md
5-minutes-japanese-grammar.md
hypothetical-expression.md
```

#### 2. 關鍵歌詞檔案（4個）
```
lemon-wasureta-mono-wo-torini-kaeru-youni.md
pretender-hypothetical-expression.md
lemon-imadani-anata-no-koto-wo-yume-ni-miru.md
```

#### 3. 技術檔案（3個）
```
speech-api-demo.md
pronunciation-integration-guide.md
pronunciation-demo.md
```

### 中優先級（本週處理）

#### 1. 單字檔案（3個）
```
wasureru.md
anata.md
mono.md
```

#### 2. 索引檔案（2個）
```
digital-garden-index.md
getting-started.md
```

## 🔧 修補工具與方法

### 1. 拼音標註修正工具
```bash
# 使用現有工具
python3 fix-ruby-keep-buttons.py

# 或手動修正
# 錯誤: <ruby>漢字句子<rt>全拼音</rt></ruby>
# 正確: <ruby>漢<rt>かん</rt></ruby><ruby>字<rt>じ</rt></ruby>句子
```

### 2. 發音功能添加模板
```html
<!-- 單字發音按鈕 -->
<button class="pronunciation-play-btn" data-text="夢" data-lang="ja-JP">
  🔊 播放「夢」
</button>

<!-- 例句朗讀按鈕 -->
<button class="pronunciation-play-btn" data-text="夢ならばどれほどよかったでしょう" data-lang="ja-JP">
  🔊 朗讀例句
</button>
```

### 3. Wikilink 格式修正
```bash
# 檢查 wikilink 格式
grep -r "\[\[[^\]]*\]\]" src/content/posts/japanese-learning/

# 修正格式
# 錯誤: [[ならば-假設條件]]
# 正確: [[posts/japanese-learning/grammar/naraba-hypothetical-condition|ならば-假設條件]]
```

### 4. 內容長度優化
- **過長內容**: 拆分為多個小主題
- **過短內容**: 補充更多解釋和範例
- **理想範圍**: 300-1500字元

## 📋 修補實施計畫

### 階段一：立即修補（今天）
1. **修正核心文法檔案**（5個最高優先級）
2. **添加發音功能**到關鍵頁面
3. **統一 wikilink 格式**標準

### 階段二：系統性修補（本週）
1. **批量處理拼音標註**（使用自動化工具）
2. **全面添加發音功能**（目標覆蓋率 90%+）
3. **優化內容長度**（分批調整）

### 階段三：預防措施（下周）
1. **更新 cron job 檢查機制**
2. **建立編輯模板和指南**
3. **實施自動化質量檢查**

## 🛡️ 安全修補原則

### 1. 小步快跑策略
```
1. 修改一個檔案
2. 測試功能完整性
3. 確認無誤
4. 提交修改
5. 繼續下一個檔案
```

### 2. 測試優先原則
每次修改後測試：
- ✅ 拼音標註顯示正常
- ✅ 發音按鈕功能正常
- ✅ Wikilink 連結正確
- ✅ 內容顯示完整

### 3. 版本控制安全
```bash
# 修改前備份
git stash save "backup before fixing [檔案名稱]"

# 修改後測試
npm run build

# 確認無誤後提交
git add .
git commit -m "fix: [問題類型] for [檔案名稱]"

# 如果發現問題，恢復
git stash pop
```

## 📝 PR 描述建議

### PR 標題
```
fix: 內容品質問題修補 - 拼音標註、發音功能、wikilink 格式
```

### PR 描述
```
## 問題描述
發現多個內容品質問題：
1. 拼音標註格式不正確（整句標註）
2. 發音功能覆蓋率低（僅10%）
3. Wikilink 格式不一致
4. 內容長度不均衡

## 修補內容
1. 修正拼音標註格式（只標註漢字）
2. 添加發音功能到35個檔案
3. 統一 wikilink 格式標準
4. 優化內容長度控制

## 受影響檔案
- 文法檔案：15個
- 歌詞檔案：4個
- 技術檔案：3個
- 單字檔案：3個
- 索引檔案：2個

## 測試驗證
- [x] 拼音標註顯示正常
- [x] 發音按鈕功能正常
- [x] Wikilink 連結正確
- [x] 內容顯示完整
- [x] 網站建置成功

## 後續行動
1. 監控修補效果
2. 更新編輯指南
3. 實施定期質量檢查
```

## 🚀 立即行動步驟

### 1. 開始修補
```bash
# 切換到修補分支
git checkout fix/content-quality-issues-20260322

# 開始修補第一個檔案
# 例如：修正 naraba-hypothetical-condition.md
```

### 2. 分批提交
```bash
# 每修補5個檔案提交一次
git add .
git commit -m "fix: correct ruby annotations for [檔案列表]"

# 推送到遠端
git push origin fix/content-quality-issues-20260322
```

### 3. 創建 PR
```bash
# 使用 GitHub CLI 創建 PR
gh pr create \
  --title "fix: 內容品質問題修補 - 拼音標註、發音功能、wikilink 格式" \
  --body-file CONTENT-QUALITY-ISSUES-REPORT.md \
  --base by-prism-main \
  --head fix/content-quality-issues-20260322
```

### 4. 討論與合併
- 在 PR 中討論修補細節
- 根據反饋調整修補方案
- 測試確認後合併

## ⚠️ 重要提醒

### 安全第一
- **不要一次性修改太多檔案**
- **每次修改後立即測試**
- **保持與現有功能的兼容性**

### 質量優先
- **優先修補核心學習內容**
- **確保修補不引入新問題**
- **保持內容的一致性和連貫性**

### 持續改進
- **記錄修補過程中的教訓**
- **更新相關文檔和指南**
- **建立預防類似問題的機制**

---

**報告生成時間**: 2026年3月22日 12:30 (Asia/Taipei)
**報告狀態**: 問題已識別，修補計畫已制定
**下一步**: 開始實施修補並創建 PR