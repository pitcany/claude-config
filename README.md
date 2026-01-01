# Claude Code Configuration

Production-hardened configuration for Claude Code, optimized for full-stack development with strong emphasis on data science, statistics, and code quality.

## Philosophy

This configuration embodies a **curated maximalist** approach:
- Comprehensive plugin coverage across workflows, but deliberately selective
- Security-first with explicit permission denials
- Enhanced cognitive capabilities (opusplan + always thinking)
- Organized for discoverability and maintenance
- Git-tracked for reproducibility across machines

## Directory Structure

### Core Configuration
- `settings.json` - Main configuration (model, permissions, plugins)
- `.gitignore` - Excludes runtime/transient data from version control

### Custom Components (Version Controlled)

#### `agents/`
Specialized agents organized by domain:
- `01-core-development/` - Frontend, backend, fullstack, API, UI designers
- `02-language-specialists/` - Language-specific development agents
- `04-quality-security/` - Code review, testing, security agents
- `05-data-ai/` - Data science, ML, analytics agents
- `06-developer-experience/` - Workflow optimization agents

Plus standalone agents for specific workflows (build fixing, git operations, testing).

#### `skills/`
Custom skills focused on analytical rigor:
- Data analysis workflows (pandas, NumPy, visualization)
- Statistical validation (assumptions, causal inference, experiment design)
- Domain-specific (PitcanAnalytics stack, PostgreSQL operations)
- Code quality (POM ordering)

#### `instructions/`
Global instructions that shape Claude's behavior:
- `llm-code-style.md` - Code commenting and documentation philosophy
- `llm-git-commits.md` - Commit message standards
- `conversation.md` - Interaction patterns
- `code-style.md` - General coding standards
- `build-commands.md`, `tests.md`, `tool-use.md` - Workflow guidelines

#### `commands/`
Custom CLI commands and shortcuts

### Runtime Data (Not Version Controlled)
- `debug/` - Debug logs and traces
- `file-history/` - File change history
- `history.jsonl` - Conversation history
- `plugins/` - Downloaded plugin data
- `projects/` - Project-specific data
- `session-env/` - Session environment variables
- `shell-snapshots/` - Shell command snapshots
- `todos/` - Todo list state
- `statsig/`, `telemetry/` - Analytics data

## Key Configuration Choices

### Model & Capabilities
- **Model**: `opusplan` - Best reasoning for complex tasks
- **Always Thinking**: Enabled - Enhanced reasoning visibility
- **Python Environment**: Unbuffered output for real-time feedback

### Security Permissions
Explicit denials protect sensitive data:
```
- .env files (all patterns)
- secrets/ directories
- credentials files
- Destructive bash commands (rm -rf)
```

Default mode: `acceptEdits` - Streamlined workflow for trusted operations

### Plugin Ecosystem

**Enabled Workflows** (selective):
- Full-stack development (Python, TypeScript/JavaScript, systems programming)
- Data & ML operations (MLOps, data engineering, LLM apps)
- Quality & security (code review, testing, TDD)
- Documentation generation
- Git/PR workflows
- Specialized: Payment processing, Julia, shell scripting

**Deliberately Disabled** (workflow doesn't match):
- Kubernetes/cloud infrastructure operations
- CI/CD automation (handled externally)
- Incident response/observability
- Team collaboration features
- Marketing/sales automation
- Framework migrations

**Notable Plugins**:
- Superpowers suite (memory, chrome, lab)
- Document skills (DOCX, PDF, PPTX, XLSX)
- MCP builder, skill creator, artifacts builder
- Playwright, Notion, Supabase, Greptile integrations

## Maintenance

### Sync to New Machine
```bash
# Clone this repository
git clone <repo-url> ~/.claude

# Claude Code will populate runtime directories automatically
```

### Update Tracking
```bash
# Check what changed
git status

# Commit configuration changes
git add settings.json agents/ skills/ instructions/
git commit -m "Update: <description>"
```

### Cleanup
Automatic cleanup runs every 14 days (`cleanupPeriodDays: 14`)

Manual cleanup if needed:
```bash
# Runtime data (safe to delete)
rm -rf debug/* session-env/* shell-snapshots/* todos/*
```

## Customization Notes

### Agent Organization
Agents are numbered (01-, 02-, etc.) to create logical grouping. This helps with:
- Discovery when browsing
- Understanding which domain to use for specific tasks
- Maintaining clear separation of concerns

### Custom Skills Philosophy
Skills focus on **analytical rigor** - reflecting heavy data science/statistics work:
- Causal inference validation
- Experiment design optimization
- Statistical assumption auditing
- Decision-readiness frameworks

This complements general development skills with domain expertise.

### Code Style Enforcement
The `llm-code-style.md` instruction enforces minimal comments and no documentation creation unless explicitly requested. This keeps codebases clean and self-documenting.

## Git Strategy

**Version controlled**:
- Configuration files
- Custom agents, skills, instructions, commands
- This README

**Not version controlled** (.gitignore):
- Runtime/transient data
- Session state
- Conversation history
- Downloaded plugins
- OS files

This allows configuration portability while keeping the repo clean.

## Links

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Superpowers Marketplace](https://superpowers.fun)
- [Awesome Claude Skills](https://github.com/iankowalski/awesome-claude-skills)

---

**Last Updated**: 2026-01-01
**Model**: claude-sonnet-4-5-20250929 (opusplan)
