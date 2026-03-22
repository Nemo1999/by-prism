#!/bin/bash

# 日文單字組生成器
# 每周自動生成一個新的單字組主題

set -e

echo "📚 日文單字組生成器 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="

PROJECT_DIR="/home/nemo/.openclaw/workspace/blog-by-prism"
TEMPLATE_FILE="$PROJECT_DIR/src/content/posts/japanese-learning/_templates/vocabulary-group-template.md"
VOCABULARY_DIR="$PROJECT_DIR/src/content/posts/japanese-learning/vocabulary"
LOG_DIR="/home/nemo/.openclaw/workspace/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/vocabulary-group-generator-$(date '+%Y%m%d-%H%M%S').log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "📝 開始生成記錄: $(date '+%Y-%m-%d %H:%M:%S')"
echo "📁 專案目錄: $PROJECT_DIR"
echo "📁 單字目錄: $VOCABULARY_DIR"
echo "📄 模板檔案: $TEMPLATE_FILE"

# 檢查必要檔案
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ 模板檔案不存在: $TEMPLATE_FILE"
    exit 1
fi

if [ ! -d "$VOCABULARY_DIR" ]; then
    echo "❌ 單字目錄不存在: $VOCABULARY_DIR"
    exit 1
fi

# 主題清單（按優先順序）
TOPICS=(
    "days-of-week:月曜日から金曜日:星期一到星期五:時間基礎"
    "numbers:数字の数え方:數字介紹:特殊規則解析"
    "weather:天気の表現:天氣介紹:日常對話必備"
    "colors:色の名前:顏色介紹:視覺學習"
    "senses:五感の表現:感官介紹:五感總覽"
    "sounds:音の表現:聲音介紹:擬聲詞與描述"
    "taste:味覚の表現:味覺介紹:食物與感受"
    "moods:気持ちの表現:心情介紹:情感表達"
    "touch:触覚の表現:觸覺介紹:質感描述"
    "body-states:体の状態:身體狀態:健康與感受"
    "smell:匂いの表現:味道嗅覺:香氣描述"
    "nature:自然と生物:自然生物植物:短文拆解"
    "bad-words:失礼な言葉:髒話:文化理解"
    "occupations:職業の名前:職業介紹:社會角色"
    "ordering-food:注文の仕方:點餐介紹:實用會話"
    "travel:旅行の表現:旅行介紹:情境應用"
)

# 檢查已存在的主題
existing_topics=()
for topic in "${TOPICS[@]}"; do
    IFS=':' read -r filename jp_title zh_title description <<< "$topic"
    if [ -f "$VOCABULARY_DIR/$filename.md" ]; then
        existing_topics+=("$filename")
    fi
done

echo ""
echo "📊 主題狀態檢查..."
echo "總主題數: ${#TOPICS[@]} 個"
echo "已生成: ${#existing_topics[@]} 個"
echo "待生成: $((${#TOPICS[@]} - ${#existing_topics[@]})) 個"

# 選擇下一個主題
next_topic=""
for topic in "${TOPICS[@]}"; do
    IFS=':' read -r filename jp_title zh_title description <<< "$topic"
    if [[ ! " ${existing_topics[@]} " =~ " ${filename} " ]]; then
        next_topic="$topic"
        break
    fi
done

if [ -z "$next_topic" ]; then
    echo "✅ 所有主題都已生成！"
    echo "建議："
    echo "1. 擴展主題清單"
    echo "2. 創建進階主題"
    echo "3. 更新現有主題內容"
    exit 0
fi

IFS=':' read -r filename jp_title zh_title description <<< "$next_topic"
OUTPUT_FILE="$VOCABULARY_DIR/$filename.md"
TODAY=$(date '+%Y-%m-%d')
NEXT_WEEK=$(date -d "+7 days" '+%Y-%m-%d')

echo ""
echo "🎯 選擇下一個主題:"
echo "檔案名稱: $filename.md"
echo "日文標題: $jp_title"
echo "中文標題: $zh_title"
echo "主題描述: $description"
echo "輸出檔案: $OUTPUT_FILE"

# 讀取模板
template_content=$(cat "$TEMPLATE_FILE")

# 替換模板變數
new_content=$(echo "$template_content" | \
    sed "s/主題名稱-日文單字組/$jp_title-$zh_title/g" | \
    sed "s/主題相關的日文單字組介紹與比較/$description/g" | \
    sed "s/YYYY-MM-DD/$TODAY/g" | \
    sed "s/簡短的主題介紹，說明這個單字組的重要性和使用情境。/這是$zh_title的日文單字組，$description。/g")

# 根據主題類型添加特定內容
case $filename in
    "days-of-week")
        new_content=$(echo "$new_content" | \
            sed "/## 📊 單字對照表/,/## 🎨 視覺學習/c\\
## 📊 單字對照表\\n\\n| 日文 | 羅馬拼音 | 中文意思 | 使用頻率 | 難度 | 元素來源 |\\n|------|----------|----------|----------|------|----------|\\n| 月曜日 | getsuyōbi | 星期一 | ★★★★★ | 初級 | 月（月亮） |\\n| 火曜日 | kayōbi | 星期二 | ★★★★★ | 初級 | 火（火星） |\\n| 水曜日 | suiyōbi | 星期三 | ★★★★★ | 初級 | 水（水星） |\\n| 木曜日 | mokuyōbi | 星期四 | ★★★★★ | 初級 | 木（木星） |\\n| 金曜日 | kin'yōbi | 星期五 | ★★★★★ | 初級 | 金（金星） |")
        ;;
    "numbers")
        new_content=$(echo "$new_content" | \
            sed "/## 📊 單字對照表/,/## 🎨 視覺學習/c\\
## 📊 單字對照表\\n\\n| 日文 | 羅馬拼音 | 中文意思 | 使用頻率 | 難度 | 特殊規則 |\\n|------|----------|----------|----------|------|----------|\\n| 一 | ichi | 1 | ★★★★★ | 初級 | 基本數字 |\\n| 二 | ni | 2 | ★★★★★ | 初級 | 基本數字 |\\n| 三 | san | 3 | ★★★★★ | 初級 | 基本數字 |\\n| 四 | shi/yon | 4 | ★★★★☆ | 中級 | 有兩種讀法 |\\n| 五 | go | 5 | ★★★★★ | 初級 | 基本數字 |\\n| 六 | roku | 6 | ★★★★★ | 初級 | 基本數字 |\\n| 七 | shichi/nana | 7 | ★★★★☆ | 中級 | 有兩種讀法 |\\n| 八 | hachi | 8 | ★★★★★ | 初級 | 基本數字 |\\n| 九 | kyū/ku | 9 | ★★★★☆ | 中級 | 有兩種讀法 |\\n| 十 | jū | 10 | ★★★★★ | 初級 | 基本數字 |")
        ;;
    "weather")
        new_content=$(echo "$new_content" | \
            sed "/## 📊 單字對照表/,/## 🎨 視覺學習/c\\
## 📊 單字對照表\\n\\n| 日文 | 羅馬拼音 | 中文意思 | 使用頻率 | 難度 | 天氣類型 |\\n|------|----------|----------|----------|------|----------|\\n| 晴れ | hare | 晴天 | ★★★★★ | 初級 | 天氣狀況 |\\n| 雨 | ame | 雨 | ★★★★★ | 初級 | 天氣狀況 |\\n| 曇り | kumori | 陰天 | ★★★★☆ | 初級 | 天氣狀況 |\\n| 雪 | yuki | 雪 | ★★★★☆ | 初級 | 天氣狀況 |\\n| 風 | kaze | 風 | ★★★☆☆ | 初級 | 天氣現象 |\\n| 雷 | kaminari | 雷 | ★★★☆☆ | 中級 | 天氣現象 |\\n| 霧 | kiri | 霧 | ★★☆☆☆ | 中級 | 天氣現象 |")
        ;;
    *)
        # 通用模板，需要手動完善
        new_content=$(echo "$new_content" | \
            sed "/## 📊 單字對照表/,/## 🎨 視覺學習/c\\
## 📊 單字對照表\\n\\n| 日文 | 羅馬拼音 | 中文意思 | 使用頻率 | 難度 | 分類 |\\n|------|----------|----------|----------|------|------|\\n| 單字1 | 拼音1 | 意思1 | ★★★☆☆ | 初級 | 分類1 |\\n| 單字2 | 拼音2 | 意思2 | ★★★★☆ | 中級 | 分類2 |\\n| 單字3 | 拼音3 | 意思3 | ★★★★★ | 高級 | 分類3 |")
        ;;
esac

# 寫入新檔案
echo "$new_content" > "$OUTPUT_FILE"
echo "✅ 已生成檔案: $OUTPUT_FILE"

# 添加發音按鈕（基礎版本）
echo "🔊 添加基礎發音按鈕..."
sed -i '/<ruby>.*<rt>.*<\/rt><\/ruby>/a\<button class="pronunciation-play-btn" data-text="日文單字" data-lang="ja-JP">🔊 播放</button>' "$OUTPUT_FILE"

# 檢查檔案
echo "🔍 檢查生成的檔案..."
if [ -f "$OUTPUT_FILE" ]; then
    file_size=$(wc -l < "$OUTPUT_FILE")
    echo "✅ 檔案存在，行數: $file_size"
    
    # 檢查必要元素
    if grep -q "pronunciation-play-btn" "$OUTPUT_FILE"; then
        echo "✅ 包含發音按鈕"
    else
        echo "⚠️  缺少發音按鈕"
    fi
    
    if grep -q "<ruby>" "$OUTPUT_FILE"; then
        echo "✅ 包含拼音標註"
    else
        echo "⚠️  缺少拼音標註"
    fi
    
    if grep -q "## 📊 單字對照表" "$OUTPUT_FILE"; then
        echo "✅ 包含單字對照表"
    else
        echo "⚠️  缺少單字對照表"
    fi
else
    echo "❌ 檔案生成失敗"
    exit 1
fi

# 測試建置
echo "🏗️  測試建置..."
cd "$PROJECT_DIR"
if timeout 30 npm run build > /dev/null 2>&1; then
    echo "✅ 建置成功"
else
    echo "⚠️  建置可能有問題，需要手動檢查"
fi

# 生成報告
REPORT_FILE="$LOG_DIR/vocabulary-group-report-$(date '+%Y%m%d-%H%M%S').md"

cat > "$REPORT_FILE" << EOF
# 單字組生成報告
**生成時間**: $(date '+%Y-%m-%d %H:%M:%S')
**生成主題**: $zh_title ($jp_title)

## 📋 生成資訊

### 主題資訊
- **檔案名稱**: $filename.md
- **日文標題**: $jp_title
- **中文標題**: $zh_title
- **主題描述**: $description
- **生成日期**: $TODAY
- **檔案路徑**: $OUTPUT_FILE

### 系統狀態
- **總主題數**: ${#TOPICS[@]} 個
- **已生成**: ${#existing_topics[@]} 個
- **待生成**: $((${#TOPICS[@]} - ${#existing_topics[@]})) 個
- **建置狀態**: $( [ $? -eq 0 ] && echo "✅ 成功" || echo "⚠️  需要檢查" )

## 📊 內容檢查

### 必要元素檢查
- [$(grep -q "pronunciation-play-btn" "$OUTPUT_FILE" && echo "x" || echo " ")] 發音按鈕
- [$(grep -q "<ruby>" "$OUTPUT_FILE" && echo "x" || echo " ")] 拼音標註
- [$(grep -q "## 📊 單字對照表" "$OUTPUT_FILE" && echo "x" || echo " ")] 單字對照表
- [$(grep -q "## 🔊 發音練習" "$OUTPUT_FILE" && echo "x" || echo " ")] 發音練習區塊
- [$(grep -q "## 📝 例句應用" "$OUTPUT_FILE" && echo "x" || echo " ")] 例句應用區塊

### 檔案統計
- **總行數**: $file_size 行
- **檔案大小**: $(du -h "$OUTPUT_FILE" | cut -f1)

## 🔧 需要手動完善的部分

### 1. 單字內容
需要添加具體的單字、拼音和解釋。

### 2. 發音按鈕
需要更新發音按鈕的 data-text 屬性為實際日文單字。

### 3. 例句內容
需要添加實際的例句和對話。

### 4. 圖片資源
需要添加相關圖片並註明出處。

### 5. 練習活動
需要設計具體的練習活動。

## 🎯 下一步行動

### 立即行動（今天）
1. **完善單字內容**：填寫單字對照表的具體內容
2. **更新發音按鈕**：設置正確的日文單字
3. **添加基本例句**：創建3-5個基本例句

### 短期行動（本周）
1. **設計練習活動**：創建聽力、口說、閱讀練習
2. **尋找圖片資源**：添加視覺學習素材
3. **測試發音功能**：確保所有發音按鈕正常工作

### 長期行動（每月）
1. **系統性主題生成**：按計畫每周生成一個主題
2. **內容質量優化**：定期更新和完善內容
3. **學習效果評估**：收集學習者反饋

## 📝 手動完善指南

### 單字對照表完善
\`\`\`markdown
| 日文 | 羅馬拼音 | 中文意思 | 使用頻率 | 難度 | 備註 |
|------|----------|----------|----------|------|------|
| 實際單字1 | 實際拼音1 | 實際意思1 | ★★★☆☆ | 初級 | 備註1 |
| 實際單字2 | 實際拼音2 | 實際意思2 | ★★★★☆ | 中級 | 備註2 |
\`\`\`

### 發音按鈕完善
\`\`\`html
<button class="pronunciation-play-btn" data-text="實際日文單字" data-lang="ja-JP">
  🔊 播放「單字名稱」
</button>
\`\`\`

### 例句完善
\`\`\`markdown
**例句1**：<ruby>實際日文句子<rt>實際拼音</rt></ruby> — 中文翻譯。
<button class="pronunciation-play-btn" data-text="實際日文句子" data-lang="ja-JP">🔊 朗讀例句1</button>
\`\`\`

## 📈 進度追蹤

### 本週進度
- [ ] 完善單字內容
- [ ] 更新發音功能
- [ ] 添加例句
- [ ] 測試建置

### 主題生成進度
**已完成**: ${#existing_topics[@]}/${#TOPICS[@]} ($((${#existing_topics[@]} * 100 / ${#TOPICS[@]}))%)

### 下次生成時間
**建議時間**: $(date -d "+7 days" '+Y年%m月%d日')
**下個主題**: $(for topic in "${TOPICS[@]}"; do IFS=':' read -r f j t d <<< "$topic"; if [[ ! " ${existing_topics[@]} " =~ " ${f} " ]] && [ "$f" != "$filename" ]; then echo "$t ($d)"; break; fi; done)

---

**報告生成時間**: $(date '+%Y-%m-%d %H:%M:%S')
**生成狀態**: ✅ 基礎框架已生成
**需要手動完善**: 是
**建議優先級**: 高

**注意**: 這是一個自動生成的基礎框架，需要手動完善具體內容才能發布。
EOF

echo ""
echo "=================================================="
echo "✅ 單字組生成完成！"
echo "📄 報告已保存: $REPORT_FILE"
echo "