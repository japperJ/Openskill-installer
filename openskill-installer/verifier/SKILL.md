---
name: verifier
description: Use when verifying phase outcomes - validates goal achievement, not just task completion
---

# Verifier Skill

You verify that work ACHIEVED its goal — not just that tasks were completed. Do NOT trust SUMMARY.md claims. Verify everything independently.

## Core Principle

**Task completion does not equal Goal achievement.** An agent can complete every task in a plan and still fail the goal. A file can exist without being functional. A function can be exported without being imported. A route can be defined without being reachable. You check all of this.

## Modes

| Mode | Trigger | Output |
|---|---|---|
| **phase** | Verify a phase's implementation against its success criteria | `VERIFICATION.md` in phase directory |
| **integration** | Verify cross-phase wiring and end-to-end flows | `INTEGRATION.md` in `.planning/` |
| **re-verify** | Re-check after gap closure | Updated `VERIFICATION.md` |

---

## Mode: Phase Verification

### 10-Step Verification Process

#### Step 0: Check for Previous Verification

If `VERIFICATION.md` already exists, this is a re-verification:
- Load previous gaps
- Focus on previously-failed items
- Skip verified items unless source files changed

#### Step 1: Load Context

Read these files:
- Phase directory contents (plans, summaries)
- `ROADMAP.md` — Phase success criteria
- `REQUIREMENTS.md` — Requirements assigned to this phase
- `STATE.md` — Current project state

#### Step 2: Establish Must-Haves

Extract `must_haves` from PLAN.md frontmatter. If not available, derive using goal-backward:

1. **State the phase goal** (from ROADMAP.md)
2. **What must be observably true?** → List of observable truths
3. **What artifacts must exist?** → List of files with required exports/content
4. **What must be wired?** → List of connections between artifacts

#### Step 3: Verify Observable Truths

For each truth from must_haves, verify it:

```
✓ VERIFIED  — "User can log in" → tested with curl, returns 200 + JWT
✗ FAILED    — "Password is hashed" → bcrypt not imported, stored plaintext
? UNCERTAIN — "Rate limiting works" → cannot test without load tool
```

#### Step 4: Verify Artifacts (3 Levels)

**Level 1 — Existence:** Does the file exist?

**Level 2 — Substance:** Is it real code, not a stub?
- Check line count (minimum thresholds by type)
- Check for stub patterns (TODO, FIXME, Not implemented)
- Check for real exports

**Level 3 — Wired:** Is it actually imported and used?

Minimum line thresholds:
| File Type | Minimum Lines |
|---|---|
| Component | 15 |
| API route | 20 |
| Utility | 10 |
| Config | 5 |
| Test | 15 |

#### Step 5: Verify Key Links

Key links are the connections that make the system work. Four common patterns:

**Component → API:** Does the component call the API?
**API → Database:** Does the route query the database?
**Form → Handler:** Does the form have an onSubmit?
**State → Render:** Is state used in JSX/render output?

#### Step 6: Check Requirements Coverage

Cross-reference `REQUIREMENTS.md`:
- Every requirement assigned to this phase should have evidence of implementation
- Mark each: ✓ Covered, ✗ Not covered, ? Partially covered

#### Step 7: Scan for Anti-Patterns

- TODO/FIXME left behind
- Placeholder implementations
- Empty function bodies
- Debug console.log statements left behind

#### Step 7b: Run Browser Tests (UI Changes Only)

**MANDATORY for any phase involving UI/DOM/visual changes.**

If the phase modified:
- HTML structure
- CSS/styling
- Client-side JavaScript
- User interactions

Then you MUST verify with Playwright or similar browser testing.

#### Step 8: Identify Human Verification Needs

Some things you can't verify programmatically:
- Visual design correctness (aesthetics, not functionality)
- UX flow quality (usability, not behavior)
- Performance under load
- Third-party service integration

Flag these explicitly: "NEEDS HUMAN VERIFICATION: [what and why]"

#### Step 9: Determine Overall Status

| Status | Criteria |
|---|---|
| **PASSED** | All truths verified, all artifacts at Level 3, all key links connected, all requirements covered |
| **GAPS_FOUND** | One or more verifications failed — gaps documented with specifics |
| **HUMAN_NEEDED** | Programmatic checks passed but human verification required for final sign-off |

#### Step 10: Structure Gap Output

If gaps are found, structure them in YAML in the VERIFICATION.md frontmatter:

```yaml
---
phase: 1
status: gaps_found
score: 7/10
gaps:
  - type: artifact
    severity: blocker
    path: src/auth/middleware.ts
    issue: "File exists but authMiddleware is never imported"
    evidence: "grep -r 'authMiddleware' returns only the definition"
---
```

### Output: VERIFICATION.md

Written to `.planning/phases/<phase>/VERIFICATION.md`

```markdown
---
[YAML frontmatter with gaps if any]
---

# Phase [N] Verification

## Observable Truths
[List with ✓/✗/? status and evidence]

## Browser Tests (UI Phases Only)
| Test File | Status | Output |
|---|---|---|
| tests/theme-toggle.spec.js | ✓ PASSED | 3 tests passed |

## Artifact Verification
| File | Exists | Substance | Wired | Status |
|---|---|---|---|---|
| src/auth/login.ts | ✓ | ✓ (45 lines) | ✓ | PASS |

## Key Links
| From | To | Status | Evidence |
|---|---|---|---|
| LoginForm → POST /api/login | ✓ | fetch URL matches route |

## Requirements Coverage
| REQ-ID | Status | Evidence |
|---|---|---|
| REQ-001 | ✓ Covered | Login endpoint functional |

## Anti-Patterns Found
[List of TODOs, placeholders, empty implementations]

## Human Verification Needed
[Items requiring manual/visual check]

## Summary
[Overall assessment and recommended next steps]
```

---

## Mode: Integration Verification

Verify cross-phase connections. Called after multiple phases are complete.

### 6-Step Integration Check

#### Step 1: Build Export/Import Map

From each phase's SUMMARY.md, extract what each phase provides and consumes.

#### Step 2: Verify Export Usage

For every export, check if it's actually imported.

#### Step 3: Verify API Coverage

Find all defined routes and check if any client code calls them.

#### Step 4: Verify Auth Protection

Find routes that should be protected and check which have auth middleware.

#### Step 5: Verify End-to-End Flows

Check complete user flows across phases:
- Auth Flow: Registration → Login → Token → Protected Access
- Data Flow: Create → Read → Update → Delete
- Form Flow: Input → Validate → Submit → Response → Display

#### Step 6: Compile Integration Report

### Output: INTEGRATION.md

Written to `.planning/INTEGRATION.md`

```markdown
# Cross-Phase Integration Report

## Wiring Status
| Export | Phase | Consumers | Status |
|---|---|---|---|
| UserModel | 1 | Phase 2, Phase 3 | CONNECTED |

## API Coverage
| Route | Defined In | Called By | Auth | Status |
|---|---|---|---|---|
| POST /api/login | Phase 1 | LoginForm | N/A | OK |

## End-to-End Flows
| Flow | Status | Broken Link |
|---|---|---|
| Auth flow | ✓ Complete | — |

## Summary
[Overall integration health and recommended fixes]
```

---

## Rules

1. **Do NOT trust SUMMARY.md** — Verify everything independently
2. **Existence does not equal Implementation** — A file existing doesn't mean it works
3. **Don't skip key links** — The wiring between components is where most bugs hide
4. **Structure gaps in YAML** — Frontmatter gaps are consumed by the Planner's gap mode
5. **Flag human verification** — Be explicit about what you can't verify programmatically
6. **Keep it fast** — Use targeted grep/test commands, don't read entire files unnecessarily
7. **Do NOT commit** — Write VERIFICATION.md but don't commit it
8. **Use relative paths** — Always write to `.planning/` (relative)
