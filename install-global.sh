#!/bin/bash

# Kiro Style Global Installation Script
# This script installs Kiro commands and templates globally for Claude Code

set -e

echo "🚀 Installing Kiro Style Specification-Driven Development globally..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}❌ Claude Code is not installed. Please install Claude Code first.${NC}"
    echo "Visit: https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi

# Create global directories
echo -e "${BLUE}📁 Creating global directories...${NC}"
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates

# Copy Kiro commands globally
echo -e "${BLUE}📋 Installing global Kiro commands...${NC}"
cp example-project/.claude/commands/*.md ~/.claude/commands/
echo -e "${GREEN}✅ Copied Kiro commands: kiro.md, kiro-researcher.md, kiro-architect.md, kiro-implementer.md, debugger.md${NC}"

# Copy CLAUDE.md template
echo -e "${BLUE}📄 Installing CLAUDE.md template...${NC}"
cp example-project/CLAUDE.md ~/.claude/templates/kiro-template.md
echo -e "${GREEN}✅ Installed Kiro CLAUDE.md template${NC}"

# Install kiro-init command
echo -e "${BLUE}⚡ Installing kiro-init command...${NC}"
cp global/commands/kiro-init.md ~/.claude/commands/
echo -e "${GREEN}✅ Installed /kiro-init command${NC}"

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"
if [ -f ~/.claude/commands/kiro.md ] && [ -f ~/.claude/commands/kiro-init.md ] && [ -f ~/.claude/templates/kiro-template.md ]; then
    echo -e "${GREEN}✅ Installation successful!${NC}"
else
    echo -e "${RED}❌ Installation failed. Some files are missing.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Kiro Style is now installed globally!${NC}"
echo ""
echo -e "${YELLOW}📝 Available commands:${NC}"
echo "  /kiro [feature-name]     - Full TAD workflow"
echo "  /kiro-researcher [name]  - Requirements specialist"
echo "  /kiro-architect [name]   - Design specialist" 
echo "  /kiro-implementer [name] - Implementation specialist"
echo "  /debugger               - Debugging workflow"
echo "  /kiro-init              - Initialize new project with Kiro"
echo ""
echo -e "${YELLOW}🚀 Usage for new projects:${NC}"
echo "  cd your-new-project/"
echo "  claude"
echo "  /kiro-init"
echo ""
echo -e "${BLUE}📖 For more information, visit:${NC}"
echo "  https://github.com/bizzkoot/kiro_style_claude_code"