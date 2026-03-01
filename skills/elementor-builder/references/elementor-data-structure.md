# Elementor Data Structure — AI 操作手冊

> 資料來源：https://developers.elementor.com/docs/data-structure/
> 版本：資料結構版本 `0.4`
> 說明：本文件整理 Elementor 頁面 JSON 資料結構，供 AI 理解與操作使用。

---

## 目錄

1. [概覽](#1-概覽)
2. [頂層 JSON 結構](#2-頂層-json-結構)
3. [page_settings（頁面設定）](#3-page_settings頁面設定)
4. [content（頁面內容）](#4-content頁面內容)
5. [通用元素結構](#5-通用元素結構)
6. [Container 元素](#6-container-元素)
7. [Widget 元素](#7-widget-元素)
8. [元素類型對照表](#8-元素類型對照表)
9. [資料結構演進：傳統 vs 現代](#9-資料結構演進傳統-vs-現代)
10. [完整範例](#10-完整範例)
11. [注意事項與限制](#11-注意事項與限制)

---

## 1. 概覽

### 引擎運作方式

Elementor 引擎分為兩個面向：

- **Editor（編輯器）**：透過拖放介面產生結構化 JSON 資料。
- **Frontend（前端）**：解析 JSON 資料並渲染頁面版面。

### 資料格式

- 使用 **JSON** 格式。
- 儲存位置：WordPress `wp_postmeta` 資料表（private custom field）。
- 可透過下載 Elementor Template（`.json`）取得完整資料。
- 資料為標準化格式，支援跨頁面、跨 WordPress 安裝的匯入匯出。

---

## 2. 頂層 JSON 結構

### 結構定義

```json
{
  "title": "Template Title",
  "type": "page",
  "version": "0.4",
  "page_settings": [],
  "content": []
}
```

### 欄位說明

| 欄位 | 型別 | 說明 |
|------|------|------|
| `title` | `string` | 顯示在 WordPress 後台與 Elementor 編輯器的標題 |
| `type` | `string` | 文件類型，見下方可用值 |
| `version` | `string` | 資料結構版本，目前最新為 `0.4` |
| `page_settings` | `array` / `object` | 頁面設定面板的資料；無設定時為空 `[]`，有設定時為 `{}` |
| `content` | `array` | 存放所有頁面元素的陣列 |

### `type` 可用值

| 值 | 說明 |
|----|------|
| `page` | 一般頁面 |
| `post` | 文章 |
| `header` | 頁首模板 |
| `footer` | 頁尾模板 |
| `error-404` | 404 頁面 |
| `popup` | 彈出視窗 |

---

## 3. page_settings（頁面設定）

`page_settings` 存放頁面層級的 Elementor 樣式與行為設定。無設定時為空陣列 `[]`，有設定時為 key-value 物件 `{}`。

> **重要區分**：Page Settings 面板同時包含 WordPress 資料（title、excerpt、featured image、post status）與 Elementor 資料。WordPress 資料儲存在 `wp_posts` 資料表，**不在** `page_settings` 欄位內；`page_settings` 只儲存 Elementor 相關設定。

### 資料來源

Page Settings 面板分三個 Tab：

| Tab | 說明 | 儲存位置 |
|-----|------|----------|
| Settings | 一般頁面設定（title、excerpt、featured image、post status） | `wp_posts` 資料表 |
| Style | 頁面層級樣式（背景、margin、padding 等） | `page_settings`（post meta） |
| Advanced | 自訂 CSS（僅套用於此頁面） | `page_settings`（post meta） |

Addon 開發者也可以注入自訂控制項至 Page Settings 面板，其資料同樣存入 `page_settings`。

### 無設定時

```json
{
  "title": "About Page",
  "type": "page",
  "version": "0.4",
  "page_settings": [],
  "content": []
}
```

### 有設定時（key-value 物件）

```json
{
  "title": "Template Title",
  "type": "page",
  "version": "0.4",
  "page_settings": {
    "key": "value",
    "key": "value"
  },
  "content": []
}
```

### 常見 Style 設定範例

```json
"page_settings": {
  "background_background": "classic",
  "background_color": "#FFFFFF",
  "margin": {
    "unit": "px",
    "top": "0",
    "right": "0",
    "bottom": "0",
    "left": "0",
    "isLinked": true
  },
  "padding": {
    "unit": "px",
    "top": "0",
    "right": "10",
    "bottom": "0",
    "left": "10",
    "isLinked": false
  },
  "scroll_snap": "yes"
}
```

### HTML tag 設定（模板專用）

```json
"page_settings": {
  "content_wrapper_html_tag": "header"
}
```

> 可用值：`header`、`footer`、`main`、`section`、`article`、`div` 等語義 HTML 標籤。

### Popup 專用設定

```json
"page_settings": {
  "width": { "unit": "px", "size": 600, "sizes": [] },
  "entrance_animation": "fadeIn",
  "exit_animation": "fadeIn",
  "overlay_background_color": "#000000AA",
  "prevent_scroll": "yes"
}
```

### 尺寸值物件格式

當設定值為尺寸時，使用以下物件格式：

```json
{
  "unit": "px",
  "size": 600,
  "sizes": []
}
```

| 欄位 | 說明 |
|------|------|
| `unit` | 單位：`px`、`%`、`em`、`rem`、`vh`、`vw` |
| `size` | 數值 |
| `sizes` | 通常為空陣列，特殊情境（如 gradient）才使用 |

---

## 4. content（頁面內容）

`content` 是包含所有頁面元素的**遞迴陣列**。元素可以無限巢狀，容器可以包含其他容器或 Widget，Widget 也可以包含其他 Widget。

### 空頁面

```json
{
  "content": []
}
```

### 有內容的頁面

```json
{
  "content": [
    {
      "id": "6af611eb",
      "elType": "container",
      "isInner": false,
      "settings": [],
      "elements": []
    }
  ]
}
```

---

## 5. 通用元素結構

所有 Elementor 元素（不論是版面元素還是 Widget 元素）都共用以下基礎欄位。

### 基礎結構

```json
{
  "id": "12345678",
  "elType": "element",
  "isInner": false,
  "settings": [],
  "elements": []
}
```

### 欄位說明

| 欄位 | 型別 | 說明 |
|------|------|------|
| `id` | `string` | 元素的唯一識別碼（8碼十六進位字串） |
| `elType` | `string` | 元素類型：`container`、`widget`、`section`（舊式）、`column`（舊式） |
| `isInner` | `boolean` | 是否為內層元素 |
| `settings` | `array` / `object` | 元素的控制項設定值；無設定為 `[]`，有設定為 `{}` |
| `elements` | `array` | 巢狀子元素陣列 |

> **注意**：當 `elType` 為 `widget` 時，會額外加入 `widgetType` 欄位。

### 兩種元素分類

| 分類 | 類型 | 特點 |
|------|------|------|
| 版面元素（Layout Elements） | `section`、`column`、`container` | 主要儲存 `elements`（巢狀子元素） |
| Widget 元素（Widget Elements） | `widget` | 主要儲存 `settings`（控制項資料） |

---

## 6. Container 元素

Container 是現代結構的核心版面元素，支援無限巢狀。

### 結構定義

```json
{
  "id": "12345678",
  "elType": "container",
  "isInner": false,
  "settings": [],
  "elements": []
}
```

### 欄位說明

Container 與通用元素結構相同，所有欄位定義見 [第 5 節](#5-通用元素結構)。

### Container 常用 settings

| 設定 key | 型別 | 說明 |
|----------|------|------|
| `height` | `string` | 高度模式，如 `min-height`、`fit-to-screen` |
| `custom_height` | `object` | 自訂高度尺寸物件（含 `unit`、`size`、`sizes`） |
| `content_position` | `string` | 內容垂直對齊：`top`、`middle`、`bottom` |
| `html_tag` | `string` | 輸出的 HTML 標籤，如 `section`、`div`、`article` |
| `padding` | `object` | 內距設定物件 |

### 內距物件格式

```json
"padding": {
  "unit": "px",
  "top": "20",
  "right": "20",
  "bottom": "20",
  "left": "20",
  "isLinked": true
}
```

| 欄位 | 說明 |
|------|------|
| `unit` | 單位 |
| `top` / `right` / `bottom` / `left` | 各方向數值（字串型態） |
| `isLinked` | `true` 表示四邊連動，`false` 表示各自獨立 |

### 巢狀範例

```json
{
  "id": "458aabdc",
  "elType": "container",
  "isInner": false,
  "settings": {
    "height": "min-height",
    "custom_height": { "unit": "vh", "size": 70, "sizes": [] },
    "content_position": "middle",
    "html_tag": "section"
  },
  "elements": [
    {
      "id": "46ef0576",
      "elType": "container",
      "isInner": false,
      "settings": [],
      "elements": []
    }
  ]
}
```

---

## 7. Widget 元素

Widget 是具有自訂屬性的元素，每個 Widget 依其類型有不同的 `settings` 欄位。

### 結構定義

```json
{
  "id": "12345678",
  "elType": "widget",
  "widgetType": "heading",
  "isInner": false,
  "settings": [],
  "elements": []
}
```

### 額外欄位

| 欄位 | 型別 | 說明 |
|------|------|------|
| `widgetType` | `string` | Widget 的具體類型名稱 |

### 常見 widgetType 值

| widgetType | 說明 |
|------------|------|
| `heading` | 標題 |
| `image` | 圖片 |
| `button` | 按鈕 |
| `text-editor` | 文字編輯器 |
| `social-icons` | 社群圖示 |
| `menu` | 導覽選單（支援巢狀） |
| `tabs` | 分頁（支援巢狀，新式） |
| `accordion` | 手風琴（支援巢狀，新式） |
| `carousel` | 輪播（支援巢狀，新式） |

### settings 資料規則

- `settings` 中的 key 為 Widget 控制項的 control ID。
- value 為使用者在編輯器中設定的值。
- 未設定任何控制項時為空 `[]`；有設定時為 `{}`。

### Widget settings 範例

**heading widget：**
```json
"settings": {
  "title": "Add Your Heading Text Here",
  "align": "center"
}
```

**button widget：**
```json
"settings": {
  "text": "Click Me",
  "button_text_color": "#000000",
  "background_color": "#E7DFF5"
}
```

**image widget（含 padding）：**
```json
"settings": {
  "_padding": {
    "unit": "px",
    "top": "100",
    "right": "0",
    "bottom": "100",
    "left": "0",
    "isLinked": false
  }
}
```

> **注意**：以 `_` 開頭的 key（如 `_padding`）通常是通用樣式控制項，適用於所有 Widget。

### 巢狀 Widget

原本 Widget 不支援巢狀，新版 Elementor 開始引入支援巢狀的 Widget（如 Menu、Tabs、Accordion、Carousel）。巢狀子元素同樣存放於 `elements` 陣列中。

---

## 8. 元素類型對照表

| `elType` | 說明 | 支援 `elements` | 需要 `widgetType` | 備註 |
|----------|------|:-:|:-:|------|
| `container` | 現代版面容器 | ✅ | ❌ | 推薦使用 |
| `widget` | Widget 元素 | 部分支援 | ✅ | 需填 `widgetType` |
| `section` | 舊式版面區塊 | ✅ | ❌ | 傳統結構，不建議新建 |
| `column` | 舊式欄位 | ✅ | ❌ | 只能存在於 `section` 內 |

---

## 9. 資料結構演進：傳統 vs 現代

### 傳統結構（section → column → widget）

```
page.content
  └── section (elType: "section")
        └── column (elType: "column")
              └── widget (elType: "widget")
```

```json
{
  "id": "123ab956",
  "elType": "section",
  "isInner": false,
  "settings": [],
  "elements": [
    {
      "id": "1d4a679a",
      "elType": "column",
      "isInner": false,
      "settings": [],
      "elements": [
        {
          "id": "1d4a679a",
          "elType": "widget",
          "widgetType": "image",
          "isInner": false,
          "settings": [],
          "elements": []
        }
      ]
    }
  ]
}
```

### 現代結構（container → container/widget）

```
page.content
  └── container (elType: "container")
        ├── container (elType: "container")
        │     └── container ...（無限巢狀）
        └── widget (elType: "widget")
```

- Container 可以直接包含 Container 或 Widget。
- 無強制層級限制，結構更靈活。

### 比較

| 面向 | 傳統結構 | 現代結構 |
|------|----------|----------|
| 根元素 | `section` | `container` |
| 層級限制 | Section → Column → Widget（固定三層） | 無限巢狀 |
| 彈性 | 低 | 高 |
| 是否推薦 | 否（舊版相容） | 是 |

---

## 10. 完整範例

### Header 模板

```json
{
  "title": "Site Header",
  "type": "header",
  "version": "0.4",
  "page_settings": {
    "content_wrapper_html_tag": "header",
    "background_background": "classic",
    "background_color": "#000000"
  },
  "content": [
    {
      "id": "3130e2cf",
      "elType": "container",
      "isInner": false,
      "settings": [],
      "elements": []
    }
  ]
}
```

### Footer 模板

```json
{
  "title": "Site Footer",
  "type": "footer",
  "version": "0.4",
  "page_settings": {
    "content_wrapper_html_tag": "footer"
  },
  "content": [
    {
      "id": "1aebaeaa",
      "elType": "container",
      "isInner": false,
      "settings": [],
      "elements": []
    }
  ]
}
```

### 404 頁面

```json
{
  "title": "404 Page",
  "type": "error-404",
  "version": "0.4",
  "page_settings": {
    "content_wrapper_html_tag": "main",
    "background_background": "classic",
    "background_color": "#333333"
  },
  "content": []
}
```

### Popup

```json
{
  "title": "Mobile Navigation Popup",
  "type": "popup",
  "version": "0.4",
  "page_settings": {
    "width": { "unit": "px", "size": 600, "sizes": [] },
    "entrance_animation": "fadeIn",
    "exit_animation": "fadeIn",
    "overlay_background_color": "#000000AA",
    "prevent_scroll": "yes"
  },
  "content": [
    {
      "id": "c647ac2",
      "elType": "container",
      "isInner": false,
      "settings": {
        "padding": {
          "unit": "px",
          "top": "20",
          "right": "20",
          "bottom": "20",
          "left": "20",
          "isLinked": true
        }
      },
      "elements": []
    }
  ]
}
```

### Container 包含多個 Widget

```json
{
  "title": "About Page",
  "type": "page",
  "version": "0.4",
  "page_settings": [],
  "content": [
    {
      "id": "6af611eb",
      "elType": "container",
      "isInner": false,
      "settings": [],
      "elements": [
        {
          "id": "6a637978",
          "elType": "widget",
          "widgetType": "heading",
          "isInner": false,
          "settings": {
            "title": "Add Your Heading Text Here",
            "align": "center"
          },
          "elements": []
        },
        {
          "id": "687dba89",
          "elType": "widget",
          "widgetType": "image",
          "isInner": false,
          "settings": {
            "_padding": {
              "unit": "px",
              "top": "100",
              "right": "0",
              "bottom": "100",
              "left": "0",
              "isLinked": false
            }
          },
          "elements": []
        },
        {
          "id": "6f58bb5",
          "elType": "widget",
          "widgetType": "button",
          "isInner": false,
          "settings": {
            "text": "Click Me",
            "button_text_color": "#000000",
            "background_color": "#E7DFF5"
          },
          "elements": []
        }
      ]
    }
  ]
}
```

---

## 11. 注意事項與限制

### 已知限制

- `page_settings` 的完整 key 清單無官方文件，本手冊整理自各範例，不保證窮舉。
- Special Cases 頁面（Responsive Data、Repeaters、Global Styles）官方尚無內容，未納入本文件。

### AI 操作建議

1. **建立新元素時**，`id` 應為 8 碼十六進位隨機字串（如 `a3f1c8b2`）。
2. **判斷使用哪種結構**：新建頁面一律使用 `container`，只有解析舊頁面時才會遇到 `section`/`column`。
3. **`settings` 的值型別**：數字型尺寸使用尺寸物件格式（含 `unit`、`size`、`sizes`）；顏色使用 hex 字串；布林值用 `"yes"` / `"no"` 字串（Elementor 慣例）或 `true` / `false`。
4. **`isInner`**：目前絕大多數情況下為 `false`，除非是特定巢狀 Widget 內部的元素。
5. **`elements` 永遠是陣列**，即使為空也需填 `[]`。
6. **`settings` 為空時使用 `[]`**（空陣列），有值時使用 `{}`（物件）——兩者不可混用。

---

*文件版本：2026-02-22 | 資料結構版本 0.4*
