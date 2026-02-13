# OpenCode Superpowers Skills Installer

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "OpenCode Superpowers Skills Installer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Get current directory
$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) {
    $ScriptDir = Get-Location
}

# Check if we're in the right directory
$orchestratorPath = Join-Path $ScriptDir "orchestrator"
$researcherPath = Join-Path $ScriptDir "researcher"

if (-not (Test-Path $orchestratorPath) -or -not (Test-Path $researcherPath)) {
    Write-Host "Error: Skills not found in current directory" -ForegroundColor Red
    Write-Host "Please run this script from the repository root containing the skill directories." -ForegroundColor Red
    Write-Host "Expected directories: orchestrator, researcher, planner, coder, designer, verifier, debugger" -ForegroundColor Red
    exit 1
}

# Target directory
$TargetDir = Join-Path $env:USERPROFILE ".config\opencode\skills\superpowers"

Write-Host "Source: $ScriptDir" -ForegroundColor Yellow
Write-Host "Target: $TargetDir" -ForegroundColor Yellow
Write-Host ""

# Create target directory if it doesn't exist
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# List of skills to install
$Skills = @("orchestrator", "researcher", "planner", "coder", "designer", "verifier", "debugger")

# Check for existing skills
$existingSkills = @()
foreach ($skill in $Skills) {
    $destPath = Join-Path $TargetDir $skill
    if (Test-Path $destPath) {
        $existingSkills += $skill
    }
}

# Handle existing skills
$installMode = "overwrite"
if ($existingSkills.Count -gt 0) {
    Write-Host "Found existing skills:" -ForegroundColor Yellow
    foreach ($skill in $existingSkills) {
        Write-Host "  - $skill" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Options:" -ForegroundColor White
    Write-Host "  [O]verwrite - Replace all existing skills" -ForegroundColor White
    Write-Host "  [S]kip     - Keep existing skills, only install missing" -ForegroundColor White
    Write-Host "  [Q]uit     - Exit without making changes" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "Choose (O/S/Q)"
    $choice = $choice.ToUpper()
    
    if ($choice -eq "Q") {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        exit 0
    } elseif ($choice -eq "S") {
        $installMode = "skip"
        Write-Host "Skipping existing skills..." -ForegroundColor Yellow
    } else {
        Write-Host "Overwriting existing skills..." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Installing skills..." -ForegroundColor Cyan
Write-Host ""

$installCount = 0
$skipCount = 0

# Install each skill
foreach ($skill in $Skills) {
    $sourcePath = Join-Path $ScriptDir $skill
    $destPath = Join-Path $TargetDir $skill
    
    if (Test-Path $sourcePath) {
        # Check if already exists and user chose to skip
        if ((Test-Path $destPath) -and ($installMode -eq "skip")) {
            Write-Host "[SKIP] Already exists: $skill" -ForegroundColor Yellow
            $skipCount++
        } else {
            # Remove existing skill if present
            if (Test-Path $destPath) {
                Remove-Item -Path $destPath -Recurse -Force
            }
            
            # Copy skill directory
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            
            if (Test-Path $destPath) {
                Write-Host "[OK] Installed: $skill" -ForegroundColor Green
                $installCount++
            } else {
                Write-Host "[FAIL] Failed: $skill" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "[MISSING] Not found in source: $skill" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary: $installCount installed, $skipCount skipped" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  1. Restart OpenCode" -ForegroundColor Gray
Write-Host "  2. Use: skill(name='orchestrator')" -ForegroundColor Gray
Write-Host ""
