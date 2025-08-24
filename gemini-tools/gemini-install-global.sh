#!/bin/bash

# Gemini Kiro Style Global Installation Script with Persona Support
# This script installs Kiro commands, templates, and the full persona library globally for Gemini CLI.

set -e

echo "🚀 Installing Gemini Kiro Style Specification-Driven Development globally..."

# --- Configuration ---
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Persona (Subagent) Configuration
PERSONAS_REPO="https://github.com/davepoon/claude-code-subagents-collection"
MANIFEST_FILE="subagents-manifest.json"

# --- Helper Functions ---
# A simple spinner for long-running operations
show_spinner() {
    local pid=$1
    local message="$2"
    local spinner_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    echo -n "$message "
    while kill -0 "$pid" 2>/dev/null; do
        local char=${spinner_chars:$i:1}
        printf "\r$message %s" "$char"
        i=$(( (i + 1) % ${#spinner_chars} ))
        sleep 0.1
    done
    printf "\r$message ${GREEN}✓${NC}\n"
}

# Helper for formatted headers and items
print_header() {
    local title="$1"; local icon="$2"; local color="$3"
    echo -e "\n${color}${icon} ${title}${NC}"
}

print_item() {
    echo -e "   ${1}"
}


# --- Pre-flight Checks ---
echo -e "${BLUE}🔍 Performing pre-flight checks...${NC}"

# Check if Gemini CLI is installed
if ! command -v gemini &> /dev/null; then
    echo -e "${RED}❌ Gemini CLI is not installed. Please install Gemini CLI first.${NC}"
    echo "Visit: https://github.com/google/generative-ai-tools"
    exit 1
fi

# Check for git
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed. Git is required to download the persona library.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All checks passed.${NC}"

# --- Backup Function ---
create_backup() {
    local backup_dir="$HOME/Desktop/kiro-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [ -d ~/.gemini ]; then
        echo -e "${YELLOW}📦 Existing installation found. Creating backup...${NC}"
        mkdir -p "$backup_dir"
        
        # Backup existing files
        [ -f ~/.gemini/commands/kiro.toml ] && cp ~/.gemini/commands/kiro.toml "$backup_dir/"
        [ -f ~/.gemini/commands/kiro-init.toml ] && cp ~/.gemini/commands/kiro-init.toml "$backup_dir/"
        [ -f ~/.gemini/templates/kiro_template.md ] && cp ~/.gemini/templates/kiro_template.md "$backup_dir/"
        [ -d ~/.gemini/personas ] && cp -r ~/.gemini/personas "$backup_dir/personas-backup/"
        
        echo -e "${GREEN}✅ Backup created at: ${backup_dir}${NC}"
    fi
}

# --- Directory Setup ---
echo -e "${BLUE}📁 Creating global Gemini directories...${NC}"

# Create backup if existing installation found
create_backup

mkdir -p ~/.gemini/commands
mkdir -p ~/.gemini/templates
mkdir -p ~/.gemini/personas # New directory for personas

# --- Kiro Command Installation ---
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

# Copy Kiro template
echo -e "${BLUE}📄 Installing Gemini Kiro template...${NC}"
if [ -f "$SCRIPT_DIR/kiro_template.md" ]; then
    cp "$SCRIPT_DIR/kiro_template.md" ~/.gemini/templates/
    echo -e "${GREEN}✅ Installed Gemini Kiro template${NC}"
else
    echo -e "${RED}❌ Error: kiro_template.md not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# --- Persona Library Installation ---
print_header "Installing Persona Library (Subagents)" "🤖" "$BLUE"
print_item "${GREEN}🎉 SPECIAL THANKS TO @davepoon FOR THE BRILLIANT${NC}"
print_item "   ${GREEN}claude-code-subagents-collection!${NC}"
print_item "${YELLOW}This feature is powered by their incredible contribution.${NC}"

INSTALLATION_PATH="$HOME/.gemini/personas"
TEMP_DIR="/tmp/gemini_personas_$"

# 1. Download the persona repository
echo -e "   -> Downloading from ${PERSONAS_REPO}..."
git clone --depth 1 "$PERSONAS_REPO.git" "$TEMP_DIR/collection" &> /dev/null &
show_spinner $! "      Cloning repository..."

# 2. Copy persona files
echo -e "   -> Installing persona files to ${INSTALLATION_PATH}..."
find "$TEMP_DIR/collection" -name "*.md" -exec cp {} "$INSTALLATION_PATH" \;
PERSONA_COUNT=$(find "$INSTALLATION_PATH" -name "*.md" | wc -l)
echo -e "      ${GREEN}✓ Installed ${PERSONA_COUNT} persona files.${NC}"

# 3. Generate the manifest.json (adapted from enhance-kiro-subagents.sh)
echo -e "   -> Generating persona manifest for fast lookups..."
MANIFEST_PATH="$INSTALLATION_PATH/$MANIFEST_FILE"
TEMP_MANIFEST="/tmp/gemini_manifest_$.json"

# Start JSON structure
echo '{ "version": "1.0.0-gemini", "index": [' > "$TEMP_MANIFEST"

# Process each persona file to build the index
first=true
find "$INSTALLATION_PATH" -name "*.md" -print0 | while IFS= read -r -d '' file; do
    if [[ "$file" == *"$MANIFEST_FILE"* ]]; then continue; fi

    filename=$(basename "$file")
    agent_name="${filename%.md}"

    # Extract purpose from YAML frontmatter or first heading
    purpose=$(awk '/^description:/ {sub(/^description: */, ""); print; exit}' "$file" 2>/dev/null)
    if [[ -z "$purpose" ]]; then
        purpose=$(head -n 10 "$file" | grep -E '^# ' | head -n 1 | sed 's/^#* *//' 2>/dev/null)
    fi
    # Fallback purpose
    if [[ -z "$purpose" ]]; then
        purpose="Specialized AI agent."
    fi

    # Extract specialization
    specialization=$(awk '/^category:/ {sub(/^category: */, ""); print; exit}' "$file" 2>/dev/null || echo "general")

    # Clean and escape for JSON
    purpose=$(echo "$purpose" | tr -d '\r\n' | sed 's/"/\"/g' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    specialization=$(echo "$specialization" | tr -d '\r\n' | sed 's/"/\"/g' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    if [ "$first" = false ]; then
        echo "," >> "$TEMP_MANIFEST"
    fi
    printf '    { "name": "%s", "specialization": "%s", "purpose": "%s", "file_path": "./%s" }' "$agent_name" "$specialization" "$purpose" "$filename" >> "$TEMP_MANIFEST"
    first=false
done

# Close JSON structure
echo "" >> "$TEMP_MANIFEST"
echo "  ]," >> "$TEMP_MANIFEST"
echo "  \"metadata\": { \"total_personas\": ${PERSONA_COUNT} }"
echo "}" >> "$TEMP_MANIFEST"

# Move manifest to final location
mv "$TEMP_MANIFEST" "$MANIFEST_PATH"
echo -e "      ${GREEN}✓ Manifest generated successfully.${NC}"

# 4. Cleanup
rm -rf "$TEMP_DIR"

# --- Final Verification ---
echo -e "\n${BLUE}🔍 Verifying final installation...${NC}"
if [ -f ~/.gemini/commands/kiro.toml ] && [ -f ~/.gemini/personas/subagents-manifest.json ]; then
    echo -e "${GREEN}✅ Core components and Persona Library are installed!${NC}"
else
    echo -e "${RED}❌ Installation failed. Some files are missing.${NC}"
    exit 1
fi

# --- Final Message ---
echo ""
echo -e "${GREEN}🎉 Kiro Style with Persona support is now installed globally!${NC}"
echo ""
echo -e "${YELLOW}🚀 Your /kiro command is now supercharged.${NC}"
echo "   It can now autonomously select from ${PERSONA_COUNT} specialist personas to execute tasks."
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

# Community Attribution
print_header "COMMUNITY ATTRIBUTION" "🙏" "$PURPLE"
print_item "This enhanced integration is powered by the incredible"
print_item "work of ${GREEN} @davepoon${NC} and their brilliant subagent collection."
print_item ""
print_item "${YELLOW}🌟 Please support the community:${NC}"
print_item "• Visit: ${BLUE}${PERSONAS_REPO}${NC}"
print_item "• Give it a ${YELLOW}⭐ star${NC} to show appreciation!"
