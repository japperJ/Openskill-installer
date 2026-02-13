---
name: AGENTS.md
description: Agent workspace configuration and coding guidelines
---

# AGENTS.md

This is an **AI Agent Workspace** - a meta-project with agent definitions in `.github/agents/`. No application source code exists here; agents spawn projects in subdirectories.

---

## Build / Lint / Test Commands

### Common Commands (for spawned projects)

```bash
# JavaScript/TypeScript
npm install
npm run build
npm run dev
npm test                        # Run all tests
npm test -- --testPathPattern=<file>  # Run single test
npx playwright test             # Browser tests

# Python
pip install -r requirements.txt
python -m pytest                          # All tests
python -m pytest tests/test_file.py::test_name  # Single test

# Linting
npm run lint    # ESLint
ruff check .    # Python
```

---

## Code Style Guidelines

### General Principles

| Principle | Description |
|-----------|-------------|
| Structure | Consistent layout, group by feature not type |
| Architecture | Flat/explicit over nested; no premature abstraction |
| Functions | Linear control flow, small/medium, prefer pure |
| Naming | Descriptive but simple (`getUserById` not `fetchUserDataFromDatabaseById`) |
| Comments | Explain invariants/WHY, never WHAT |
| Regenerability | Any file fully rewritable from interface contract |

### Error Handling

- Explicit error handling - no swallowed errors
- Structured logging with context, never `console.log("here")`
- Errors carry context for debugging without reproduction
- Fail loud and early - don't silently skip failures

### Imports & Dependencies

- Direct dependencies over DI (unless project uses DI)
- Use platform conventions - don't wrap stdlib unless adding value
- Explicit imports - avoid wildcard imports

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userName` |
| Functions | camelCase + verb | `getUserById` |
| Classes | PascalCase | `UserService` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY` |
| Files | kebab-case | `user-service.ts` |

### Formatting

- Run project linter before committing
- 2-4 space indentation (match project style)
- Max line length: 80-120 characters

### Testing

- TDD when specified: RED → GREEN → REFACTOR
- Test location: `tests/` directory, `<feature>.spec.js`
- Browser tests mandatory for UI/DOM/visual changes (Playwright)

### Commit Protocol

1. `git status` - Review changes
2. Stage files individually - **NEVER `git add .`**
3. Commit with conventional type:

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `test` | Tests |
| `refactor` | Restructuring |
| `perf` | Performance |
| `docs` | Documentation |
| `style` | Formatting |
| `chore` | Build/config |

Format: `type: substantive one-liner`

---

## Agent Structure

| Agent | Role | Key Tools |
|-------|------|-----------|
| Orchestrator | Delegates workflow | runSubagent |
| Researcher | Tech stack investigation | Context7, web |
| Planner | Roadmaps/task plans | Context7 |
| Coder | Implementation | vscode, GitHub |
| Designer | UI/UX | Accessibility |
| Verifier | Validation | Playwright |
| Debugger | Debugging | Playwright |

**Use capitalized agent names**: `runSubagent(Researcher, "prompt...")`

### Artifacts Structure

```
.planning/
├── REQUIREMENTS.md
├── ROADMAP.md
├── STATE.md
├── research/
│   ├── SUMMARY.md
│   └── STACK.md
└── phases/<n>/
    ├── PLAN.md
    ├── SUMMARY.md
    └── VERIFICATION.md
```

---

## Deviation Handling

| Priority | Rule | Action |
|----------|------|--------|
| Highest | Architecture changes | STOP - ask |
| High | Auto-fix bugs | Fix + document |
| High | Add missing pieces | Add + document |
| High | Fix blockers | Fix + document |

**When unsure → stop and ask.**

---

## Verification

The Verifier validates:
1. Task completion ≠ Goal achievement
2. Existence ≠ Implementation (real code, not stubs)
3. Wiring matters - check imports/connections
4. Browser tests required for UI changes

**Outcomes**: PASSED | GAPS_FOUND | HUMAN_NEEDED

---

## Context7 Usage

Always use `#context7` for library docs before coding:
```
#context7 react useState hook
```

---

## OpenCode Skills Setup

This workspace includes OpenCode skills that replicate the GitHub Copilot agents system. The skills are located in:

```
~/.config/opencode/skills/superpowers/
├── orchestrator/SKILL.md   # Main orchestration
├── researcher/SKILL.md     # Tech research
├── planner/SKILL.md        # Roadmaps & plans
├── coder/SKILL.md          # Implementation
├── designer/SKILL.md       # UI/UX
├── verifier/SKILL.md       # Validation
└── debugger/SKILL.md       # Debugging
```

### How to Use

1. **Load a skill:** Use the skill tool to load any skill
2. **Orchestrator:** Start complex projects with the orchestrator skill
3. **Direct agents:** Use researcher, planner, coder, designer, verifier, or debugger directly for specific tasks

### Invocation Pattern

In OpenCode, use the `task` tool to delegate:

```python
task(description="Research domain", prompt="...", subagent_type="general")
```

### Skills vs Agents

| GitHub Copilot | OpenCode |
|---------------|----------|
| `runSubagent(AgentName, "prompt")` | `task(prompt="...", subagent_type="general")` |
| `.github/agents/*.agent.md` | `~/.config/opencode/skills/superpowers/*/SKILL.md` |
| Built-in agent discovery | Skill tool invocation |

### Quick Start

For new projects:
1. Load the `orchestrator` skill
2. Describe what you want to build
3. Orchestrator will coordinate research, planning, execution, and verification

### Artifacts Created

The skills create artifacts in `.planning/`:

```
.planning/
├── REQUIREMENTS.md         # Requirements with REQ-IDs
├── ROADMAP.md              # Phase breakdown
├── STATE.md                # Project state tracking
├── INTEGRATION.md          # Cross-phase verification
├── research/               # Research outputs
│   ├── SUMMARY.md
│   ├── STACK.md
│   ├── FEATURES.md
│   └── ARCHITECTURE.md
├── phases/
│   └── <N>/
│       ├── RESEARCH.md     # Phase research
│       ├── PLAN.md         # Task plans
│       ├── SUMMARY.md      # Execution summary
│       └── VERIFICATION.md # Phase verification
└── debug/                  # Debug session files
```

---

## Notes

- Agent definitions: `.github/agents/*.agent.md` (GitHub Copilot)
- OpenCode skills: `~/.config/opencode/skills/superpowers/`
- Use relative paths for `.planning/` directories
