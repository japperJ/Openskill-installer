# JP Agents Workspace Setup

## What Was Fixed

The Orchestrator agent was using incorrect lowercase agent names (`researcher`, `planner`, `coder`, etc.) when calling the `runSubagent` tool.

**The fix:** Updated all `runSubagent` calls throughout the Orchestrator to use the correct capitalized agent names that match the actual agent definitions:
- `Researcher` (not `researcher`)
- `Planner` (not `planner`)
- `Coder` (not `coder`)
- `Designer` (not `designer`)
- `Verifier` (not `verifier`)
- `Debugger` (not `debugger`)

## How It Works Now

When you use the Orchestrator agent, it will:

1. **Receive your request** (e.g., "Build a recipe sharing app")
2. **Call runSubagent** with the appropriate agent name and prompt
3. **Wait for the subagent** to complete its work (research, planning, coding, etc.)
4. **Coordinate the workflow** through all phases

## Agent Roles

| Agent | Role | Tools | Special Capabilities |
|---|---|---|---|
| **Orchestrator** | Coordinates workflow, delegates to others | read, agent, memory | Full workflow orchestration |
| **Researcher** | Investigates tech stacks, patterns, docs | Full toolkit + Context7 + web | Source-verified research |
| **Planner** | Creates roadmaps and task plans | Full toolkit + Context7 + web | Plan validation |
| **Coder** | Implements code, commits changes | Full toolkit + Context7 + GitHub | Atomic commits per task |
| **Designer** | UI/UX design and styling | Full toolkit | Accessibility focus |
| **Verifier** | Validates work against goals | Full toolkit + **Playwright** | Browser testing for UI |
| **Debugger** | Scientific debugging | Full toolkit + **Playwright** | Hypothesis-driven testing |

## Example Usage

Instead of manually calling each agent, you now invoke the Orchestrator:

```
User: "Build a recipe sharing app"

Orchestrator will:
├─ runSubagent(Researcher, "Project mode. Research recipe sharing...")
├─ runSubagent(Planner, "Roadmap mode. Create phased roadmap...")
├─ runSubagent(Coder, "Execute Phase 1 plan...")
├─ runSubagent(Verifier, "Verify Phase 1...")
└─ ... continue through all phases
```

## Key Changes Made

1. **Agent Naming**: All agent names must be capitalized (`Researcher`, `Planner`, `Coder`, etc.)
2. **Agent Invocation**: Use `runSubagent(AgentName, "prompt")` with capitalized names
3. **All delegation examples**: Updated throughout the Orchestrator instructions
4. **Parallel execution**: Now uses `runSubagent(Coder, ...)` + `runSubagent(Designer, ...)` properly

## How to Use

1. **Invoke Orchestrator**: Use `@Orchestrator` in Copilot Chat
2. **Describe your goal**: "Build a [type of app]" or "Add [feature]"
3. **Let it orchestrate**: The Orchestrator will automatically call the right subagents
4. **Review outputs**: Check `.planning/` directory for all generated artifacts

## Artifacts Structure

```
.planning/
├── REQUIREMENTS.md         # All requirements with IDs
├── ROADMAP.md              # Phase breakdown
├── STATE.md                # Current progress
├── research/
│   ├── SUMMARY.md          # Consolidated research
│   ├── STACK.md            # Tech stack decisions
│   ├── FEATURES.md         # Feature analysis
│   ├── ARCHITECTURE.md     # Architecture patterns
│   └── PITFALLS.md         # Known pitfalls
└── phases/
    ├── 1/
    │   ├── RESEARCH.md     # Phase-specific research
    │   ├── PLAN.md         # Task-level plan
    │   ├── SUMMARY.md      # What was built
    │   └── VERIFICATION.md # Verification results
    └── 2/
        └── ...
```

## The Full Workflow

```
User Request
    ↓
Orchestrator (coordinates)
    ↓
├─ Step 1: Researcher (project mode) → tech stack, architecture
├─ Step 2: Researcher (synthesize) → SUMMARY.md
├─ Step 3: Planner (roadmap) → ROADMAP.md, REQUIREMENTS.md
│
│  For each phase:
├─ Step 4: Researcher (phase mode) → implementation details
├─ Step 5: Planner (plan mode) → task plans
├─ Step 6: Planner (validate) → verify plans
├─ Step 7: Coder + Designer (execute) → implement + commit
├─ Step 8: Verifier (verify) → check success criteria
│
├─ Step 9: Verifier (integration) → cross-phase checks
└─ Step 10: Report to user
```

---

## Browser Testing with Playwright

**NEW REQUIREMENT:** All UI changes MUST be verified with Playwright browser tests.

### When Browser Tests are Required

**MANDATORY for:**
- Visual/UI changes (layout, styling, themes, colors)
- DOM manipulation (element creation, removal, modification)
- User interactions (clicks, keyboard, forms, navigation)
- Client-side state (localStorage, sessionStorage, cookies)
- Dynamic content (search, filters, toggles, animations)

**OPTIONAL for:**
- Backend-only changes
- Documentation updates
- Build script modifications

### Agent Behavior for UI Changes

**Debugger Agent:**
When fixing UI bugs, the Debugger will:
1. Write a Playwright test that reproduces the bug
2. Run the test to confirm it fails (proves bug exists)
3. Implement the fix
4. Run the test again to confirm it passes (proves fix works)
5. Include test results in the debug report

**Verifier Agent:**
When verifying phases with UI changes, the Verifier will:
1. Check if Playwright is available
2. Run all browser tests in the `tests/` directory
3. Include test results in `VERIFICATION.md`
4. Flag as `HUMAN_NEEDED` if tests fail or Playwright isn't set up

### Test Files Location

All browser tests are in the `tests/` directory:

```
tests/
├── README.md                          # Setup and usage guide
├── TEMPLATE.spec.js                   # Test template
├── feature-name.spec.js               # Feature tests
└── BUG-YYYYMMDD-HHMMSS-*.spec.js     # Bug reproduction tests
```

### Quick Setup

```bash
# One-time setup
npm init -y
npm install -D @playwright/test
npx playwright install chromium

# Run tests
python -m http.server 8000  # Start server
npx playwright test         # Run tests
```

### Example Test Structure

```javascript
const { test, expect } = require('@playwright/test');

test.describe('Feature Name', () => {
  test('should do something', async ({ page }) => {
    await page.goto('http://localhost:8000');
    await page.click('#button');
    await expect(page.locator('.result')).toHaveText('Success');
  });
});
```

### Verification Reports Include Browser Tests

When the Verifier checks a phase with UI changes, `VERIFICATION.md` will include:

```markdown
## Browser Tests
| Test File | Status | Output |
|---|---|---|
| tests/theme-toggle.spec.js | ✓ PASSED | 8 tests passed |
| tests/search-filter.spec.js | ✓ PASSED | 6 tests passed |

**Summary:** All browser tests passing
```

If tests fail, the phase verification will be marked as `GAPS_FOUND`.

---

## Troubleshooting

****Agent name mismatch**: Ensure you use capitalized agent names: `Researcher`, `Planner`, `Coder`, `Designer`, `Verifier`, `Debugger`
- Check that agent files are in `.github/agents/` directory
- Verify frontmatter `name:` matches the agent name exactly (capitalized)
- Ensure Orchestrator is calling `runSubagent` with proper capitalization
- Ensure Orchestrator is calling `runSubagent` (not `@mentions`)

**Problem: Agents can't edit files**
- Verify each agent has `edit` in their `tools:` list
- Check that the agent has `vscode` tool access
- Ensure Orchestrator is delegating, not implementing

**Problem: Context overflow**
- Plans might be too large (target 2-3 tasks per plan)
- Split phases into smaller sub-phases
- Use more granular delegation

## Direct Agent Use

You can also call agents directly for specific tasks:

- `@researcher` - Research a technology or pattern
- `@planner` - Create a plan for a feature
- `@coder` - Implement a specific change
- `@designer` - Design UI components
- `@verifier` - Verify work was completed
- `@debugger` - Debug an issue

But for **complex multi-phase projects**, always use `@Orchestrator` to coordinate.
