# Everything Copilot CLI

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Shell](https://img.shields.io/badge/-Shell-4EAA25?logo=gnu-bash&logoColor=white)
![TypeScript](https://img.shields.io/badge/-TypeScript-3178C6?logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/-Python-3776AB?logo=python&logoColor=white)
![Go](https://img.shields.io/badge/-Go-00ADD8?logo=go&logoColor=white)
![Markdown](https://img.shields.io/badge/-Markdown-000000?logo=markdown&logoColor=white)

> **A production-ready GitHub Copilot CLI plugin** — 13 specialized agents, 50+ skills, 26 slash commands, and automated hooks for software development.

Battle-tested workflows for software development: planning, TDD, security review, E2E testing, code review, and more. Built for daily use on real products.

---

## 🚀 Quick Start

```bash
# Install from GitHub
copilot plugin install j7-dev/everything-github-copilot

# OR install from local clone
git clone https://github.com/j7-dev/everything-github-copilot.git
cd everything-github-copilot
copilot plugin install ./

# Verify installation
copilot plugin list
```

→ **Full setup guide:** [GETTING-STARTED.md](GETTING-STARTED.md)

---

## 📦 What's Inside

```
plugin.json               — Plugin manifest (entry point)
agents/                   — 13 specialized subagents (.agent.md)
skills/                   — 50+ workflow skills and domain knowledge
commands/                 — 26 slash commands
hooks/hooks.json          — Session and tool lifecycle automations
.github/                  — Copilot instructions (auto-applied by language)
scripts/                  — Cross-platform Node.js hook utilities
mcp-configs/              — 14 MCP server configurations
```

---

## 🤖 Agents

Invoke with `@agent-name` in Copilot CLI:

| Agent | Purpose |
|-------|---------|
| `@planner` | Feature implementation planning, risk assessment |
| `@architect` | System design, scalability decisions |
| `@tdd-guide` | Test-driven development (RED → GREEN → REFACTOR) |
| `@code-reviewer` | Code quality, maintainability |
| `@security-reviewer` | Vulnerability detection, OWASP compliance |
| `@build-error-resolver` | Fix build/TypeScript/compiler errors |
| `@e2e-runner` | Playwright E2E test generation |
| `@refactor-cleaner` | Dead code removal |
| `@doc-updater` | Documentation sync |
| `@go-reviewer` | Go idiomatic code review |
| `@go-build-resolver` | Go build error resolution |
| `@database-reviewer` | PostgreSQL/Supabase optimization |
| `@python-reviewer` | Python best practices review |

---

## ⚡ Slash Commands

| Command | Description |
|---------|-------------|
| `/tdd` | Test-driven development workflow |
| `/plan` | Create implementation plan before coding |
| `/e2e` | Generate and run Playwright E2E tests |
| `/code-review` | Quality and security review |
| `/build-fix` | Diagnose and fix build errors |
| `/learn` | Extract patterns from current session |
| `/skill-create` | Generate skill from git history |
| `/checkpoint` | Save named checkpoint to git |
| `/setup-pm` | Configure package manager detection |
| `/security-scan` | Run security vulnerability scan |
| `/instinct-import` | Import learned patterns from file/URL |
| `/instinct-export` | Export personal coding instincts |
| `/evolve` | Evolve instincts into new commands/skills |
| … and more | See `commands/` directory |

---

## 🔧 Skills

Skills are automatically available to agents and commands. Highlights:

| Skill | Domain |
|-------|--------|
| `coding-standards` | Universal TypeScript/JS best practices |
| `tdd-workflow` | TDD with 80%+ coverage requirement |
| `api-design` | REST API patterns, status codes, pagination |
| `security-review` | Vulnerability checklist and patterns |
| `e2e-testing` | Playwright Page Object Model, CI/CD integration |
| `frontend-patterns` | React/Next.js performance optimization |
| `backend-patterns` | Node.js/Express architecture |
| `frontend-slides` | HTML presentation builder |
| `market-research` | Source-attributed competitive research |
| `article-writing` | Long-form content in consistent voice |

---

## 🪝 Hooks

Automated lifecycle hooks in `hooks/hooks.json`:

| Event | Action |
|-------|--------|
| `sessionStart` | Load context, check git status, restore session |
| `sessionEnd` | Save session state, generate summary |
| `preToolUse` | Validate tool calls, warn on risky operations |
| `postToolUse` | Auto-lint after edits, auto-stage git files |

---

## 📋 Custom Instructions

Language-specific rules auto-applied by Copilot:

- `.github/copilot-instructions.md` — Global rules
- `.github/instructions/typescript.instructions.md` — TypeScript/TSX files
- `.github/instructions/go.instructions.md` — Go files
- `.github/instructions/python.instructions.md` — Python files
- `.github/instructions/swift.instructions.md` — Swift files

---

## 🌐 Cross-Platform

Fully supported: **Windows (PowerShell)**, **macOS**, **Linux (Bash)**.

All hook scripts use Node.js for maximum compatibility.

---

## 📖 Documentation

- [GETTING-STARTED.md](GETTING-STARTED.md) — Installation and usage guide
- [CONTRIBUTING.md](CONTRIBUTING.md) — How to add agents, skills, commands
- [AGENTS.md](AGENTS.md) — Agent orchestration guidelines

---

## License

MIT — see [LICENSE](LICENSE)
