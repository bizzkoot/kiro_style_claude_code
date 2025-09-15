#!/bin/bash
# Bear v2 Command and Persona Installer for Gemini CLI
# Version: 2.4.0 - Added Performance File Creation
#
# Fixes:
# - Added creation of agent-performance.json to align with bear.toml protocol.
# - Corrected sed -i syntax for macOS compatibility to resolve "-e: No such file or directory" error.
# - Corrected subshell variable scope issue causing counters (agent_count, converted_count) to fail.
# - Fixed invalid JSON generation by properly handling commas between entries.
# - Improved temporary file/directory creation using mktemp for better security and reliability.
# - Enhanced string escaping for TOML content to prevent corruption.
# - Added a trap to ensure temporary files are cleaned up on script exit or interruption.

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_COMMANDS_DIR="$HOME/.gemini/commands"
GEMINI_PERSONAS_DIR="$HOME/.gemini/personas"
SOURCE_BEAR_TOML="$SCRIPT_DIR/bear.toml"
MANIFEST_FILE="subagents-manifest.json"

# --- Color Codes ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Temporary Directory & Cleanup ---
# Create a secure temporary directory and set a trap to clean it up on exit.
TEMP_DIR=$(mktemp -d)
trap 'rm -rf -- "$TEMP_DIR"' EXIT

# --- Helper Functions ---
print_header() {
    echo -e "\n${BLUE}--- ${1} ---${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}" >&2
}

# --- Spinner Helper ---
# show_spinner: Displays a spinning cursor while a background process is running.
# Arguments:
#   $1 (pid): The process ID of the background job to monitor.
#   $2 (message): The message to display next to the spinner.
show_spinner() {
    local pid=$1
    local message=$2
    local spinstr='|/-\'
    echo -n "$message "
    # Loop while the process exists
    while ps -p "$pid" > /dev/null; do
        local temp=${spinstr#?} # Get the rest of the string after the first char
        printf "[%c]  " "$spinstr" # Print the first char as the spinner
        spinstr=$temp${spinstr%"$temp"} # Move the first char to the end
        sleep 0.1 # Pause for a short duration
        printf "\b\b\b\b\b" # Erase the spinner for the next frame
    done
    printf "    \b\b\b\b" # Clear the final spinner before moving on
}

# --- Installation Logic ---

# install_bear_command: Installs the main /bear command TOML file.
install_bear_command() {
    print_header "Installing /bear command"

    if [ ! -f "$SOURCE_BEAR_TOML" ]; then
        print_error "Source file not found at $SOURCE_BEAR_TOML"
        return 1
    fi

    mkdir -p "$GEMINI_COMMANDS_DIR"
    cp "$SOURCE_BEAR_TOML" "$GEMINI_COMMANDS_DIR/bear.toml"

    if [ -f "$GEMINI_COMMANDS_DIR/bear.toml" ]; then
        print_success "/bear command installed successfully."
    else
        print_error "Failed to install /bear command."
        return 1
    fi
}

# create_performance_file: Initializes the agent-performance.json file.
create_performance_file() {
    print_header "Initializing Agent Performance File"
    local performance_file="$GEMINI_PERSONAS_DIR/agent-performance.json"

    if [ -f "$performance_file" ]; then
        print_info "Agent performance file already exists. Skipping creation."
        return 0
    fi

    # Ensure the personas directory exists
    mkdir -p "$GEMINI_PERSONAS_DIR"

    # Create the file with bootstrap data from bear.toml
    cat > "$performance_file" << 'EOF'
{
  "version": "2.0.0",
  "last_updated": "2025-01-01T00:00:00Z",
  "agents": {
    "backend-architect": {
      "total_tasks": 0,
      "success_rate": 0.85,
      "avg_completion_time": 120,
      "specializations": ["api", "database", "architecture"],
      "performance_by_domain": {}
    },
    "frontend-developer": {
      "total_tasks": 0,
      "success_rate": 0.80,
      "avg_completion_time": 90,
      "specializations": ["react", "ui", "responsive"],
      "performance_by_domain": {}
    }
  },
  "default_selections": {
    "web-development": "backend-architect",
    "ui-design": "frontend-developer",
    "data-processing": "data-engineer",
    "devops": "devops-expert"
  }
}
EOF

    if [ -f "$performance_file" ]; then
        print_success "Agent performance file created successfully."
    else
        print_error "Failed to create agent performance file."
        return 1
    fi
}

# generate_gemini_manifest: Creates the subagents-manifest.json from installed TOML personas.
generate_gemini_manifest() {
    local personas_dir="$1"
    local manifest_path="$personas_dir/$MANIFEST_FILE"
    local temp_manifest
    temp_manifest=$(mktemp "$TEMP_DIR/manifest.json.XXXXXX")

    print_info "Generating agent manifest file..."

    # Start JSON structure
    cat > "$temp_manifest" << EOF
{
  "version": "2.0.0-gemini-bear",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "attribution": "Agents from @davepoon/claude-code-subagents-collection",
  "index": [
EOF

    local first=true
    local agent_count=0
    
    # Use process substitution `< <(find ...)` to avoid creating a subshell for the while loop.
    # This ensures that the 'agent_count' variable is correctly updated in the main script scope.
    while IFS= read -r toml_file; do
        # Skip bear.toml from manifest as it's a command, not a persona for selection
        if [[ "$(basename "$toml_file")" == "bear.toml" ]]; then
            continue
        fi

        local filename
        filename=$(basename "$toml_file")

        # Extract info from .toml file using robust regex
        # Use [:space:] for any whitespace and .*? for non-greedy match of description/category content
        # Add || true to grep to prevent script exit if field is not found (due to set -e)
        local agent_name
        agent_name=$(grep -E '^name[[:space:]]*=[[:space:]]*"([^"]*)"' "$toml_file" | head -1 | sed -E 's/name[[:space:]]*=[[:space:]]*"([^"]*)"/\1/' || true)
        local purpose
        purpose=$(grep -E '^description[[:space:]]*=[[:space:]]*"([^"]*)"' "$toml_file" | head -1 | sed -E 's/description[[:space:]]*=[[:space:]]*"([^"]*)"/\1/' || true)
        local specialization
        specialization=$(grep -E '^category[[:space:]]*=[[:space:]]*"([^"]*)"' "$toml_file" | head -1 | sed -E 's/category[[:space:]]*=[[:space:]]*"([^"]*)"/\1/' || true)


        # Skip if agent_name is empty - this is critical for valid manifest entries
        if [ -z "$agent_name" ]; then
            print_error "Skipping malformed TOML file: $toml_file (could not extract agent name)"
            continue
        fi

        # Clean and escape for JSON
        # Remove newlines, escape double quotes and backslashes.
        # Ensure purpose and specialization are not empty before sed, providing defaults if needed.
        purpose="${purpose:-Specialized AI agent}"
        purpose=$(echo "$purpose" | tr -d '\r\n' | sed 's/"/\\"/g' | sed 's/\\/\\\\/g')
        
        specialization="${specialization:-general-purpose}"
        specialization=$(echo "$specialization" | tr -d '\r\n' | sed 's/"/\\"/g' | sed 's/\\/\\\\/g')

        # Correctly handle comma separation for valid JSON
        if [ "$first" = "true" ]; then
            first=false
        else
            echo "," >> "$temp_manifest"
        fi

        # Use printf to avoid issues with newlines and ensuring proper formatting
        printf '    { "name": "%s", "specialization": "%s", "purpose": "%s", "file_path": "./%s" }' \
            "$agent_name" "$specialization" "$purpose" "$filename" >> "$temp_manifest"
        
        ((agent_count++))
    done < <(find "$personas_dir" -type f -name "*.toml")

    # Close JSON structure
    cat >> "$temp_manifest" << EOF

  ],
  "metadata": {
    "total_agents": $agent_count,
    "bear_version": "2.0.0",
    "manifest_type": "gemini-toml"
  }
}
EOF

    print_info "Attempting JSON validation..."
    # Validate JSON and move to final location
    if command -v python3 >/dev/null 2>&1; then
        if python3 -m json.tool "$temp_manifest" >/dev/null 2>&1; then
            mv "$temp_manifest" "$manifest_path"
            print_success "Manifest created with $agent_count agents."
        else
            print_error "Manifest JSON validation failed. Check the temp file: $temp_manifest"
            return 1
        fi
    else
        print_info "Python 3 not found. Skipping JSON validation."
        mv "$temp_manifest" "$manifest_path"
        print_info "Manifest created (Python for validation not found)."
    fi
}

# install_persona_collection: Downloads and converts the persona collection.
install_persona_collection() {
    print_header "Installing Persona Collection from @davepoon"
    
    local AGENTS_REPO="https://github.com/davepoon/claude-code-subagents-collection.git"
    local repo_clone_dir="$TEMP_DIR/persona_collection"
    
    mkdir -p "$GEMINI_PERSONAS_DIR"

    # Clone repository in the background and show a spinner
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 "$AGENTS_REPO" "$repo_clone_dir" >/dev/null 2>&1 &
    local clone_pid=$!
    show_spinner $clone_pid "Downloading from davepoon/claude-code-subagents-collection..."
    wait $clone_pid

    if ! [ $? -eq 0 ]; then
        print_error "FAILED - Could not clone repository."
        return 1
    fi
    echo -e "${GREEN}✓ SUCCESS${NC} - Repository cloned successfully."

    local subagents_dir="$repo_clone_dir/subagents"
    if [ ! -d "$subagents_dir" ]; then
        print_error "'subagents' directory not found in repository."
        return 1
    fi

    print_info "Converting .md personas to .toml format..."
    local converted_count=0
    # Use process substitution to avoid subshell issues with the 'converted_count' variable.
    while IFS= read -r md_file; do
        local persona_name
        persona_name=$(awk -F': ' '/^name:/ {print $2; exit}' "$md_file" | tr -d '\r')
        
        if [ -z "$persona_name" ]; then
            print_error "Skipping malformed Markdown file: $md_file (could not extract persona name)"
            continue
        fi

        local description
        description=$(awk -F': ' '/^description:/ {print $2; exit}' "$md_file" | tr -d '\r')
        local category
        category=$(awk -F': ' '/^category:/ {print $2; exit}' "$md_file" | tr -d '\r')
        
        # Extract content after the '---' frontmatter
        local prompt_content
        prompt_content=$(sed '1,/^---$/d' "$md_file")
        
        # Escape backslashes for the TOML prompt string
        prompt_content=$(echo "$prompt_content" | sed 's/\\/\\\\/g')
        
        local toml_path="$GEMINI_PERSONAS_DIR/${persona_name//\//_}.toml" # Replace slashes in name

        # Use a quoted here-document (<< 'EOF') to prevent shell from interpreting
        # variables like $prompt_content or any `...` inside the prompt.
        cat > "$toml_path" << 'EOF'
name = "$persona_name"
description = "$description"
category = "$category"
prompt = '''
$prompt_content
'''
EOF
        # Now, use sed to substitute the variables into the template file we just created.
        # This is a safer way to handle complex string content.
        # NOTE: Added '' after -i for macOS compatibility.
        sed -i '' -e "s|\$persona_name|$persona_name|g" \
               -e "s|\$description|$description|g" \
               -e "s|\$category|$category|g" \
               -e "/\$prompt_content/r /dev/stdin" -e "//d" "$toml_path" <<< "$prompt_content"

        ((converted_count++))
    done < <(find "$subagents_dir" -type f -name "*.md")

    print_success "Converted and installed $converted_count personas."

    # Generate the manifest file
    generate_gemini_manifest "$GEMINI_PERSONAS_DIR"
}


# --- Main Execution ---
# install_supporting_personas: Installs core supporting persona files.
install_supporting_personas() {
    print_header "Installing Supporting Personas"
    
    print_info "Installing plan-validator.toml..."
    cp "$SCRIPT_DIR/plan-validator.toml" "$GEMINI_PERSONAS_DIR/plan-validator.toml"

    print_info "Installing knowledge-synthesizer-v2.toml..."
    cp "$SCRIPT_DIR/knowledge-synthesizer-v2.toml" "$GEMINI_PERSONAS_DIR/knowledge-synthesizer-v2.toml"
    
    print_success "Supporting personas installed successfully."
}

# main: Orchestrates the entire installation process.
main() {
    install_bear_command
    install_supporting_personas
    create_performance_file
    install_persona_collection

    print_header "Installation Complete"
    print_success "The /bear command and its persona collection are now available."
    print_info "Start the Gemini CLI and type '/bear \"Your task...\"' to begin."
}

# Run the main function
main
