#!/bin/bash

# Kiro Style Global Uninstaller Script
# This script removes only Kiro-specific files from global Claude Code installation

set -e

echo "🗑️  Uninstalling Kiro Style Specification-Driven Development from global Claude Code..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# List of specific Kiro files to remove
KIRO_COMMANDS=(
    "kiro.md"
    "kiro-researcher.md"
    "kiro-architect.md"
    "kiro-implementer.md"
    "kiro-init.md"
    "debugger.md"
)

KIRO_TEMPLATES=(
    "kiro-template.md"
)

# Check if Claude Code global directory exists
if [ ! -d ~/.claude ]; then
    echo -e "${YELLOW}⚠️  Claude Code global directory not found. Nothing to uninstall.${NC}"
    exit 0
fi

echo -e "${BLUE}🔍 Checking for Kiro files...${NC}"

# Track what we actually remove
removed_commands=()
removed_templates=()
missing_files=()

# Remove Kiro commands
if [ -d ~/.claude/commands ]; then
    echo -e "${BLUE}📋 Removing Kiro commands...${NC}"
    for cmd in "${KIRO_COMMANDS[@]}"; do
        if [ -f ~/.claude/commands/"$cmd" ]; then
            rm ~/.claude/commands/"$cmd"
            removed_commands+=("$cmd")
            echo -e "${GREEN}  ✅ Removed: $cmd${NC}"
        else
            missing_files+=("commands/$cmd")
            echo -e "${YELLOW}  ⚠️  Not found: $cmd${NC}"
        fi
    done
else
    echo -e "${YELLOW}⚠️  Commands directory not found: ~/.claude/commands${NC}"
fi

# Remove Kiro templates
if [ -d ~/.claude/templates ]; then
    echo -e "${BLUE}📄 Removing Kiro templates...${NC}"
    for template in "${KIRO_TEMPLATES[@]}"; do
        if [ -f ~/.claude/templates/"$template" ]; then
            rm ~/.claude/templates/"$template"
            removed_templates+=("$template")
            echo -e "${GREEN}  ✅ Removed: $template${NC}"
        else
            missing_files+=("templates/$template")
            echo -e "${YELLOW}  ⚠️  Not found: $template${NC}"
        fi
    done
    
    # Remove templates directory only if it's empty and we created it
    if [ -d ~/.claude/templates ] && [ -z "$(ls -A ~/.claude/templates)" ]; then
        rmdir ~/.claude/templates
        echo -e "${GREEN}  ✅ Removed empty templates directory${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Templates directory not found: ~/.claude/templates${NC}"
fi

# Summary
echo ""
echo -e "${BLUE}📊 Uninstallation Summary:${NC}"

if [ ${#removed_commands[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Removed commands (${#removed_commands[@]}):${NC}"
    for cmd in "${removed_commands[@]}"; do
        echo "  - $cmd"
    done
fi

if [ ${#removed_templates[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Removed templates (${#removed_templates[@]}):${NC}"
    for template in "${removed_templates[@]}"; do
        echo "  - $template"
    done
fi

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Files not found (${#missing_files[@]}):${NC}"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
fi

# Final status
total_expected=$((${#KIRO_COMMANDS[@]} + ${#KIRO_TEMPLATES[@]}))
total_removed=$((${#removed_commands[@]} + ${#removed_templates[@]}))

if [ $total_removed -eq 0 ]; then
    echo ""
    echo -e "${YELLOW}ℹ️  No Kiro files were found to remove.${NC}"
    echo -e "${BLUE}💡 Kiro may not have been installed globally, or files were already removed.${NC}"
elif [ $total_removed -eq $total_expected ]; then
    echo ""
    echo -e "${GREEN}🎉 Kiro Style has been completely uninstalled from global Claude Code!${NC}"
else
    echo ""
    echo -e "${GREEN}✅ Kiro Style has been partially uninstalled.${NC}"
    echo -e "${BLUE}💡 Some files were not found (possibly already removed or never installed).${NC}"
fi

echo ""
echo -e "${BLUE}📝 Note: This uninstaller only removes Kiro-specific files.${NC}"
echo -e "${BLUE}   Your other Claude Code commands and settings remain untouched.${NC}"
echo ""
echo -e "${BLUE}📖 To reinstall, visit: https://github.com/bizzkoot/kiro_style_claude_code${NC}"