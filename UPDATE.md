# 發布新版本教學

本文說明如何發布 `j7-dev/everything-github-copilot` plugin 的新版本，讓使用者可透過 `copilot plugin update` 取得最新內容。

---

## ⚠️ Breaking Change 警告（v2.0.1）

**Plugin 名稱已從 `everything-copilot-cli` 改為 `j7-dev/everything-github-copilot`**

舊版安裝者請依下列步驟重新安裝：

```bash
copilot plugin remove everything-copilot-cli
copilot plugin install j7-dev/everything-github-copilot
```

---

## 發布新版本步驟

### 1. 確認在正確的分支

```bash
git checkout master
git pull origin master
```

### 2. 更新版本號（兩個檔案都要改）

#### `plugin.json`（根目錄）

```json
{
  "version": "X.Y.Z"
}
```

#### `.github/plugin/marketplace.json`

```json
{
  "plugins": [
    {
      "version": "X.Y.Z"
    }
  ]
}
```

> ⚠️ **兩個檔案的版本號必須一致**，否則 `copilot plugin update` 行為不可預測。

### 3. Commit 並 Push

```bash
git add plugin.json .github/plugin/marketplace.json
git commit -m "chore: bump version to X.Y.Z"
git push origin master
```

### 4. 驗證更新機制

Push 後稍等 30 秒，再執行：

```bash
copilot plugin update j7-dev/everything-github-copilot
```

預期輸出應為：

```
Plugin "j7-dev/everything-github-copilot" updated successfully (vX.Y.Z).
```

若還是顯示 "already at latest"，請確認：
- GitHub 上的 `.github/plugin/marketplace.json` 版本是否已更新（可直接在 GitHub 網頁確認）
- 本機快取問題：等待 1–2 分鐘再試

---

## 版本號規範（SemVer）

格式：`MAJOR.MINOR.PATCH`

| 類型 | 說明 | 範例 |
|------|------|------|
| PATCH | 小修正、新增 skill/rule 等 | 2.0.0 → 2.0.1 |
| MINOR | 新增 agent、command 或重大 skill | 2.0.0 → 2.1.0 |
| MAJOR | 破壞性變更（改名、結構重組） | 2.0.0 → 3.0.0 |

---

## 關鍵檔案說明

| 檔案 | 用途 |
|------|------|
| `plugin.json` | Plugin 主定義（name、version、paths） |
| `.github/plugin/marketplace.json` | `copilot plugin update` 讀取此檔比對版本 |

---

## 常見問題

**Q: 為什麼改了 `plugin.json` 但 update 還是顯示 already at latest？**

A: 因為 `copilot plugin update` 讀的是 **GitHub 上的** `.github/plugin/marketplace.json`，不是 `plugin.json`。請確認兩個檔案都已 push 到 GitHub。

**Q: 使用者安裝後 update 指令是什麼？**

```bash
copilot plugin update j7-dev/everything-github-copilot
```

**Q: 如何讓使用者知道要重裝？**

在 Release Notes 或 README 說明 Breaking Change，並提供上方的重裝指令。
