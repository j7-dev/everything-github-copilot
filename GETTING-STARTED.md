# Getting Started with Everything Copilot CLI

A production-ready **GitHub Copilot CLI plugin** with 13 specialized agents, 50+ skills, 26 slash commands, and automated hooks for software development.

## Prerequisites

- [GitHub Copilot](https://github.com/features/copilot) subscription
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli) installed and authenticated
- Node.js 18+ (for hook scripts)

## Installation

### From GitHub (recommended)

```bash
copilot plugin install your-org/everything-copilot-cli
```

### From local directory

```bash
git clone https://github.com/your-org/everything-copilot-cli.git
cd everything-copilot-cli
copilot plugin install ./
```

### Verify installation

```bash
copilot plugin list
```

You should see `everything-copilot-cli` in the list.

## Plugin Structure

```
plugin.json               — Plugin manifest
agents/                   — 13 specialized agents (.agent.md)
skills/                   — 50+ workflow skills
commands/                 — 26 slash commands
hooks/hooks.json          — Session and tool lifecycle hooks
.github/                  — Copilot instructions (auto-applied)
  instructions/            — Path-specific instructions
scripts/                  — Node.js utilities for hooks
mcp-configs/              — MCP server configurations
```

## Using Agents

Agents are specialized AI assistants you can invoke by name. Use `@agent-name` syntax in Copilot CLI:

| Agent | Trigger With | Purpose |
|-------|-------------|---------|
| `planner` | `@planner` | Implementation planning, risk assessment |
| `architect` | `@architect` | System design, scalability decisions |
| `tdd-guide` | `@tdd-guide` | Test-driven development workflow |
| `code-reviewer` | `@code-reviewer` | Code quality and best practices |
| `security-reviewer` | `@security-reviewer` | Vulnerability detection |
| `build-error-resolver` | `@build-error-resolver` | Fix build/type errors |
| `e2e-runner` | `@e2e-runner` | Playwright E2E test generation |
| `refactor-cleaner` | `@refactor-cleaner` | Dead code removal |
| `doc-updater` | `@doc-updater` | Documentation updates |
| `go-reviewer` | `@go-reviewer` | Go code review |
| `go-build-resolver` | `@go-build-resolver` | Go build error fixing |
| `database-reviewer` | `@database-reviewer` | PostgreSQL/Supabase optimization |
| `python-reviewer` | `@python-reviewer` | Python code review |

**Example:**
```
@planner I need to add OAuth2 authentication to this Express app
```

## Using Slash Commands

Slash commands run predefined workflows. Type `/` to see all available commands:

| Command | Description |
|---------|-------------|
| `/tdd` | Start test-driven development workflow |
| `/plan` | Create implementation plan before writing code |
| `/e2e` | Generate and run E2E tests with Playwright |
| `/code-review` | Run quality review on current changes |
| `/build-fix` | Diagnose and fix build errors |
| `/learn` | Extract patterns from the current session |
| `/skill-create` | Generate a new skill from git history |
| `/checkpoint` | Save a named checkpoint to git |
| `/setup-pm` | Configure package manager detection |

**Example:**
```
/plan Add payment processing with Stripe to the checkout flow
```

## Using Skills

Skills provide domain knowledge that is automatically loaded based on context. They live in `skills/` and are referenced by agents and commands.

Key skills available:
- `coding-standards` — Universal TypeScript/JS best practices
- `tdd-workflow` — TDD methodology with 80%+ coverage requirement  
- `api-design` — REST API patterns and conventions
- `security-review` — Security checklist and patterns
- `e2e-testing` — Playwright configuration and patterns
- `frontend-patterns` — React/Next.js performance patterns
- `backend-patterns` — Node.js/Express architecture patterns

## Custom Instructions (Auto-Applied)

The `.github/` directory contains instructions that Copilot applies automatically:

- `.github/copilot-instructions.md` — Global rules applied to all files
- `.github/instructions/typescript.instructions.md` — Applied to `**/*.ts,**/*.tsx`
- `.github/instructions/go.instructions.md` — Applied to `**/*.go`
- `.github/instructions/python.instructions.md` — Applied to `**/*.py`
- `.github/instructions/swift.instructions.md` — Applied to `**/*.swift`

These are loaded automatically — no configuration needed.

## Hooks

Hooks run automatically on session events. Configured in `hooks/hooks.json`:

| Event | What Happens |
|-------|-------------|
| `sessionStart` | Loads context, checks git status, restores saved session |
| `sessionEnd` | Saves session state, generates summary |
| `preToolUse` | Validates tool calls (e.g., warns on large file writes) |
| `postToolUse` | Runs post-processing (e.g., lint after edits, auto-stage files) |

> **Note:** Hook scripts are located in `scripts/hooks/`. When the plugin is installed, scripts run from the plugin's installation directory. If you encounter path issues, verify the plugin path with `copilot plugin list`.

## MCP Server Configurations

Pre-configured MCP server setups are in `mcp-configs/`. Copy the desired config to your project's `.mcp.json`:

```bash
# Example: use the GitHub MCP config
cp mcp-configs/github.json .mcp.json
```

Available configs include GitHub, filesystem, memory, sequential-thinking, and more.

## Updating the Plugin

```bash
copilot plugin update everything-copilot-cli
```

> **Note:** Updates require a plugin reinstall to take effect. Any local modifications to the plugin directory will be overwritten.

## Troubleshooting

**Plugin not loading:**
```bash
copilot plugin list        # verify installation
copilot plugin install ./  # reinstall from local
```

**Hooks not running:**
- Check `hooks/hooks.json` syntax is valid JSON
- Ensure Node.js 18+ is installed: `node --version`
- For Windows: ensure PowerShell 7+ is available

**Agents not responding:**
- Agent files must use `.agent.md` extension
- Frontmatter must have `name`, `description`, and `tools` fields
- No `model:` field is allowed (Copilot CLI controls model selection)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add new agents, skills, and commands.

File naming conventions:
- Agents: `agent-name.agent.md`
- Skills: `skill-name.md` (inside `skills/skill-name/`)
- Commands: `command-name.md`
