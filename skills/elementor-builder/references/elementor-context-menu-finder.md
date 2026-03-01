# Elementor Context Menu 與 Finder

> 資料來源：https://developers.elementor.com/docs/context-menu/
>           https://developers.elementor.com/docs/finder/
> 說明：編輯器中右鍵選單與搜尋跳轉工具的功能說明。

---

## Context Menu（右鍵選單）

### 什麼是 Context Menu

在 Elementor **預覽區**右鍵點擊元素時彈出的操作選單。

- 根據點擊的**位置**或**元素類型**，顯示不同的可用操作
- 這就是「context」（情境）選單的含義

### Context Menu 的結構

```
Context Menu
  └── Group（分組，用分隔線區隔）
        └── Action（操作項目，JS callback）
```

- **Types（類型）**：依據選取的元素類型（section / column / container / widget）有不同的選單
- **Groups（分組）**：每個選單由多個分組組成，分組之間有視覺分隔線
- **Actions（操作）**：每個分組內的操作項目，點擊後執行 JS callback

### 常見內建操作

右鍵選單通常包含以下類型的操作：
- Edit（編輯）
- Duplicate（複製）
- Copy / Paste
- Delete（刪除）
- Save as Template（儲存為範本）
- Navigator（定位到導覽器）

---

## Finder（快速搜尋跳轉）

### 什麼是 Finder

Finder 是一個**彈出式搜尋列**，讓使用者快速跳轉到網站的各個頁面和設定。

**開啟方式**：通常透過編輯器選單或快捷鍵。

### Finder 功能

- 建立新文章/頁面
- 編輯其他頁面
- 跳轉到不同設定頁面
- 搜尋範圍：分類（Categories）→ 項目（Items）

### Finder 結構

```
Finder
  └── Category（分類）
        └── Item（項目）
              ├── label（顯示文字）
              ├── link（目標連結）
              └── keywords（搜尋關鍵字）
```

搜尋時，Finder 依據 keywords 篩選項目清單。

---

## 對 MCP 操作的意義

這兩個功能對使用 Elementor MCP 的工作流程影響不大（MCP 直接操作 JSON 資料），但了解它們有助於：

1. **Context Menu**：理解編輯器中元素的操作維度（copy/paste/duplicate），與 MCP 的 `duplicate_element` 功能對應
2. **Finder**：理解 WordPress 後台的快速導覽機制，可作為定位頁面的輔助工具

---

*文件版本：2026-02-22 | 資料來源：Elementor Developers Docs*
