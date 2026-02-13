# OpenCode Superpowers Skills Installer

This installer adds 7 AI agent skills to OpenCode, replicating the GitHub Copilot agents workflow.

## What Are These Skills?

Think of these skills as **AI team members** that can work together:

| Skill | What It Does |
|-------|-------------|
| **orchestrator** | The team lead - coordinates everything |
| **researcher** | Researches technologies and best practices |
| **planner** | Creates detailed implementation plans |
| **coder** | Writes the actual code |
| **designer** | Designs the UI/UX |
| **verifier** | Tests that everything works correctly |
| **debugger** | Finds and fixes bugs |

## Installation

### Option 1: PowerShell (Windows)

1. Open PowerShell
2. Navigate to this folder:
   ```powershell
   cd path\to\openskill-installer
   ```
3. Run the installer:
   ```powershell
   .\install-standalone.ps1
   ```

### Option 2: Bash (Linux/macOS/WSL)

1. Open terminal
2. Navigate to this folder:
   ```bash
   cd path/to/openskill-installer
   ```
3. Run the installer:
   ```bash
   chmod +x install-standalone.sh
   ./install-standalone.sh
   ```

### What Happens During Installation?

The installer will:
- Create the folder: `~/.config/openopencode/skills/superpowers/`
- Copy all 7 skills into that folder
- Show confirmation messages like "✓ Installed: orchestrator"

## How to Use After Installation

### Step 1: Restart OpenCode

Close OpenCode completely and reopen it. This is required for OpenCode to discover the new skills.

### Step 2: Start a New Conversation

In OpenCode, start a fresh conversation.

### Step 3: Load the Orchestrator

Type this command to load the main orchestrator skill:

```
Use the skill tool to load orchestrator
```

Or simply tell OpenCode what you want to build:

```
I want to build a recipe sharing app
```

The orchestrator will then guide you through the entire development process!

## Example: Building Something

**You say:**
> I want to build a task management app

**Orchestrator responds:**
> I'll help you build this! Let me start by researching the best technologies, then create a plan, and implement it step by step.

**Then the orchestrator will:**
1. Research: "Let me investigate the best tech stack for task management apps"
2. Plan: "Based on the research, here's a 3-phase roadmap..."
3. Execute: Delegates to coder to build Phase 1
4. Verify: Has verifier test that Phase 1 works
5. Repeats for each phase until complete

## Direct Skill Usage

You can also load individual skills directly:

| Command | What Happens |
|---------|-------------|
| `skill(name="researcher")` | Load research skill to investigate something |
| `skill(name="planner")` | Load planning skill to create a roadmap |
| `skill(name="coder")` | Load coding skill to implement something |
| `skill(name="designer")` | Load design skill for UI/UX work |
| `skill(name="verifier")` | Load verification skill to test work |
| `skill(name="debugger")` | Load debugging skill to fix issues |

## What Gets Created

When you use these skills, they create files in a `.planning/` folder:

```
.your-project/
└── .planning/
    ├── REQUIREMENTS.md      # What needs to be built
    ├── ROADMAP.md          # Phases of work
    ├── STATE.md            # Progress tracking
    ├── research/
    │   └── SUMMARY.md      # Technology research
    └── phases/
        └── 1/
            ├── RESEARCH.md    # Phase 1 research
            ├── PLAN.md       # Phase 1 tasks
            ├── SUMMARY.md    # What was built
            └── VERIFICATION.md  # Test results
```

## Troubleshooting

### "Skill not found" error
- Make sure you restarted OpenCode after installation
- Try: `skill(name="orchestrator")` with exact spelling

### Skills not appearing
- Check that the skills were installed:
  ```bash
  ls ~/.config/opencode/skills/superpowers/
  ```
- You should see: orchestrator, researcher, planner, coder, designer, verifier, debugger

### Installation failed
- Make sure you have permission to write to `~/.config/opencode/skills/`
- On Windows, try running PowerShell as Administrator

## Quick Reference

| Task | Command |
|------|---------|
| Install | `.\install-standalone.ps1` (Windows) or `./install-standalone.sh` (Mac/Linux) |
| Start building | `skill(name="orchestrator")` |
| Research something | `skill(name="researcher")` |
| Create a plan | `skill(name="planner")` |
| Fix a bug | `skill(name="debugger")` |

## Files in This Package

```
openskill-installer/
├── README.md                # This file
├── install-skills.sh        # Bash script (run from skills source)
├── install-skills.ps1       # PowerShell script (run from source)
├── install-standalone.sh    # Self-contained bash installer
├── install-standalone.ps1   # Self-contained PowerShell installer
└── [skill folders]         # The 7 skills to install
    ├── orchestrator/
    ├── researcher/
    ├── planner/
    ├── coder/
    ├── designer/
    ├── verifier/
    └── debugger/
```
