# Plan: OpenCode Agents System

## Project Overview

**Goal:** Build an opencode CLI plugin that replicates the GitHub Copilot agents orchestration system, enabling multi-agent workflows within opencode using the `task` tool.

**Architecture:** OpenCode Skills in `~/.config/opencode/skills/superpowers/` directory, mirroring the agent definitions from `.github/agents/` in this repository.

---

## Phase 1: Analyze Existing Copilot Agents Setup

### What We Have (Analyzed)

The current GitHub Copilot setup in `.github/agents/` contains:

| Agent | File | Role | Tools |
|-------|------|------|-------|
| Orchestrator | `orchestrator.agent.md` | Coordinates full workflow | runSubagent, memory |
| Researcher | `researcher.agent.md` | Tech investigation | Context7, web, edit |
| Planner | `planner.agent.md` | Roadmaps & plans | Context7, todo |
| Coder | `coder.agent.md` | Implementation | vscode, GitHub, edit |
| Designer | `designer.agent.md` | UI/UX | Accessibility |
| Verifier | `verifier.agent.md` | Validation | Playwright |
| Debugger | `debugger.agent.md` | Debugging | Playwright |

### Key Differences: Copilot vs OpenCode

| Aspect | Copilot (GitHub) | OpenCode |
|-------|-----------------|----------|
| Subagent invocation | `runSubagent(AgentName, "prompt")` | `task` tool with `subagent_type` |
| Agent definition | YAML frontmatter + markdown | YAML frontmatter + markdown (SKILL.md) |
| Agent location | `.github/agents/*.agent.md` | `~/.config/opencode/skills/superpowers/*/SKILL.md` |
| Skills discovery | Built-in to agents | Manual skill tool invocation |
| Context7 access | Via agent tools | Via codesearch/websearch tools |

---

## Phase 2: Create OpenCode Skills Structure

### Directory Structure

```
~/.config/opencode/skills/superpowers/
├── orchestrator/           # Main orchestration skill
│   └── SKILL.md           # Coordinates subagents
├── researcher/            # Research skill  
│   └── SKILL.md           # Tech investigation
├── planner/               # Planning skill
│   └── SKILL.md           # Roadmaps & task plans
├── coder/                 # Implementation skill
│   └── SKILL.md           # Code writing & commits
├── designer/              # UI/UX skill
│   └── SKILL.md           # Design implementation
├── verifier/              # Verification skill
│   └── SKILL.md           # Goal-backward validation
└── debugger/              # Debugging skill
    └── SKILL.md           # Scientific debugging
```

### SKILL.md Format

Each skill follows this pattern:

```yaml
---
name: [camelCase skill name]
description: [What this skill does]
---

# Skill Content
[Full markdown with instructions]
```

---

## Phase 3: Implement Each Skill

### 3.1 Orchestrator Skill (Core)

**File:** `~/.config/opencode/skills/superpowers/orchestrator/SKILL.md`

**Key adaptations:**
- Replace `runSubagent(AgentName, "prompt")` with `task` tool calls
- Use `subagent_type: "general"` with detailed prompts
- Invoke other skills via the skill tool
- Adapt 10-step execution model for opencode

**Invocation pattern:**
```
task(description="Execute phase", prompt="...", subagent_type="general")
```

### 3.2 Researcher Skill

**File:** `~/.config/opencode/skills/superpowers/researcher/SKILL.md`

**Modes to implement:**
- `project` - Domain research for new projects
- `phase` - Implementation research for specific phases
- `codebase` - Existing codebase analysis
- `synthesize` - Consolidate research outputs

**Tools needed:**
- codesearch (replaces Context7)
- websearch
- grep/glob
- read

### 3.3 Planner Skill

**File:** `~/.config/opencode/skills/superpowers/planner/SKILL.md`

**Modes to implement:**
- `roadmap` - Create phased roadmap
- `plan` - Task-level planning
- `validate` - Verify plans before execution
- `gaps` - Fix verification gaps
- `revise` - Update plans based on feedback

### 3.4 Coder Skill

**File:** `~/.config/opencode/skills/superpowers/coder/SKILL.md`

**Key features:**
- Execute PLAN.md files
- Per-task commits
- TDD execution (RED→GREEN→REFACTOR)
- Deviation handling rules

### 3.5 Designer Skill

**File:** `~/.config/opencode/skills/superpowers/designer/SKILL.md`

**Focus:** UI/UX implementation with accessibility

### 3.6 Verifier Skill

**File:** `~/.config/opencode/skills/superpowers/verifier/SKILL.md`

**Verification:**
- Phase verification
- Integration verification
- Browser tests with Playwright

### 3.7 Debugger Skill

**File:** `~/.config/opencode/skills/superpowers/debugger/SKILL.md`

**Modes:**
- `find_and_fix` - Find and fix
- `find_root_cause_only` - Diagnose only

---

## Phase 4: Test the Setup

### Test 1: Skill Loading

```bash
# Verify skills can be loaded
skill(name="orchestrator")
```

### Test 2: Orchestrator Invocation

Create a test project and invoke orchestrator:

```bash
# Create test directory
mkdir test-project
cd test-project

# Initialize opencode session
# Invoke orchestrator skill
```

### Test 3: Full Workflow Test

1. Invoke orchestrator with a simple task
2. Verify subagent delegation works
3. Verify artifacts are created in `.planning/`

### Test 4: Resume Capability

Stop mid-phase, then resume from STATE.md

---

## Phase 5: Refine and Document

### Documentation Updates

- Update AGENTS.md to reference opencode skills
- Add usage examples
- Document troubleshooting

### Refinements Based on Testing

- Fix skill loading issues
- Adjust prompt templates
- Ensure proper subagent delegation

---

## Implementation Notes

### OpenCode Task Tool Usage

```python
# How to call subagents in opencode
task(
    description="Brief description",
    prompt="Full prompt with context and instructions",
    subagent_type="general"  # or specific type if available
)
```

### Skill Invocation

```python
# Invoke another skill
skill(name="researcher")  # Loads researcher skill
```

### Artifacts Structure

```
.planning/
├── REQUIREMENTS.md
├── ROADMAP.md
├── STATE.md
├── research/
│   └── SUMMARY.md
└── phases/
    └── <N>/
        ├── RESEARCH.md
        ├── PLAN.md
        ├── SUMMARY.md
        └── VERIFICATION.md
```

---

## Success Criteria

1. Orchestrator can delegate to other skills via task tool
2. Each skill (Researcher, Planner, Coder, etc.) functions independently
3. Full workflow: Research → Plan → Execute → Verify works end-to-end
4. Resume capability - can pick up from where left off
5. Gap-closure loop works (verify → fix → re-verify)
6. Browser tests can be run for UI work
7. Artifacts are created correctly in `.planning/`

---

## Estimated Timeline

| Phase | Tasks | Time |
|-------|-------|------|
| 1 | Analysis | Done |
| 2 | Structure setup | 30 min |
| 3 | Implement 7 skills | 4-6 hours |
| 4 | Testing | 2 hours |
| 5 | Refine | 1 hour |

**Total:** ~8 hours for fully functional v1
