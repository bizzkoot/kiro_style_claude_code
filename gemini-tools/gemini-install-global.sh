#!/bin/bash

# Gemini Kiro Style Global Installation Script
# This script installs Kiro commands and templates globally for Gemini CLI

set -e

echo "🚀 Installing Gemini Kiro Style Specification-Driven Development globally..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Gemini CLI is installed
if ! command -v gemini &> /dev/null; then
    echo -e "${RED}❌ Gemini CLI is not installed. Please install Gemini CLI first.${NC}"
    echo "Visit: https://github.com/google/generative-ai-tools"
    exit 1
fi

# Create global directories for Gemini
echo -e "${BLUE}📁 Creating global Gemini directories...${NC}"
mkdir -p ~/.gemini/commands
mkdir -p ~/.gemini/templates

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy Gemini Kiro command globally
echo -e "${BLUE}📋 Installing global Kiro command for Gemini...${NC}"
if [ -f "$SCRIPT_DIR/kiro.toml" ]; then
    cp "$SCRIPT_DIR/kiro.toml" ~/.gemini/commands/
    echo -e "${GREEN}✅ Copied Gemini Kiro command: kiro.toml${NC}"
else
    echo -e "${RED}❌ Error: kiro.toml not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Copy Gemini kiro-init command
echo -e "${BLUE}📋 Installing kiro-init command for Gemini...${NC}"
if [ -f "$SCRIPT_DIR/kiro-init.toml" ]; then
    cp "$SCRIPT_DIR/kiro-init.toml" ~/.gemini/commands/
    echo -e "${GREEN}✅ Copied Gemini kiro-init command: kiro-init.toml${NC}"
else
    echo -e "${RED}❌ Error: kiro-init.toml not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Copy CLAUDE.md template (renamed for Gemini)
echo -e "${BLUE}📄 Installing Gemini Kiro template...${NC}"
if [ -f "$SCRIPT_DIR/kiro_template.md" ]; then
    cp "$SCRIPT_DIR/kiro_template.md" ~/.gemini/templates/
    echo -e "${GREEN}✅ Installed Gemini Kiro template${NC}"
else
    echo -e "${RED}❌ Error: kiro_template.md not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Verify installation
echo -e "${BLUE}🔍 Verifying installation...${NC}"
if [ -f ~/.gemini/commands/kiro.toml ] && [ -f ~/.gemini/commands/kiro-init.toml ] && [ -f ~/.gemini/templates/kiro_template.md ]; then
    echo -e "${GREEN}✅ Installation successful!${NC}"
else
    echo -e "${RED}❌ Installation failed. Some files are missing.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Gemini Kiro Style is now installed globally!${NC}"
echo ""
echo -e "${YELLOW}📝 Available commands for Gemini CLI:${NC}"
echo "  /kiro [feature-name]     - Full TAD workflow with EARS syntax"
echo "  /kiro-init              - Initialize new project with Kiro template"
echo ""
echo -e "${YELLOW}🚀 Usage for new projects:${NC}"
echo "  cd your-new-project/"
echo "  gemini"
echo "  /kiro-init"
echo ""
echo -e "${BLUE}📖 For more information, visit:${NC}"
echo "  https://github.com/bizzkoot/kiro_style_claude_code"
echo ""
echo -e "${YELLOW}📋 Installation Details:${NC}"
echo "  Commands installed to: ~/.gemini/commands/"
echo "  Templates installed to: ~/.gemini/templates/"
echo "  Compatible with: Gemini CLI v1.0+"