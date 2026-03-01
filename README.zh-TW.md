[English](README.md) | [简体中文](README.zh-CN.md) | **繁體中文**

# Everything Copilot CLI

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Shell](https://img.shields.io/badge/-Shell-4EAA25?logo=gnu-bash&logoColor=white)
![TypeScript](https://img.shields.io/badge/-TypeScript-3178C6?logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/-Python-3776AB?logo=python&logoColor=white)
![Go](https://img.shields.io/badge/-Go-00ADD8?logo=go&logoColor=white)
![Markdown](https://img.shields.io/badge/-Markdown-000000?logo=markdown&logoColor=white)

> **一個生產級的 GitHub Copilot CLI 外掛** — 13 個專業代理、50+ 技能、26 個斜線命令，以及自動化鉤子，專為軟體開發打造。

經過實戰驗證的軟體開發工作流程：規劃、TDD、安全審查、E2E 測試、程式碼審查等。為日常真實產品開發而生。

---

## 🚀 快速開始

```bash
# 從 GitHub 安裝
copilot plugin install your-org/everything-copilot-cli

# 或從本地克隆安裝
git clone https://github.com/your-org/everything-copilot-cli.git
cd everything-copilot-cli
copilot plugin install ./

# 驗證安裝
copilot plugin list
```

→ **完整安裝指南：** [GETTING-STARTED.md](GETTING-STARTED.md)

---

## 📦 內容一覽

```
plugin.json               — 外掛清單（進入點）
agents/                   — 13 個專業子代理（.agent.md）
skills/                   — 50+ 工作流技能與領域知識
commands/                 — 26 個斜線命令
hooks/hooks.json          — 會話與工具生命週期自動化
.github/                  — Copilot 指示（依語言自動套用）
scripts/                  — 跨平台 Node.js 鉤子工具
mcp-configs/              — 14 個 MCP 伺服器設定
```

---

## 🤖 代理

在 Copilot CLI 中使用 `@agent-name` 呼叫：

| 代理 | 用途 |
|------|------|
| `@planner` | 功能實作規劃、風險評估 |
| `@architect` | 系統設計、可擴展性決策 |
| `@tdd-guide` | 測試驅動開發（RED → GREEN → REFACTOR） |
| `@code-reviewer` | 程式碼品質、可維護性 |
| `@security-reviewer` | 漏洞偵測、OWASP 合規 |
| `@build-error-resolver` | 修復建置 / TypeScript / 編譯器錯誤 |
| `@e2e-runner` | Playwright E2E 測試產生 |
| `@refactor-cleaner` | 移除無用程式碼 |
| `@doc-updater` | 文件同步 |
| `@go-reviewer` | Go 慣用寫法審查 |
| `@go-build-resolver` | Go 建置錯誤修復 |
| `@database-reviewer` | PostgreSQL / Supabase 最佳化 |
| `@python-reviewer` | Python 最佳實踐審查 |

---

## ⚡ 斜線命令

| 命令 | 說明 |
|------|------|
| `/tdd` | 測試驅動開發工作流 |
| `/plan` | 在寫程式前建立實作計畫 |
| `/e2e` | 產生並執行 Playwright E2E 測試 |
| `/code-review` | 品質與安全審查 |
| `/build-fix` | 診斷並修復建置錯誤 |
| `/learn` | 從目前會話中擷取模式 |
| `/skill-create` | 從 git 歷史產生技能 |
| `/checkpoint` | 將命名檢查點儲存至 git |
| `/setup-pm` | 設定套件管理器偵測 |
| `/security-scan` | 執行安全漏洞掃描 |
| `/instinct-import` | 從檔案 / URL 匯入已學習的模式 |
| `/instinct-export` | 匯出個人程式碼直覺 |
| `/evolve` | 將直覺演化為新的命令 / 技能 |
| … 更多 | 詳見 `commands/` 目錄 |

---

## 🔧 技能

技能可自動被代理和命令使用。重點項目：

| 技能 | 領域 |
|------|------|
| `coding-standards` | 通用 TypeScript / JS 最佳實踐 |
| `tdd-workflow` | TDD 搭配 80%+ 覆蓋率要求 |
| `api-design` | REST API 模式、狀態碼、分頁 |
| `security-review` | 安全漏洞檢查清單與模式 |
| `e2e-testing` | Playwright Page Object Model、CI/CD 整合 |
| `frontend-patterns` | React / Next.js 效能最佳化 |
| `backend-patterns` | Node.js / Express 架構 |
| `frontend-slides` | HTML 簡報建構器 |
| `market-research` | 附來源的競爭分析研究 |
| `article-writing` | 風格一致的長篇內容撰寫 |

---

## 🪝 鉤子

`hooks/hooks.json` 中的自動化生命週期鉤子：

| 事件 | 動作 |
|------|------|
| `sessionStart` | 載入上下文、檢查 git 狀態、恢復會話 |
| `sessionEnd` | 儲存會話狀態、產生摘要 |
| `preToolUse` | 驗證工具呼叫、警告高風險操作 |
| `postToolUse` | 編輯後自動 lint、自動暫存 git 檔案 |

---

## 📋 自訂指示

依語言自動套用的規則：

- `.github/copilot-instructions.md` — 全域規則
- `.github/instructions/typescript.instructions.md` — TypeScript / TSX 檔案
- `.github/instructions/go.instructions.md` — Go 檔案
- `.github/instructions/python.instructions.md` — Python 檔案
- `.github/instructions/swift.instructions.md` — Swift 檔案

---

## 🌐 跨平台支援

完整支援：**Windows (PowerShell)**、**macOS**、**Linux (Bash)**。

所有鉤子腳本使用 Node.js 以確保最大相容性。

---

## 📖 文件

- [GETTING-STARTED.md](GETTING-STARTED.md) — 安裝與使用指南
- [CONTRIBUTING.md](CONTRIBUTING.md) — 如何新增代理、技能、命令
- [AGENTS.md](AGENTS.md) — 代理協作指引

---

## 授權條款

MIT — 詳見 [LICENSE](LICENSE)
