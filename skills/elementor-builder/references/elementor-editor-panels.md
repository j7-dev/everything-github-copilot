# Elementor 編輯器面板 — 操作手冊

> 資料來源：https://developers.elementor.com/docs/editor/
> 說明：Elementor 編輯器結構與各面板功能整理，供 MCP 操作參考。

---

## 編輯器整體結構

Elementor 編輯器（Editor）分為兩個主要區域：

| 區域 | 說明 |
|------|------|
| **Preview（預覽區）** | 即時顯示頁面外觀，由 JS 引擎渲染，不需從 Server 重載 |
| **Panel（面板區）** | 編輯控制台，控制頁面所有設定 |

---

## Panel 面板列表

Panel 區包含以下 6 個子面板：

| 面板名稱 | 路由 | 說明 |
|----------|------|------|
| **Menu Panel** | `panel/menu` | 主面板，導覽其他面板的入口 |
| **Site Settings Panel** | — | 全站設定（全域色彩、字型、版型等） |
| **User Preferences Panel** | `panel/editor-preferences` | 使用者個人編輯器偏好 |
| **Page Settings Panel** | `panel/page-settings/settings`<br>`panel/page-settings/style`<br>`panel/page-settings/advanced` | 單頁設定 |
| **History Panel** | `panel/history/actions`<br>`panel/history/revisions` | 歷史記錄與版本回溯 |
| **Widgets Panel** | `panel/elements/categories`<br>`panel/elements/global` | Widget 元件庫 |

---

## 各面板詳細說明

### Menu Panel（主選單面板）

- 編輯器開啟時的**預設入口面板**
- 兩個區塊：
  - **Settings**：導覽到其他設定面板的連結
  - **Navigate From Page**：外部連結與工具

---

### Site Settings Panel（全站設定面板）

三個主要區塊：

| 區塊 | 說明 |
|------|------|
| **Design System** | 定義全域色彩（Global Colors）和字型（Global Fonts）|
| **Theme Style** | 主題層級的全域樣式設定，作為未設定 Widget 樣式時的 fallback |
| **Settings** | 網站識別（Logo、標題）、版型、斷點、自訂 CSS 等 |

> **重點**：Design System 讓你建立統一的色彩與字型方案，並套用到整個網站的所有 Widget。

---

### User Preferences Panel（使用者偏好面板）

- 控制編輯器本身的外觀與行為（與頁面無關）
- 設定儲存在 `wp_users` 資料表（每位使用者各自獨立）
- 可設定項目：
  - 淺色 / 深色主題
  - 面板預設寬度
  - 是否顯示編輯按鈕

---

### Page Settings Panel（頁面設定面板）

三個 Tab：

| Tab | 說明 | 資料儲存位置 |
|-----|------|-------------|
| **Settings** | 標題、摘要、精選圖片、發佈狀態 | `wp_posts` 資料表 |
| **Style** | 頁面背景、margin、padding 等樣式 | `wp_postmeta`（Elementor 自訂欄位） |
| **Advanced** | 此頁面專屬的自訂 CSS | `wp_postmeta` |

**取得頁面設定資料（PHP）：**
```php
// WordPress 標準資料
$page_id        = get_the_ID();
$page_title     = get_the_title();
$page_permalink = get_permalink();

// Elementor 頁面設定資料
$page_settings_manager = \Elementor\Core\Settings\Manager::get_settings_managers('page');
$page_settings_model   = $page_settings_manager->get_model($page_id);
$bg_color = $page_settings_model->get_settings('background_color');
```

> **注意**：Page Settings 的 `{{WRAPPER}}` 佔位符代表 `<body>` 元素的唯一 class。

---

### History Panel（歷史記錄面板）

兩個 Tab：

| Tab | 說明 |
|-----|------|
| **Actions** | 自上次儲存後的所有操作（可 Undo / Redo）|
| **Revisions** | 已儲存到 WordPress 資料庫的頁面版本快照 |

> **重點**：Revisions 是 WordPress 原生功能，Elementor 只是讓還原更方便。Actions 是 Elementor 內部的變更追蹤，未儲存就關閉則消失。

---

### Widgets Panel（元件面板）

**預設開啟的面板**（編輯器第一次載入時顯示）。

兩個 Tab：

| Tab | 說明 |
|-----|------|
| **Elements** | 所有已註冊 Widget 的清單，按分類分組，有搜尋欄 |
| **Global** | 使用者儲存的 Global Widget（一改全改）|

---

## 預設面板設定

Elementor 預設開啟 **Widgets Panel**，可透過程式碼修改：

```php
// 將預設面板改為 Page Settings
function change_default_elementor_panel($config) {
    $config = array_replace_recursive($config, [
        'panel' => [
            'default_route' => 'panel/page-settings/settings'
        ]
    ]);
    return $config;
}
add_filter('elementor/document/config', 'change_default_elementor_panel');
```

**所有可用的 default_route 值：**

```
panel/menu
panel/editor-preferences
panel/page-settings/settings
panel/page-settings/style
panel/page-settings/advanced
panel/history/actions
panel/history/revisions
panel/elements/categories
panel/elements/global
```

---

## Elementor Tabs（控制項 Tab）

Widget 面板使用 Tab 導覽顯示控制項。內建 6 個 Tab：

| Tab ID | 標籤 | 常數 |
|--------|------|------|
| `content` | Content | `Controls_Manager::TAB_CONTENT` |
| `style` | Style | `Controls_Manager::TAB_STYLE` |
| `advanced` | Advanced | `Controls_Manager::TAB_ADVANCED` |
| `responsive` | Responsive | `Controls_Manager::TAB_RESPONSIVE` |
| `layout` | Layout | `Controls_Manager::TAB_LAYOUT` |
| `settings` | Settings | `Controls_Manager::TAB_SETTINGS` |

**使用場景：**
- **Widgets Panel**：Content Tab（設定內容）+ Style Tab（設計樣式），Elementor 自動為所有 Widget 加入 Advanced Tab
- **Page Settings Panel**：Settings、Style、Layout Tab

> **最佳實踐**：官方強烈建議使用預設 Tab，不要自行新增 Tab。

---

## Preview 預覽區功能

| 功能 | 說明 |
|------|------|
| **Inline Editing** | 直接在預覽區點擊文字進行編輯 |
| **Context Menu** | 右鍵元素出現操作選單 |
| **Edit Buttons** | Hover 元素時顯示編輯按鈕 |

---

*文件版本：2026-02-22 | 資料來源：Elementor Developers Docs*
