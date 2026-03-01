# Elementor CLI 指令手冊

> 資料來源：https://developers.elementor.com/docs/cli/
> 說明：Elementor 整合 WP-CLI，可透過命令列執行維護任務，不需要瀏覽器。

---

## 基本語法

```bash
wp elementor <command> [--argument]
wp elementor-pro <command> [--argument]
```

查詢所有指令：
```bash
wp help elementor
wp help elementor-pro
wp help elementor <command>
```

---

## 可用指令清單

### 系統資訊

```bash
wp elementor system-info
```
顯示 Elementor 系統資訊（版本、環境、PHP、WordPress 等）。

---

### CSS 維護

```bash
wp elementor flush-css
```
清除 Elementor 產生的所有 CSS 快取。當樣式沒有正確套用時使用。

---

### URL 替換

```bash
wp elementor replace-urls <old-url> <new-url>
```
在 Elementor 資料中批次替換 URL，適用於：
- 網域遷移
- HTTP → HTTPS 轉換
- 開發環境 → 正式環境

---

### 資料庫更新

```bash
wp elementor update-db
```
更新 Elementor 資料庫結構，升級 Elementor 版本後應執行。

---

### 媒體庫同步

```bash
wp elementor library sync
wp elementor library connect
wp elementor library disconnect
```

| 指令 | 說明 |
|------|------|
| `sync` | 同步 Elementor 範本庫 |
| `connect` | 連接 Elementor 帳號 |
| `disconnect` | 中斷 Elementor 帳號連線 |

---

### 範本匯入匯出

```bash
wp elementor library import <file.json>
wp elementor library import-dir <directory>
```

匯入 Elementor 範本（.json 格式）：
- `import`：匯入單一 JSON 檔案
- `import-dir`：批次匯入整個目錄的 JSON 檔案

---

### Theme Builder

```bash
wp elementor-pro theme-builder clear-conditions
```
清除所有 Theme Builder 條件設定。

---

### Kit 匯入匯出

```bash
wp elementor kit import <file>
wp elementor kit export
```

| 指令 | 說明 |
|------|------|
| `import` | 匯入 Kit（包含 Global Colors、Fonts、頁面設定等） |
| `export` | 匯出目前 Kit |

> **重點**：Kit 包含全站的 Global Colors、Global Fonts 及主題樣式設定，匯入後可快速套用整套品牌設計。

---

### 實驗性功能

```bash
wp elementor experiments status
wp elementor experiments activate <experiment-name>
wp elementor experiments deactivate <experiment-name>
```

| 指令 | 說明 |
|------|------|
| `status` | 顯示所有實驗性功能的啟用狀態 |
| `activate` | 啟用指定的實驗性功能 |
| `deactivate` | 停用指定的實驗性功能 |

---

### 授權管理（Pro）

```bash
wp elementor-pro license activate <license-key>
wp elementor-pro license deactivate
```

---

## 常用維護流程

### 遷移網站後

```bash
wp elementor replace-urls https://old-domain.com https://new-domain.com
wp elementor flush-css
wp elementor update-db
```

### 更新 Elementor 後

```bash
wp elementor update-db
wp elementor flush-css
```

### 匯入完整設計套件

```bash
wp elementor kit import /path/to/kit.zip
wp elementor flush-css
```

---

*文件版本：2026-02-22 | 資料來源：Elementor Developers Docs*
