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

---

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

Skills must follow this directory structure:

```
.copilot/skills/
└── {repo-name}-patterns/
    ├── SKILL.md           # Main instructions (required)
    ├── reference.md       # Detailed reference docs (optional)
    ├── examples.md        # Usage examples (optional)
    └── scripts/
        └── helper.sh      # Bundled scripts (optional)
```

Only `SKILL.md` is required. Add supporting files when the skill needs detailed reference material, examples, or scripts — reference them from `SKILL.md` so Claude knows when to load them.

---

## SKILL.md Full Specification

### Frontmatter Reference

All frontmatter fields are optional. Only `description` is strongly recommended.

```yaml
---
name: my-skill
description: What this skill does and when to use it
argument-hint: "[issue-number]"
disable-model-invocation: true
user-invocable: false
allowed-tools: Read, Grep, Bash(git *)
model: claude-opus-4-5
context: fork
agent: Explore
hooks:
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "prettier --write $CLAUDE_TOOL_INPUT_PATH"
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Display name. If omitted, uses directory name. Lowercase letters, numbers, hyphens only (max 64 chars). |
| `description` | Recommended | What the skill does and when to use it. Claude uses this to decide when to apply the skill automatically. If omitted, uses the first paragraph of markdown content. |
| `argument-hint` | No | Hint shown during autocomplete. Example: `[issue-number]` or `[filename] [format]`. |
| `disable-model-invocation` | No | `true` = only you can invoke the skill; Claude cannot trigger it automatically. Use for workflows with side effects (deploy, commit, send messages). Default: `false`. |
| `user-invocable` | No | `false` = only Claude can invoke the skill; it won't appear in the `/` menu. Use for background knowledge users shouldn't trigger directly. Default: `true`. |
| `allowed-tools` | No | Tools Claude may use without asking permission when this skill is active. Examples: `Read, Grep`, `Bash(git *)`, `Bash(python *)`. |
| `model` | No | Model to use when this skill is active. Example: `claude-opus-4-5`. |
| `context` | No | Set to `fork` to run the skill in an isolated subagent context (no conversation history). |
| `agent` | No | Which subagent type to use when `context: fork` is set. Options: `Explore`, `Plan`, `general-purpose`, or any custom agent from `.copilot/agents/`. Default: `general-purpose`. |
| `hooks` | No | Lifecycle hooks scoped to this skill. Same format as `hooks.json`. |

### Invocation Control

Two frontmatter fields control who can invoke a skill:

| Frontmatter | You can invoke | Claude can invoke | When loaded into context |
|-------------|---------------|-------------------|--------------------------|
| *(default)* | Yes | Yes | Description always in context; full skill loads when invoked |
| `disable-model-invocation: true` | Yes | No | Description not in context; full skill loads when you invoke |
| `user-invocable: false` | No | Yes | Description always in context; full skill loads when invoked |

**Rule of thumb:**
- Use `disable-model-invocation: true` for actions with side effects (deploy, commit, send notifications)
- Use `user-invocable: false` for background reference knowledge (legacy system context, domain glossaries)

### String Substitutions

Skills support dynamic value injection using these variables:

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill. If not present in the content, arguments are appended as `ARGUMENTS: <value>`. |
| `$ARGUMENTS[N]` | A specific argument by 0-based index. `$ARGUMENTS[0]` = first argument. |
| `$N` | Shorthand for `$ARGUMENTS[N]`. `$0` = first, `$1` = second. |
| `${CLAUDE_SESSION_ID}` | The current session ID. Useful for logging or creating session-specific files. |

**Examples:**

```markdown
---
name: fix-issue
description: Fix a GitHub issue by number
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.
1. Read the issue
2. Implement the fix
3. Write tests
```

Invoking `/fix-issue 123` replaces `$ARGUMENTS` with `123`.

```markdown
---
name: migrate-component
description: Migrate a component between frameworks
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

Invoking `/migrate-component SearchBar React Vue` replaces `$0` → `SearchBar`, `$1` → `React`, `$2` → `Vue`.

```markdown
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

### Dynamic Context Injection

Use the `` !`command` `` syntax to run shell commands before the skill content is sent to Claude. The command output replaces the placeholder inline — Claude receives the rendered result, not the command itself.

```markdown
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request for the team, highlighting key changes and risks.
```

When this skill runs:
1. Each `` !`command` `` executes immediately (before Claude sees anything)
2. Output replaces the placeholder in the skill content
3. Claude receives the fully-rendered prompt with actual data

### Subagent Execution (`context: fork`)

Add `context: fork` to run the skill in an isolated subagent. The skill content becomes the subagent's prompt — it has no access to your conversation history.

```markdown
---
name: deep-research
description: Research a topic thoroughly using codebase exploration
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

When this skill runs:
1. A new isolated context is created
2. The subagent receives the skill content as its task
3. The `agent` field determines the execution environment (model, tools, permissions)
4. Results are summarized and returned to your main conversation

### Supporting Files

Keep `SKILL.md` focused on essentials; use supporting files for detailed reference material only needed on demand.

```
my-skill/
├── SKILL.md           # Main instructions (required)
├── reference.md       # Detailed API docs — loaded when needed
├── examples.md        # Usage examples — loaded when needed
└── scripts/
    └── helper.py      # Script Claude executes, not loads
```

Reference supporting files from `SKILL.md` so Claude knows what they contain:

```markdown
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

**Scripts pattern** — bundle executable scripts to give Claude capabilities beyond a single prompt:

````markdown
---
name: codebase-visualizer
description: Generate an interactive tree visualization of your codebase
allowed-tools: Bash(python *)
---

Run the visualization script from your project root:

```bash
python ~/.copilot/skills/codebase-visualizer/scripts/visualize.py .
```

This generates `codebase-map.html` and opens it in your browser.
````

---

## Skill Content Types

### Reference Content (auto-loaded by Claude)

Adds knowledge Claude applies to your current work. Runs inline so Claude can use it alongside conversation context.

```markdown
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats `{ success, data, error, meta }`
- Include request validation on all inputs
```

### Task Content (manually invoked)

Step-by-step instructions for a specific action. Add `disable-model-invocation: true` to prevent Claude from triggering it automatically.

```markdown
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy $ARGUMENTS to production:
1. Run the full test suite
2. Build the application
3. Push to the deployment target
4. Verify the deployment succeeded
```

---

## Generated SKILL.md Template

Output format for the generated skill:

```markdown
---
name: {repo-name}-patterns
description: Coding patterns extracted from {repo-name} git history ({count} commits analyzed)
---

# {Repo Name} Patterns

## Commit Conventions
{detected commit message patterns, e.g. conventional commits}

## Code Architecture
{detected folder structure and organization}

## Workflows
{detected repeating file change patterns}

## Testing Patterns
{detected test conventions — framework, file locations, coverage targets}
```

---

## Example Output

Running `/skill-create` on a TypeScript project produces `.copilot/skills/my-app-patterns/SKILL.md`:

```markdown
---
name: my-app-patterns
description: Coding patterns from my-app — conventional commits, React component structure, Vitest testing
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

---

## Skill Locations

| Location | Path | Applies to |
|----------|------|------------|
| Enterprise | Managed settings | All users in the organization |
| Personal | `~/.copilot/skills/<skill-name>/SKILL.md` | All your projects |
| Project | `.copilot/skills/<skill-name>/SKILL.md` | This project only |
| Plugin | `<plugin>/skills/<skill-name>/SKILL.md` | Where plugin is enabled |

When skills share the same name across levels, priority order is: **enterprise > personal > project**.

Skills in `.copilot/skills/` within directories added via `--add-dir` are also loaded automatically.

---

## Controlling Claude's Skill Access

**Disable all skills** — add `Skill` to deny rules in `/permissions`.

**Allow or deny specific skills:**

```
# Allow only specific skills
Skill(commit)
Skill(review-pr *)

# Deny specific skills
Skill(deploy *)
```

Permission syntax: `Skill(name)` for exact match; `Skill(name *)` for prefix match with any arguments.

---

## Troubleshooting

### Skill not triggering automatically

1. Check the `description` includes keywords users would naturally say
2. Run `What skills are available?` to verify the skill is loaded
3. Try rephrasing your request to match the description more closely
4. Invoke it directly with `/skill-name` as a fallback

### Skill triggers too often

1. Make the `description` more specific
2. Add `disable-model-invocation: true` to require manual invocation only

### Claude doesn't see all my skills

Skill descriptions are loaded into context with a budget of ~2% of the context window (fallback: 16,000 chars). Run `/context` to check for a warning about excluded skills. Override the limit with the `SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable.

---

## Related Commands

- `/learn` — Extract patterns from the current session
- `/skill-creator` — Interactive skill creation wizard

---

*Part of [Everything Copilot CLI](https://github.com/j7-dev/everything-github-copilot)*
