#!/bin/bash
# OpenCode Superpowers Skills Installer
# Run this script from the repository root where the skills are located

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "OpenCode Superpowers Skills Installer"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -d "orchestrator" ] || [ ! -d "researcher" ]; then
    echo -e "${RED}Error: Skills not found in current directory${NC}"
    echo "Please run this script from the repository root containing the skill directories."
    echo "Expected directories: orchestrator, researcher, planner, coder, designer, verifier, debugger"
    exit 1
fi

# Target directory
TARGET_DIR="$HOME/.config/opencode/skills/superpowers"

echo -e "${YELLOW}Source: $(pwd)${NC}"
echo -e "${YELLOW}Target: $TARGET_DIR${NC}"
echo ""

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# List of skills to install
SKILLS=("orchestrator" "researcher" "planner" "coder" "designer" "verifier" "debugger")

# Check for existing skills
existing=()
for skill in "${SKILLS[@]}"; do
    if [ -d "$TARGET_DIR/$skill" ]; then
        existing+=("$skill")
    fi
done

# Handle existing skills
INSTALL_MODE="overwrite"
if [ ${#existing[@]} -gt 0 ]; then
    echo -e "${YELLOW}Found existing skills:${NC}"
    for skill in "${existing[@]}"; do
        echo "  - $skill"
    done
    echo ""
    echo "Options:"
    echo "  [O]verwrite - Replace all existing skills"
    echo "  [S]kip     - Keep existing skills, only install missing"
    echo "  [Q]uit     - Exit without making changes"
    echo ""
    read -p "Choose (O/S/Q): " choice
    choice=$(echo "$choice" | tr '[:lower:]' '[:upper:]')
    
    if [ "$choice" = "Q" ]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    elif [ "$choice" = "S" ]; then
        INSTALL_MODE="skip"
        echo -e "${YELLOW}Skipping existing skills...${NC}"
    else
        echo -e "${YELLOW}Overwriting existing skills...${NC}"
    fi
fi

echo ""
echo "Installing skills..."
echo ""

install_count=0
skip_count=0

# Install each skill
for skill in "${SKILLS[@]}"; do
    if [ -d "$skill" ]; then
        dest_path="$TARGET_DIR/$skill"
        
        # Check if already exists and user chose to skip
        if [ -d "$dest_path" ] && [ "$INSTALL_MODE" = "skip" ]; then
            echo -e "${YELLOW}[SKIP] Already exists: $skill${NC}"
            ((skip_count++))
        else
            # Remove existing skill if present
            if [ -d "$dest_path" ]; then
                rm -rf "$dest_path"
            fi
            
            # Copy skill directory
            cp -r "$skill" "$TARGET_DIR/"
            
            if [ -d "$dest_path" ]; then
                echo -e "${GREEN}[OK] Installed: $skill${NC}"
                ((install_count++))
            else
                echo -e "${RED}[FAIL] Failed: $skill${NC}"
            fi
        fi
    else
        echo -e "${RED}[MISSING] Not found in source: $skill${NC}"
    fi
done

echo ""
echo "=========================================="
echo -e "${GREEN}Installation complete!${NC}"
echo "=========================================="
echo ""
echo "Summary: $install_count installed, $skip_count skipped"
echo ""
echo "Next steps:"
echo -e "  ${GRAY}1. Restart OpenCode${NC}"
echo -e "  ${GRAY}2. Use: skill(name='orchestrator')${NC}"
echo ""
