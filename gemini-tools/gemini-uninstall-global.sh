#!/bin/bash

# Gemini Kiro Style Global Uninstallation Script
# This script removes Kiro commands and templates from Gemini CLI global installation

set -e

echo "🗑️  Uninstalling Gemini Kiro Style Specification-Driven Development globally..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if global Gemini directories exist
if [ ! -d ~/.gemini ]; then
    echo -e "${YELLOW}⚠️  No global Gemini installation found. Nothing to uninstall.${NC}"
    exit 0
fi

echo -e "${BLUE}🔍 Checking for Gemini Kiro Style installation...${NC}"

# Files to remove
FILES_TO_REMOVE=(
    "~/.gemini/commands/kiro.toml"
    "~/.gemini/commands/kiro-init.toml"
    "~/.gemini/templates/kiro_template.md"
)

# Track what was actually removed
REMOVED_COUNT=0
MISSING_COUNT=0

echo -e "${BLUE}🗑️  Removing Gemini Kiro Style files...${NC}"

# Remove kiro.toml
if [ -f ~/.gemini/commands/kiro.toml ]; then
    rm ~/.gemini/commands/kiro.toml
    echo -e "${GREEN}✅ Removed: ~/.gemini/commands/kiro.toml${NC}"
    ((REMOVED_COUNT++))
else
    echo -e "${YELLOW}⚠️  Not found: ~/.gemini/commands/kiro.toml${NC}"
    ((MISSING_COUNT++))
fi

# Remove kiro-init.toml
if [ -f ~/.gemini/commands/kiro-init.toml ]; then
    rm ~/.gemini/commands/kiro-init.toml
    echo -e "${GREEN}✅ Removed: ~/.gemini/commands/kiro-init.toml${NC}"
    ((REMOVED_COUNT++))
else
    echo -e "${YELLOW}⚠️  Not found: ~/.gemini/commands/kiro-init.toml${NC}"
    ((MISSING_COUNT++))
fi

# Remove kiro_template.md
if [ -f ~/.gemini/templates/kiro_template.md ]; then
    rm ~/.gemini/templates/kiro_template.md
    echo -e "${GREEN}✅ Removed: ~/.gemini/templates/kiro_template.md${NC}"
    ((REMOVED_COUNT++))
else
    echo -e "${YELLOW}⚠️  Not found: ~/.gemini/templates/kiro_template.md${NC}"
    ((MISSING_COUNT++))
fi

# Remove Persona Library
echo -e "${BLUE}🗑️  Removing Persona Library...${NC}"
if [ -d ~/.gemini/personas ]; then
    rm -rf ~/.gemini/personas
    echo -e "${GREEN}✅ Removed Persona Library directory: ~/.gemini/personas${NC}"
    ((REMOVED_COUNT++)) # Count the directory as one removed item
else
    echo -e "${YELLOW}⚠️  Not found: ~/.gemini/personas${NC}"
    ((MISSING_COUNT++))
fi

# Clean up empty directories if they exist and are empty
echo -e "${BLUE}🧹 Cleaning up empty directories...${NC}"

if [ -d ~/.gemini/commands ] && [ -z "$(ls -A ~/.gemini/commands)" ]; then
    rmdir ~/.gemini/commands
    echo -e "${GREEN}✅ Removed empty directory: ~/.gemini/commands${NC}"
fi

if [ -d ~/.gemini/templates ] && [ -z "$(ls -A ~/.gemini/templates)" ]; then
    rmdir ~/.gemini/templates
    echo -e "${GREEN}✅ Removed empty directory: ~/.gemini/templates${NC}"
fi

if [ -d ~/.gemini ] && [ -z "$(ls -A ~/.gemini)" ]; then
    rmdir ~/.gemini
    echo -e "${GREEN}✅ Removed empty directory: ~/.gemini${NC}"
fi

# Verify uninstallation
echo -e "${BLUE}🔍 Verifying uninstallation...${NC}"
REMAINING_FILES=0

if [ -f ~/.gemini/commands/kiro.toml ]; then
    echo -e "${RED}❌ Failed to remove: ~/.gemini/commands/kiro.toml${NC}"
    ((REMAINING_FILES++))
fi

if [ -f ~/.gemini/commands/kiro-init.toml ]; then
    echo -e "${RED}❌ Failed to remove: ~/.gemini/commands/kiro-init.toml${NC}"
    ((REMAINING_FILES++))
fi

if [ -f ~/.gemini/templates/kiro_template.md ]; then
    echo -e "${RED}❌ Failed to remove: ~/.gemini/templates/kiro_template.md${NC}"
    ((REMAINING_FILES++))
fi

if [ -d ~/.gemini/personas ]; then
    echo -e "${RED}❌ Failed to remove: ~/.gemini/personas${NC}"
    ((REMAINING_FILES++))
fi

echo ""
if [ $REMAINING_FILES -eq 0 ]; then
    echo -e "${GREEN}🎉 Gemini Kiro Style and Persona Library have been successfully uninstalled!${NC}"
else
    echo -e "${RED}❌ Uninstallation completed with errors. ${REMAINING_FILES} files/directories could not be removed.${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📊 Uninstallation Summary:${NC}"
echo -e "  Items removed: ${GREEN}${REMOVED_COUNT}${NC}"
echo -e "  Items not found: ${YELLOW}${MISSING_COUNT}${NC}"
echo -e "  Items remaining: ${RED}${REMAINING_FILES}${NC}"
echo ""

if [ $REMOVED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}📝 The Kiro TAD workflow and Persona Library are no longer available.${NC}"
    echo ""
fi

echo -e "${BLUE}📖 To reinstall, run:${NC}"
echo "  ./gemini-install-global.sh"