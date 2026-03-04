---
name: skill-create
description: Analyze local git history to extract coding patterns and generate SKILL.md files for Copilot CLI.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /skill-create - Skill Generation from Git History

Analyze your repository's git history to extract coding patterns and generate `SKILL.md` files that teach Copilot your team's practices.

## Usage

```bash
/skill-create                    # Analyze current repo (default: 200 commits)
/skill-create --commits 100      # Analyze last 100 commits
/skill-create --output ./skills  # Custom output directory (default: .copilot/skills/)
```

## What It Does

1. **Parses Git History** — Analyzes commits, file changes, and patterns
2. **Detects Patterns** — Identifies recurring workflows and conventions
3. **Generates SKILL.md** — Creates valid Copilot CLI skill files in the correct directory structure

## Analysis Steps

### Step 1: Gather Git Data

```bash
# Get recent commits with file changes
git log --oneline -n ${COMMITS:-200} --name-only --pretty=format:"%H|%s|%ad" --date=short

# Get commit frequency by file
git log --oneline -n 200 --name-only | grep -v "^$" | grep -v "^[a-f0-9]" | sort | uniq -c | sort -rn | head -20

# Get commit message patterns
git log --oneline -n 200 | cut -d' ' -f2- | head -50
```

### Step 2: Detect Patterns

| Pattern | Detection Method |
|---------|-----------------|
| **Commit conventions** | Regex on commit messages (feat:, fix:, chore:) |
| **File co-changes** | Files that always change together |
| **Workflow sequences** | Repeated file change patterns |
| **Architecture** | Folder structure and naming conventions |
| **Testing patterns** | Test file locations, naming, coverage |

### Step 3: Generate Skill Directory

Skills must follow the directory structure: `<output>/<skill-name>/SKILL.md`

```
.copilot/skills/
└── {repo-name}-patterns/
    └── SKILL.md
```

Output `SKILL.md` format (following the [Agent Skills](https://agentskills.io) open standard):

```markdown
---
name: {repo-name}-patterns
description: Coding patterns extracted from {repo-name} git history ({count} commits analyzed)
---

# {Repo Name} Patterns

## Commit Conventions
{detected commit message patterns}

## Code Architecture
{detected folder structure and organization}

## Workflows
{detected repeating file change patterns}

## Testing Patterns
{detected test conventions}
```

### Frontmatter Fields (Official Spec)

| Field | Description |
|-------|-------------|
| `name` | Skill name — lowercase letters, numbers, hyphens (max 64 chars) |
| `description` | What the skill does; used by Claude to decide when to apply it |
| `disable-model-invocation` | Set `true` to prevent auto-loading; use for manual-trigger workflows |
| `allowed-tools` | Tools Claude can use without asking when this skill is active |
| `context: fork` | Run in a forked subagent context |

## Example Output

Running `/skill-create` on a TypeScript project produces `.copilot/skills/my-app-patterns/SKILL.md`:

```markdown
---
name: my-app-patterns
description: Coding patterns from my-app repository — conventional commits, component structure, Vitest testing
---

# My App Patterns

## Commit Conventions

This project uses **conventional commits**:
- `feat:` — New features
- `fix:` — Bug fixes
- `chore:` — Maintenance tasks
- `docs:` — Documentation updates

## Code Architecture

src/
├── components/     # React components (PascalCase.tsx)
├── hooks/          # Custom hooks (use*.ts)
├── utils/          # Utility functions
├── types/          # TypeScript type definitions
└── services/       # API and external services

## Workflows

### Adding a New Component
1. Create `src/components/ComponentName.tsx`
2. Add tests in `src/components/__tests__/ComponentName.test.tsx`
3. Export from `src/components/index.ts`

### Database Migration
1. Modify `src/db/schema.ts`
2. Run `pnpm db:generate`
3. Run `pnpm db:migrate`

## Testing Patterns

- Test files: `__tests__/` directories or `.test.ts` suffix
- Coverage target: 80%+
- Framework: Vitest
```

## Skill Locations

After generation, you can install skills to:

| Location | Path | Scope |
|----------|------|-------|
| Project | `.copilot/skills/<skill-name>/SKILL.md` | Current project only |
| Personal | `~/.copilot/skills/<skill-name>/SKILL.md` | All your projects |

## Related Commands

- `/learn` — Extract patterns from the current session
- `/skill-creator` — Interactive skill creation wizard

---

*Part of [Everything Copilot CLI](https://github.com/j7-dev/everything-github-copilot)*
