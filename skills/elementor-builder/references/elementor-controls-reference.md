# Elementor Editor Controls — 控制項參考

> 資料來源：https://developers.elementor.com/docs/editor-controls/
> 說明：Elementor 控制項類型與資料格式，用於理解 Widget settings 的 key-value 結構。

---

## 控制項概覽

Controls（控制項）是 Elementor 面板中的輸入欄位與 UI 元素，讓使用者設定 Widget 的內容與樣式。控制項的值最終儲存在元素的 `settings` 物件中。

**三種控制項類型：**

| 類型 | 說明 | 方法 |
|------|------|------|
| Regular Control | 基本輸入控制項 | `add_control()` |
| Responsive Control | 支援響應式（不同裝置不同值） | `add_responsive_control()` |
| Group Control | 多個控制項組成一組（如 typography） | `add_group_control()` |

---

## Regular Controls（基本控制項）

### 主要控制項類型對照

| Control 常數 | 說明 | 回傳值型別 | settings 格式範例 |
|-------------|------|-----------|------------------|
| `TEXT` | 文字輸入 | `string` | `"title": "Hello World"` |
| `NUMBER` | 數字輸入 | `string` | `"size": "50"` |
| `TEXTAREA` | 多行文字 | `string` | `"description": "..."` |
| `COLOR` | 顏色選擇器 | `string` (hex/rgba) | `"text_color": "#FF0000"` |
| `MEDIA` | 媒體庫圖片選擇 | `object` | `{"id": 123, "url": "..."}` |
| `SELECT` | 下拉選單 | `string` | `"open_lightbox": "yes"` |
| `CHOOSE` | 圖示按鈕選擇（對齊等） | `string` | `"align": "center"` |
| `SWITCHER` | 開關切換 | `string` | `"show_title": "yes"` |
| `SLIDER` | 滑桿 | `object` | `{"size": 20, "unit": "px"}` |
| `DIMENSIONS` | 四邊數值（margin/padding）| `object` | `{"top":"10","right":"10","bottom":"10","left":"10","unit":"px","isLinked":true}` |
| `ICONS` | 圖示選擇 | `object` | `{"value":"fas fa-star","library":"fa-solid"}` |
| `URL` | URL 輸入 | `object` | `{"url":"https://...","is_external":true,"nofollow":false}` |

---

## Responsive Controls（響應式控制項）

響應式控制項會為每個裝置儲存獨立的值，在 `settings` 中加上裝置後綴：

| 裝置 | settings key 後綴 |
|------|------------------|
| Desktop | （無後綴，為預設值） |
| Tablet | `_tablet` |
| Mobile | `_mobile` |

**範例：**
```json
"space_between": {"size": 30, "unit": "px"},
"space_between_tablet": {"size": 20, "unit": "px"},
"space_between_mobile": {"size": 10, "unit": "px"}
```

---

## Group Controls（群組控制項）

群組控制項是多個相關控制項的集合，以 `{group_name}_{field}` 格式存在 `settings` 中。

### 常用群組控制項

| Group Control Class | 說明 | settings key 前綴範例 |
|--------------------|------|----------------------|
| `Group_Control_Typography` | 字型樣式完整設定 | `{name}_typography`, `{name}_font_size` 等 |
| `Group_Control_Border` | 邊框（type/width/color）| `{name}_border`, `{name}_border_width` 等 |
| `Group_Control_Box_Shadow` | Box Shadow | `{name}_box_shadow` 等 |
| `Group_Control_Text_Shadow` | Text Shadow | `{name}_text_shadow` 等 |
| `Group_Control_Background` | 背景（color/image/gradient）| `{name}_background` 等 |
| `Group_Control_Css_Filter` | CSS Filter（blur/brightness 等）| `{name}_css_filter` 等 |

**Typography settings 範例：**
```json
"title_typography_typography": "custom",
"title_typography_font_family": "Roboto",
"title_typography_font_size": {"size": 24, "unit": "px"},
"title_typography_font_weight": "700",
"title_typography_line_height": {"size": 1.5, "unit": "em"},
"title_typography_letter_spacing": {"size": 0, "unit": "px"}
```

---

## CSS Selectors 機制

Elementor 控制項透過 `selectors` 將值轉換為 CSS：

### {{WRAPPER}} 佔位符

代表該 Widget 實例的容器選擇器（scoped style），確保樣式只套用到此 Widget：
```
{{WRAPPER}} .widget-container → .elementor-123 .elementor-element-1a2b3c4 .widget-container
```

### 各類控制項的 CSS 範本

| 控制項類型 | selectors 範本 |
|-----------|---------------|
| COLOR | `'{{WRAPPER}} .title' => 'color: {{VALUE}};'` |
| SLIDER | `'{{WRAPPER}} .box' => 'width: {{SIZE}}{{UNIT}};'` |
| DIMENSIONS | `'{{WRAPPER}} .box' => 'padding: {{TOP}}{{UNIT}} {{RIGHT}}{{UNIT}} {{BOTTOM}}{{UNIT}} {{LEFT}}{{UNIT}};'` |
| MEDIA | `'{{WRAPPER}} .box' => 'background-image: url({{URL}});'` |
| URL | `'{{WRAPPER}} .link' => 'background-image: url({{URL}});'` |

### 每個 Widget 的 CSS 檔案

Elementor 為每個頁面產生獨立 CSS：
```
/wp-content/uploads/elementor/css/post-{id}.css
```

---

## 控制項區塊結構

控制項以 Section 分組，Section 指定放在哪個 Tab：

```php
$this->start_controls_section('section_id', [
    'label' => 'Section Label',
    'tab'   => Controls_Manager::TAB_STYLE,  // 放在 Style Tab
]);

$this->add_control('control_name', [...]);

$this->end_controls_section();
```

---

## 重要規則

1. **SWITCHER 的值是字串** `"yes"` / `""` (空字串代表 off)，不是 `true`/`false`
2. **SELECT 的值是字串**（選項的 key），如 `"no"`, `"yes"`, `"default"`
3. **SLIDER/DIMENSIONS 的值是物件**，需包含 `unit` 和 `size`（或四邊值）
4. **COLOR 的值是 hex 字串**，如 `"#FF0000"` 或 rgba 字串
5. **MEDIA 的值是物件** `{"id": 123, "url": "..."}`，`id` 為 WP 媒體庫 attachment ID
6. **Responsive control** 的 Desktop 值無後綴，Tablet 加 `_tablet`，Mobile 加 `_mobile`

---

## 常見 Widget settings key 速查

### Heading Widget
```json
{
  "title": "標題文字",
  "header_size": "h2",
  "align": "left|center|right",
  "title_color": "#333333",
  "typography_typography": "custom",
  "typography_font_size": {"size": 36, "unit": "px"},
  "typography_font_weight": "700"
}
```

### Button Widget
```json
{
  "text": "按鈕文字",
  "link": {"url": "https://...", "is_external": false, "nofollow": false},
  "align": "left|center|right",
  "size": "xs|sm|md|lg|xl",
  "button_text_color": "#ffffff",
  "background_color": "#333333",
  "border_radius": {"top": "4", "right": "4", "bottom": "4", "left": "4", "unit": "px", "isLinked": true}
}
```

### Image Widget
```json
{
  "image": {"id": 123, "url": "https://..."},
  "image_size": "full|large|medium|thumbnail",
  "align": "left|center|right",
  "link_to": "none|file|custom",
  "width": {"size": 100, "unit": "%"}
}
```

### Text Editor Widget
```json
{
  "editor": "<p>HTML 內容</p>",
  "align": "left|center|right"
}
```

---

*文件版本：2026-02-22 | 資料來源：Elementor Developers Docs*
