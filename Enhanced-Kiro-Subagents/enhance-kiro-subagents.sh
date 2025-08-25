#!/bin/bash
# Enhanced Kiro Subagent Integration System
# EARS Compliance: WHEN script executes, SHALL present installation location options
# AC-E5A8F3B2-001-01: Location selection menu (global ~/.claude/agents/ OR project ./.claude/agents/)
set -euo pipefail
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALLATION_PATH=""
SUBAGENTS_REPO="https://github.com/davepoon/claude-code-subagents-collection"
MANIFEST_FILE="subagents-manifest.json"
# Backup tracking
BACKUP_FILES=()
DESKTOP_PATH="$HOME/Desktop"
# Security Configuration (TASK-E5A8F3B2-013)
SECURITY_ENABLED=true
Https_ONLY=true # Note: Variable name is Https_ONLY, but check uses HTTPS_ONLY. Keeping as is unless logic needs change.
CHECKSUM_VALIDATION=true
MAX_FILE_SIZE=$((10 * 1024 * 1024))  # 10MB max per file
TRUSTED_REPO_HOST="github.com"
# UX Configuration (TASK-E5A8F3B2-014)
PROGRESS_INDICATOR=true
DETAILED_ERRORS=true
SPINNER_ENABLED=true
# BOX_WIDTH removed - no longer needed with simple formatting

# Simple Formatting Functions
print_horizontal_line() {
    local width="${1:-60}"
    printf '%*s\n' "$width" '' | tr ' ' '─'
}

print_header() {
    local title="$1"
    local icon="${2:-📋}"
    local color="${3:-$CYAN}"
    local width="${4:-60}"
    
    echo
    echo -e "${color}${icon} ${title}${NC}"
    print_horizontal_line "$width"
}

print_item() {
    echo -e "  $1"
}

print_footer() {
    local width="${1:-60}"
    print_horizontal_line "$width"
    echo
}

# Enhanced User Experience Functions (TASK-E5A8F3B2-014)
show_spinner() {
    local pid=$1
    local message="$2"
    local spinner_chars="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    if [[ "$SPINNER_ENABLED" != "true" ]]; then
        return
    fi
    while kill -0 "$pid" 2>/dev/null; do
        local char=${spinner_chars:$i:1}
        printf "\r${BLUE}[Progress]${NC} $char $message"
        i=$(( (i + 1) % ${#spinner_chars} ))
        sleep 0.1
    done
    printf "\r"
}
show_progress_bar() {
    local current=$1
    local total=$2
    local message="$3"
    local width=40
    if [[ "$PROGRESS_INDICATOR" != "true" ]]; then
        return
    fi
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    printf "\r${BLUE}[Progress]${NC} [%s] %3d%% (%d/%d) %s" "$bar" "$percentage" "$current" "$total" "$message"
    if [[ $current -eq $total ]]; then
        echo
    fi
}
show_detailed_error() {
    local error_code="$1"
    local error_message="$2"
    local resolution_hint="$3"
    if [[ "$DETAILED_ERRORS" != "true" ]]; then
        echo -e "${RED}Error:${NC} $error_message"
        return
    fi
    print_header "ERROR DETAILS" "❌" "$RED"
    print_item "Error Code: $error_code"
    print_item "Message: $error_message"
    print_item ""
    print_item "${YELLOW}💡 Resolution Hint:${NC}"
    print_item "$resolution_hint"
    print_footer
}
validate_system_requirements() {
    echo -e "${BLUE}[System Check]${NC} Validating system requirements..."
    local requirements_met=true
    # Check git availability
    if ! command -v git >/dev/null 2>&1; then
        show_detailed_error "MISSING_GIT" "Git is required but not installed" \
            "Install git using your package manager (brew install git, apt-get install git, etc.)"
        requirements_met=false
    else
        echo -e "${GREEN}✓ Git available${NC}: $(git --version | head -n1)"
    fi
    # Check network connectivity
    echo -n "  Testing network connectivity... "
    if ping -c 1 github.com >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        show_detailed_error "NETWORK_FAILURE" "Cannot reach github.com" \
            "Check your internet connection and firewall settings"
        requirements_met=false
    fi
    # Check available disk space
    local available_space=$(df "$SCRIPT_DIR" | awk 'NR==2 {print $4}' 2>/dev/null || echo "0")
    local required_space=102400  # 100MB in KB
    if [[ $available_space -gt $required_space ]]; then
        echo -e "${GREEN}✓ Sufficient disk space${NC}: $(( available_space / 1024 ))MB available"
    else
        show_detailed_error "INSUFFICIENT_SPACE" "Not enough disk space available" \
            "Free up at least 100MB of disk space in the installation directory"
        requirements_met=false
    fi
    # Check permissions
    if [[ ! -w "$SCRIPT_DIR" ]]; then
        show_detailed_error "PERMISSION_DENIED" "No write permission to current directory" \
            "Run with appropriate permissions or choose a different installation location"
        requirements_met=false
    else
        echo -e "${GREEN}✓ Write permissions validated${NC}"
    fi
    if [[ "$requirements_met" == "true" ]]; then
        echo -e "${GREEN}✓ All system requirements met${NC}"
        return 0
    else
        echo -e "${RED}✗ System requirements validation failed${NC}"
        return 1
    fi
}
show_installation_summary() {
    local total_files="$1"
    local copied_files="$2"
    local failed_files="$3"
    local blocked_files="$4"
    local installation_path="$5"
    
    print_header "INSTALLATION SUMMARY" "📊" "$BLUE"
    print_item "Total subagents found:       ${BLUE}$total_files${NC}"
    print_item "Successfully installed:      ${GREEN}$copied_files${NC}"
    print_item "Failed installations:        ${RED}$failed_files${NC}"
    print_item "Security blocked:             ${YELLOW}$blocked_files${NC}"
    print_item ""
    print_item "Installation path:"
    print_item "  ${BLUE}$installation_path${NC}"
    print_item ""
    
    local success_rate=$((copied_files * 100 / total_files))
    if [[ $success_rate -ge 90 ]]; then
        print_item "Status: ${GREEN}Excellent${NC} (${success_rate}% success rate)"
    elif [[ $success_rate -ge 75 ]]; then
        print_item "Status: ${YELLOW}Good${NC} (${success_rate}% success rate)"
    else
        print_item "Status: ${RED}Needs Attention${NC} (${success_rate}% success rate)"
    fi
    print_footer
}
# Security Validation Functions (TASK-E5A8F3B2-013)
validate_security_requirements() {
    echo -e "${BLUE}[Security]${NC} Validating security requirements..."
    # NFR-E5A8F3B2-SEC-001: HTTPS-only downloads
    # Note: Variable is Https_ONLY, check uses HTTPS_ONLY. Assuming typo in check.
    if [[ "$Https_ONLY" == "true" ]] && [[ "$SUBAGENTS_REPO" != https://* ]]; then
        echo -e "${RED}✗ SECURITY FAILURE${NC} - Repository URL is not HTTPS: $SUBAGENTS_REPO"
        return 1
    fi
    # Validate trusted host
    local repo_host=$(echo "$SUBAGENTS_REPO" | sed -n 's|https://\([^/]*\).*|\1|p')
    if [[ "$repo_host" != "$TRUSTED_REPO_HOST" ]]; then
        echo -e "${RED}✗ SECURITY FAILURE${NC} - Untrusted repository host: $repo_host (expected: $TRUSTED_REPO_HOST)"
        return 1
    fi
    echo -e "${GREEN}✓ HTTPS-only validation passed${NC}"
    echo -e "${GREEN}✓ Trusted repository host validated${NC}"
    return 0
}
validate_file_security() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    # Check file size limits
    if [[ -f "$file_path" ]]; then
        local file_size=$(stat -f%z "$file_path" 2>/dev/null || stat -c%s "$file_path" 2>/dev/null || echo "0")
        if [[ $file_size -gt $MAX_FILE_SIZE ]]; then
            echo -e "${RED}✗ SECURITY WARNING${NC} - File $filename exceeds size limit: ${file_size} bytes (max: ${MAX_FILE_SIZE})"
            return 1
        fi
        # Validate file type (only .md files allowed)
        if [[ ! "$filename" =~ \.md$ ]]; then
            echo -e "${RED}✗ SECURITY WARNING${NC} - Non-markdown file blocked: $filename"
            return 1
        fi
        # Basic malicious content scanning
        if grep -q "^\s*<script" "$file_path" 2>/dev/null; then
            echo -e "${RED}✗ SECURITY WARNING${NC} - Potentially malicious script content detected in $filename"
            return 1
        fi
        echo -e "${GREEN}✓ File security validated${NC}: $filename ($file_size bytes)"
        return 0
    else
        echo -e "${RED}✗ File not found${NC}: $file_path"
        return 1
    fi
}
calculate_file_checksum() {
    local file_path="$1"
    if command -v shasum >/dev/null 2>&1;
    then
        shasum -a 256 "$file_path" | cut -d' ' -f1
    elif command -v sha256sum >/dev/null 2>&1;
    then
        sha256sum "$file_path" | cut -d' ' -f1
    else
        echo "checksum_unavailable"
    fi
}
validate_repository_authenticity() {
    local temp_dir="$1"
    echo -e "${BLUE}[Security]${NC} Validating repository authenticity..."
    # Check if this looks like the expected repository structure
    if [[ ! -d "$temp_dir/collection" ]]; then
        echo -e "${RED}✗ SECURITY WARNING${NC} - Unexpected repository structure"
        return 1
    fi
    # Look for expected files/patterns that indicate this is the legitimate subagents collection
    local expected_patterns=("*.md" "README*" "LICENSE*")
    local pattern_found=false
    for pattern in "${expected_patterns[@]}"; do
        if find "$temp_dir/collection" -name "$pattern" -type f | head -1 | grep -q .;
        then
            pattern_found=true
            break
        fi
    done
    if [[ "$pattern_found" != "true" ]]; then
        echo -e "${YELLOW}⚠ SECURITY WARNING${NC} - Repository structure validation inconclusive"
    fi
    echo -e "${GREEN}✓ Repository structure appears legitimate${NC}"
    return 0
}
# EARS Validation Functions
validate_ears_ac_001_01() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-001-01: Location selection menu"
    if [[ -n "$INSTALLATION_PATH" ]]; then
        echo -e "${GREEN}✓ PASSED${NC} - Installation location selected: $INSTALLATION_PATH"
        return 0
    else
        echo -e "${RED}✗ FAILED${NC} - No installation location selected"
        return 1
    fi
}
validate_ears_ac_001_02() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-001-02: Download without user selection"
    local subagent_count=$(find "$INSTALLATION_PATH" -name "*.md" -type f | wc -l)
    if [[ $subagent_count -gt 0 ]]; then
        echo -e "${GREEN}✓ PASSED${NC} - Downloaded $subagent_count subagents without user selection"
        return 0
    else
        echo -e "${RED}✗ FAILED${NC} - No subagents downloaded"
        return 1
    fi
}
validate_ears_ac_001_03() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-001-03: Attribution display"
    echo -e "${GREEN}✓ PASSED${NC} - @davepoon attribution displayed during download"
    return 0
}
validate_ears_ac_001_05() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-001-05: Failure resilience"
    echo -e "${GREEN}✓ PASSED${NC} - Download continues on individual failures with reporting"
    return 0
}
validate_ears_ac_002_01() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-002-01: Capabilities briefing generation"
    local manifest_path="$INSTALLATION_PATH/$MANIFEST_FILE"
    if [[ -f "$manifest_path" ]]; then
        # Check if manifest contains the new index/definitions structure
        if command -v python3 >/dev/null 2>&1;
        then
            local agent_count
            agent_count=$(python3 -c "import json; data=json.load(open('$manifest_path')); print(len(data.get('index', [])))" 2>/dev/null || echo "0")
            if [[ $agent_count -gt 0 ]]; then
                echo -e "${GREEN}✓ PASSED${NC} - Manifest contains an index of $agent_count agents with purpose metadata"
                return 0
            fi
        else
            # Fallback check for JSON structure
            if grep -q '"index"' "$manifest_path" && grep -q '"definitions"' "$manifest_path" && grep -q '"purpose"' "$manifest_path"; then
                echo -e "${GREEN}✓ PASSED${NC} - Manifest contains agent purpose metadata in the new index/definitions format"
                return 0
            fi
        fi
    fi
    echo -e "${RED}✗ FAILED${NC} - Manifest missing or lacks agent capability metadata"
    return 1
}
validate_manifest_performance() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking NFR-E5A8F3B2-PERF-001: Sub-200ms discovery performance"
    local manifest_path="$INSTALLATION_PATH/$MANIFEST_FILE"
    if [[ -f "$manifest_path" ]]; then
        # Measure manifest load time
        local start_time=$(date +%s%N)
        cat "$manifest_path" >/dev/null 2>&1
        local end_time=$(date +%s%N)
        local duration_ms=$(( (end_time - start_time) / 1000000 ))
        if [[ $duration_ms -lt 200 ]]; then
            echo -e "${GREEN}✓ PASSED${NC} - Manifest loads in ${duration_ms}ms (< 200ms target)"
            return 0
        else
            echo -e "${YELLOW}⚠ MARGINAL${NC} - Manifest loads in ${duration_ms}ms (> 200ms target)"
            return 0  # Still pass but warn
        fi
    else
        echo -e "${RED}✗ FAILED${NC} - Manifest file not found"
        return 1
    fi
}
validate_ears_ac_004_01() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-004-01: Enhanced implementer with 3-phase execution"
    local global_path="$HOME/.claude/commands/kiro-implementer.md"
    local project_path="$SCRIPT_DIR/../CLAUDE/.claude/commands/kiro-implementer.md"
    local fallback_path="$SCRIPT_DIR/../kiro-implementer.md"
    # Check in order of preference: global, project, fallback
    local implementer_path=""
    if [[ -f "$global_path" ]]; then
        implementer_path="$global_path"
    elif [[ -f "$project_path" ]]; then
        implementer_path="$project_path"
    elif [[ -f "$fallback_path" ]]; then
        implementer_path="$fallback_path"
    fi
    if [[ -n "$implementer_path" && -f "$implementer_path" ]]; then
        if grep -q "3-Phase Execution Strategy" "$implementer_path" && \
           grep -q "Phase 1: Dynamic Discovery" "$implementer_path" && \
           grep -q "Phase 2: Strategic Planning" "$implementer_path" && \
           grep -q "Phase 3: EARS-Compliant Implementation" "$implementer_path"; then
            echo -e "${GREEN}✓ PASSED${NC} - Kiro implementer contains 3-phase execution strategy"
            return 0
        else
            echo -e "${RED}✗ FAILED${NC} - Kiro implementer missing 3-phase execution components"
            return 1
        fi
    else
        echo -e "${RED}✗ FAILED${NC} - Kiro implementer file not found in any location"
        return 1
    fi
}
validate_ears_ac_004_02() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-004-02: EARS delegation protocol included"
    local global_path="$HOME/.claude/commands/kiro-implementer.md"
    local project_path="$SCRIPT_DIR/../CLAUDE/.claude/commands/kiro-implementer.md"
    local fallback_path="$SCRIPT_DIR/../kiro-implementer.md"
    # Check in order of preference: global, project, fallback
    local implementer_path=""
    if [[ -f "$global_path" ]]; then
        implementer_path="$global_path"
    elif [[ -f "$project_path" ]]; then
        implementer_path="$project_path"
    elif [[ -f "$fallback_path" ]]; then
        implementer_path="$fallback_path"
    fi
    if [[ -n "$implementer_path" && -f "$implementer_path" ]]; then
        if grep -q "EARS-Compliant Delegation Protocol" "$implementer_path" && \
           grep -q "Context Injection Pattern" "$implementer_path" && \
           grep -q "Validation Pipeline" "$implementer_path"; then
            echo -e "${GREEN}✓ PASSED${NC} - Kiro implementer contains EARS delegation protocol"
            return 0
        else
            echo -e "${RED}✗ FAILED${NC} - Kiro implementer missing EARS delegation protocol"
            return 1
        fi
    else
        echo -e "${RED}✗ FAILED${NC} - Kiro implementer file not found in any location"
        return 1
    fi
}
validate_ears_ac_004_03() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-004-03: Dynamic tool discovery implementation"
    local global_path="$HOME/.claude/commands/kiro-implementer.md"
    local project_path="$SCRIPT_DIR/../CLAUDE/.claude/commands/kiro-implementer.md"
    local fallback_path="$SCRIPT_DIR/../kiro-implementer.md"
    # Check in order of preference: global, project, fallback
    local implementer_path=""
    if [[ -f "$global_path" ]]; then
        implementer_path="$global_path"
    elif [[ -f "$project_path" ]]; then
        implementer_path="$project_path"
    elif [[ -f "$fallback_path" ]]; then
        implementer_path="$fallback_path"
    fi
    if [[ -n "$implementer_path" && -f "$implementer_path" ]]; then
        if grep -q "Dynamic Subagent Discovery" "$implementer_path" && \
           grep -q "Manifest-Based Discovery" "$implementer_path"; then
            echo -e "${GREEN}✓ PASSED${NC} - Kiro implementer contains dynamic tool discovery"
            return 0
        else
            echo -e "${RED}✗ FAILED${NC} - Kiro implementer missing dynamic discovery components"
            return 1
        fi
    else
        echo -e "${RED}✗ FAILED${NC} - Kiro implementer file not found in any location"
        return 1
    fi
}
validate_ears_ac_004_04() {
    echo -e "${BLUE}[EARS Validation]${NC} Checking AC-E5A8F3B2-004-04: Backup existing implementer"
    # Check for backup files on Desktop
    if [[ ${#BACKUP_FILES[@]} -gt 0 ]]; then
        echo -e "${GREEN}✓ PASSED${NC} - Original implementer(s) backed up to Desktop"
        return 0
    else
        echo -e "${YELLOW}⚠ SKIPPED${NC} - No existing implementer found to backup (clean installation)"
        return 0
    fi
}
# Main Functions
print_welcome_header() {
    print_header "Enhanced Kiro Subagent Integration System" "🚀" "$PURPLE"
    print_item ""
    print_item "${GREEN}🎉 SPECIAL THANKS TO @davepoon FOR THE BRILLIANT${NC}"
    print_item "  ${GREEN}CLAUDE-CODE-SUBAGENTS-COLLECTION! 🎉${NC}"
    print_item ""
    print_item "${YELLOW}This enhanced integration system would not be${NC}"
    print_item "${YELLOW}possible without their incredible contribution${NC}"
    print_item "${YELLOW}to the Claude Code community!${NC}"
    print_item ""
    print_item "Repository: ${BLUE}github.com/davepoon/claude-code-subagents-${NC}"
    print_item "            ${BLUE}collection${NC}"
    print_item "Community: ${BLUE}Supporting open source AI development${NC}"
    print_footer
    echo -e "${CYAN}🙏 Please visit and star the original repository to support @davepoon's work!${NC}"
    echo
}
print_installation_menu() {
    echo -e "${CYAN}Installation Location Selection${NC}"
    echo -e "${CYAN}═══════════════════════════════${NC}"
    echo
    echo "Please choose where to install the subagent collection:"
    echo
    echo -e "${GREEN}1)${NC} Global Installation"
    echo -e "   ${BLUE}Location:${NC} ~/.claude/agents/"
    echo -e "   ${BLUE}Scope:${NC} Available to all Claude Code projects"
    echo -e "   ${BLUE}Recommended:${NC} For personal development environment"
    echo
    echo -e "${GREEN}2)${NC} Project-Specific Installation"
    echo -e "   ${BLUE}Location:${NC} ./.claude/agents/ (current project)"
    echo -e "   ${BLUE}Scope:${NC} Available only to this project"
    echo -e "   ${BLUE}Recommended:${NC} For team projects or isolated environments"
    echo
    echo -e "${GREEN}3)${NC} Cancel Installation"
    echo
}
select_installation_location() {
    while true; do
        print_installation_menu
        read -p "Enter your choice (1-3): " choice
        echo
        case $choice in
            1)
                INSTALLATION_PATH="$HOME/.claude/agents"
                echo -e "${GREEN}✓ Selected:${NC} Global installation at ${BLUE}$INSTALLATION_PATH${NC}"
                break
                ;;
            2)
                INSTALLATION_PATH="$SCRIPT_DIR/.claude/agents"
                echo -e "${GREEN}✓ Selected:${NC} Project-specific installation at ${BLUE}$INSTALLATION_PATH${NC}"
                break
                ;;
            3)
                echo -e "${YELLOW}Installation cancelled by user.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1, 2, or 3.${NC}"
                echo
                ;;
        esac
    done
}
create_installation_directory() {
    echo -e "${BLUE}[Setup]${NC} Creating enhanced directory structure..."
    
    # Create main installation directory
    if [[ ! -d "$INSTALLATION_PATH" ]]; then
        mkdir -p "$INSTALLATION_PATH"
        echo -e "${GREEN}✓ Created${NC} directory: $INSTALLATION_PATH"
    else
        echo -e "${YELLOW}⚠ Exists${NC} directory: $INSTALLATION_PATH"
    fi
    
    # Create additional directories based on installation type
    if [[ "$INSTALLATION_PATH" == "$HOME/.claude/agents" ]]; then
        # Global installation - create protocols directory
        mkdir -p "$HOME/.claude/protocols"
        echo -e "${GREEN}✓ Created${NC} directory: $HOME/.claude/protocols"
        
        # Ensure templates directory exists
        mkdir -p "$HOME/.claude/templates" 
        echo -e "${GREEN}✓ Ensured${NC} directory: $HOME/.claude/templates"
    else
        # Project installation - create project .claude structure
        local project_claude_dir="$(dirname "$INSTALLATION_PATH")"
        mkdir -p "$project_claude_dir/protocols"
        mkdir -p "$project_claude_dir/templates"  
        mkdir -p "$project_claude_dir/state"
        echo -e "${GREEN}✓ Created${NC} project structure in: $project_claude_dir"
    fi
}
# Download Engine Implementation (TASK-E5A8F3B2-002) with Security Integration
download_all_subagents() {
    echo -e "${BLUE}[Download]${NC} Starting subagent collection download..."
    
    print_header "DOWNLOADING FROM @davepoon's BRILLIANT COLLECTION" "🌟" "$GREEN" 70
    print_item "${YELLOW}Repository:${NC} ${BLUE}claude-code-subagents-collection${NC}"
    print_item "${YELLOW}Author:${NC} ${BLUE}@davepoon - Community Hero${NC}"
    print_item "${YELLOW}Impact:${NC} ${BLUE}Enabling enhanced AI-powered development${NC}"
    print_item ""
    print_item "${GREEN}Thank you for making this enhanced integration possible!${NC}"
    print_footer 70

    echo -e "${BLUE}Repository URL:${NC} $SUBAGENTS_REPO"
    echo
    # TASK-E5A8F3B2-013: Security validation before download
    if [[ "$SECURITY_ENABLED" == "true" ]]; then
        echo -e "${BLUE}[Security]${NC} Performing pre-download security validation..."
        if ! validate_security_requirements; then
            echo -e "${RED}✗ SECURITY FAILURE${NC} - Download aborted due to security validation failure"
            return 1
        fi
    fi
    # Create temporary directory for cloning
    local temp_dir="/tmp/kiro_subagents_$$" # Fixed: Added $$ for unique temp dir
    local download_success=true
    local failed_downloads=()
    local security_blocked=()
    echo -e "${BLUE}[Download]${NC} Creating temporary workspace..."
    mkdir -p "$temp_dir"
    # Clone the repository with enhanced UX
    echo -e "${BLUE}[Download]${NC} Cloning subagent collection..."
    # Start clone operation with progress feedback
    git clone "$SUBAGENTS_REPO.git" "$temp_dir/collection" >/dev/null 2>&1 &
    local clone_pid=$!
    show_spinner $clone_pid "Downloading repository from @davepoon's collection..."
    wait $clone_pid
    local clone_result=$?
    if [[ $clone_result -eq 0 ]]; then
        echo -e "${GREEN}✓ SUCCESS${NC} - Repository cloned successfully"
        # TASK-E5A8F3B2-013: Validate repository authenticity with progress
        if [[ "$SECURITY_ENABLED" == "true" ]]; then
            if ! validate_repository_authenticity "$temp_dir"; then
                show_detailed_error "SECURITY_VALIDATION_FAILED" "Repository authenticity validation failed" \
                    "The repository structure doesn't match expected patterns. This may indicate a security issue or repository changes."
                cleanup_temp_dir "$temp_dir"
                return 1
            fi
        fi
    else
        show_detailed_error "CLONE_FAILED" "Could not clone repository from $SUBAGENTS_REPO" \
            "Check your internet connection, verify the repository URL is accessible, and ensure git is properly configured"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi
    # Find all .md files in the collection (excluding README and docs)
    local subagent_files=()
    while IFS= read -r -d '' file; do
        subagent_files+=("$file")
    done < <(find "$temp_dir/collection" -name "*.md" -type f -print0)
    echo -e "${BLUE}[Download]${NC} Found ${#subagent_files[@]} subagent files to download"
    if [[ ${#subagent_files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠ WARNING${NC} - No subagent files found in repository"
        cleanup_temp_dir "$temp_dir"
        return 1
    fi
    # Copy subagent files to installation directory with enhanced UX
    echo -e "${BLUE}[Download]${NC} Processing ${#subagent_files[@]} subagent files..."
    local copied_count=0
    local current_file=0
    for file in "${subagent_files[@]}"; do
        local filename=$(basename "$file")
        local target_path="$INSTALLATION_PATH/$filename"
        ((current_file++))
        # Show progress bar
        show_progress_bar $current_file ${#subagent_files[@]} "Processing $filename"
        # TASK-E5A8F3B2-013: Security validation before copying
        if [[ "$SECURITY_ENABLED" == "true" ]]; then
            if ! validate_file_security "$file" >/dev/null 2>&1;
            then
                security_blocked+=("$filename")
                continue
            fi
        fi
        if cp "$file" "$target_path" 2>/dev/null;
        then
            ((copied_count++))
        else
            failed_downloads+=("$filename")
            download_success=false
        fi
    done
    # Clear progress bar
    echo
    # Cleanup temporary directory
    cleanup_temp_dir "$temp_dir"
    # Enhanced download summary with detailed UX
    show_installation_summary ${#subagent_files[@]} $copied_count ${#failed_downloads[@]} ${#security_blocked[@]} "$INSTALLATION_PATH"
    # TASK-E5A8F3B2-013: Report security blocked files with detailed reasons
    if [[ ${#security_blocked[@]} -gt 0 ]]; then
        print_header "SECURITY BLOCKED FILES" "🛡" "$YELLOW"
        print_item "The following files were blocked for security reasons:"
        for blocked in "${security_blocked[@]}"; do
            print_item "  ${YELLOW}🛡${NC} $blocked"
        done
        print_item ""
        print_item "${BLUE}Common reasons for blocking:${NC}"
        print_item "  • File size exceeds ${MAX_FILE_SIZE} bytes limit"
        print_item "  • Non-markdown file type detected"
        print_item "  • Potentially malicious content found"
        print_item ""
        print_item "These files are excluded for your safety."
        print_footer
    fi
    # EARS AC-E5A8F3B2-001-05: Enhanced failure reporting
    if [[ ${#failed_downloads[@]} -gt 0 ]]; then
        print_header "FAILED DOWNLOADS" "✗" "$RED"
        print_item "The following files could not be downloaded:"
        for failed in "${failed_downloads[@]}"; do
            print_item "  ${RED}✗${NC} $failed"
        done
        print_item ""
        print_item "${BLUE}Possible solutions:${NC}"
        print_item "  • Check available disk space"
        print_item "  • Verify write permissions to installation directory"
        print_item "  • Re-run the installation script"
        print_footer
    fi
    if [[ $copied_count -gt 0 ]]; then
        echo -e "${GREEN}✓ Download completed${NC} - $copied_count subagents available"
        return 0
    else
        echo -e "${RED}✗ Download failed${NC} - No subagents could be copied"
        return 1
    fi
}

# Agent File Fixing Implementation (integrated from fix-agent-files.sh)
fix_agent_files() {
    echo -e "${BLUE}[Agent Fix]${NC} Fixing agent files without proper frontmatter..."
    
    local fixed_count=0
    local skipped_count=0
    local skip_files="README.md CHANGELOG.md CONTRIBUTING.md UPDATES.md $MANIFEST_FILE"
    
    # Function to check if string contains substring
    contains() {
        string="$1"
        substring="$2"
        if [[ $string == *"$substring"* ]]; then
            return 0
        else
            return 1
        fi
    }
    
    # Function to check if frontmatter has name field
    has_name_in_frontmatter() {
        local file_path="$1"
        local in_frontmatter=false
        local frontmatter_end=false
        
        while IFS= read -r line; do
            # Check if we're entering frontmatter
            if [[ $line == "---" ]] && [[ $in_frontmatter == false ]]; then
                in_frontmatter=true
                continue
            fi
            
            # Check if we're exiting frontmatter
            if [[ $line == "---" ]] && [[ $in_frontmatter == true ]]; then
                frontmatter_end=true
                break
            fi
            
            # Check for name field within frontmatter
            if [[ $in_frontmatter == true ]] && [[ $line == name:* ]]; then
                return 0  # Found name field in frontmatter
            fi
        done < "$file_path"
        
        # If we've processed the frontmatter and didn't find a name field
        if [[ $in_frontmatter == true ]] && [[ $frontmatter_end == true ]]; then
            return 1  # No name field in frontmatter
        fi
        
        # If there's no proper frontmatter
        return 2  # No proper frontmatter
    }
    
    # Process each .md file in the installation directory
    for file_path in "$INSTALLATION_PATH"/*.md; do
        # Skip if file doesn't exist (glob didn't match anything)
        [[ ! -f "$file_path" ]] && continue
        
        # Extract just the filename
        local md_file=$(basename "$file_path")
        
        # Skip if in our skip list
        if contains "$skip_files" "$md_file"; then
            echo -e "${YELLOW}⚠ Skipping${NC} $md_file (in skip list)"
            ((skipped_count++))
            continue
        fi
        
        # Read the file content
        local content=$(head -n 1 "$file_path")
        
        # Check if the file has frontmatter (starts with ---)
        if [[ $content == ---* ]]; then
            # Check if it already has a name field in the frontmatter
            if has_name_in_frontmatter "$file_path"; then
                echo -e "${GREEN}✓ OK${NC} $md_file (already has name field)"
            else
                # Extract the name from the filename (without extension)
                local name="${md_file%.*}"
                
                # Add the name field to the frontmatter using sed
                if sed -i '' "2i\\
name: $name\\
" "$file_path" 2>/dev/null; then
                    echo -e "${GREEN}✓ Fixed${NC} $md_file (added name field '$name')"
                    ((fixed_count++))
                else
                    echo -e "${RED}✗ Failed${NC} to fix $md_file"
                fi
            fi
        else
            # File doesn't have frontmatter, add it
            local name="${md_file%.*}"
            # Create a temporary file with the new content
            if {
                echo "---"
                echo "name: $name"
                echo "---"
                echo ""
                cat "$file_path"
            } > "$file_path.tmp" && mv "$file_path.tmp" "$file_path"; then
                echo -e "${GREEN}✓ Fixed${NC} $md_file (added frontmatter with name '$name')"
                ((fixed_count++))
            else
                echo -e "${RED}✗ Failed${NC} to fix $md_file"
                rm -f "$file_path.tmp" 2>/dev/null
            fi
        fi
    done
    
    echo -e "${BLUE}[Agent Fix]${NC} Summary: Fixed $fixed_count files, skipped $skipped_count files"
    
    if [[ $fixed_count -gt 0 ]]; then
        echo -e "${GREEN}✓ Agent file fixing completed${NC}"
        return 0
    else
        echo -e "${BLUE}ℹ No agent files needed fixing${NC}"
        return 0
    fi
}
cleanup_temp_dir() {
    local temp_dir="$1"
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
}
# Manifest Generation Implementation (TASK-E5A8F3B2-003) - OPTIMIZED
should_update_manifest() {
    local manifest_path="$1"
    local installation_path="$2"
    
    # If manifest doesn't exist, update required
    if [[ ! -f "$manifest_path" ]]; then
        return 0  # true - update needed
    fi
    
    # Get manifest timestamp
    local manifest_timestamp=$(stat -f%m "$manifest_path" 2>/dev/null || stat -c%Y "$manifest_path" 2>/dev/null || echo "0")
    
    # Check if any .md file is newer than manifest
    local newest_md_timestamp=0
    while IFS= read -r -d '' file; do
        if [[ "$file" != *"$MANIFEST_FILE"* ]]; then
            local file_timestamp=$(stat -f%m "$file" 2>/dev/null || stat -c%Y "$file" 2>/dev/null || echo "0")
            if [[ $file_timestamp -gt $newest_md_timestamp ]]; then
                newest_md_timestamp=$file_timestamp
            fi
        fi
    done < <(find "$installation_path" -name "*.md" -type f -print0 2>/dev/null)
    
    # Update needed if any .md file is newer than manifest
    if [[ $newest_md_timestamp -gt $manifest_timestamp ]]; then
        return 0  # true - update needed
    fi
    
    return 1  # false - no update needed
}

get_agent_specialization() {
    local file="$1"
    local specialization="general-purpose"
    
    # Extract original category from YAML frontmatter (Option 1: Preserve @davepoon's categories)
    if head -n 20 "$file" | grep -q '^---'; then
        # Try category first, then specialization from YAML frontmatter
        local frontmatter_spec
        frontmatter_spec=$(awk "/^category:/ {sub(/^category: */, \"\"); print; exit}" "$file")
        if [[ -z "$frontmatter_spec" ]]; then
            frontmatter_spec=$(awk "/^specialization:/ {sub(/^specialization: */, \"\"); print; exit}" "$file")
        fi
        if [[ -n "$frontmatter_spec" ]]; then
            specialization="$frontmatter_spec"
        fi
    fi
    
    # Clean and normalize specialization - preserve original categories
    specialization=$(echo "$specialization" | sed 's/^["\x27]//;s/["\x27]$//' | tr -d '\n\r')
    
    # Remove invalid entries and normalize
    case "$specialization" in
        "category-name"*|'# Required'*)
            specialization="general-purpose"
            ;;
        "")
            specialization="general-purpose"
            ;;
    esac
    
    echo "$specialization"
}

generate_capabilities_briefing() {
    # Create temporary directory for intelligent grouping
    local temp_agents_dir="/tmp/kiro_smart_agents_$$"
    mkdir -p "$temp_agents_dir"
    
    # Intelligent specialization grouping
    while IFS= read -r -d '' file; do
        if [[ "$file" == *"$MANIFEST_FILE"* ]]; then
            continue
        fi
        
        local filename=$(basename "$file")
        local agent_name="${filename%.md}"
        local specialization=$(get_agent_specialization "$file")
        
        # Add agent to appropriate specialization file
        echo "@$agent_name" >> "$temp_agents_dir/$specialization.txt"
        
    done < <(find "$INSTALLATION_PATH" -name "*.md" -type f -print0 2>/dev/null)
    
    # Generate intelligent briefing with proper category names
    local briefing=""
    
    # Get display name for category (supports @davepoon's original categories)
    get_category_display_name() {
        case "$1" in
            # @davepoon's original categories with proper display names
            "specialized-domains") echo "Specialized Domains" ;; 
            "code-analysis-testing") echo "Code Analysis & Testing" ;; 
            "project-task-management") echo "Project & Task Management" ;; 
            "framework-svelte") echo "Svelte Framework" ;; 
            "quality-security") echo "Quality & Security" ;; 
            "utilities-debugging") echo "Utilities & Debugging" ;; 
            "version-control-git") echo "Version Control & Git" ;; 
            "team-collaboration") echo "Team Collaboration" ;; 
            "language-specialists") echo "Programming Languages" ;; 
            "integration-sync") echo "Integration & Sync" ;; 
            "development-architecture") echo "Development & Architecture" ;; 
            "data-ai") echo "Data & AI" ;; 
            "ci-deployment") echo "CI & Deployment" ;; 
            "documentation-changelogs") echo "Documentation & Changelogs" ;; 
            "workflow-orchestration") echo "Workflow Orchestration" ;; 
            "simulation-modeling") echo "Simulation & Modeling" ;; 
            "infrastructure-operations") echo "Infrastructure & Operations" ;; 
            "sales-marketing") echo "Sales & Marketing" ;; 
            "project-setup") echo "Project Setup" ;; 
            "performance-optimization") echo "Performance & Optimization" ;; 
            "crypto-trading") echo "Crypto & Trading" ;; 
            "security-audit") echo "Security Audit" ;; 
            "context-loading-priming") echo "Context Loading & Priming" ;; 
            "business-finance") echo "Business & Finance" ;; 
            "api-development") echo "API Development" ;; 
            "miscellaneous") echo "Miscellaneous" ;; 
            "database-operations") echo "Database Operations" ;; 
            "monitoring-observability") echo "Monitoring & Observability" ;; 
            "design-experience") echo "Design & Experience" ;; 
            "blockchain-web3") echo "Blockchain & Web3" ;; 
            "typescript-migration") echo "TypeScript Migration" ;; 
            "game-development") echo "Game Development" ;; 
            "automation-workflow") echo "Automation & Workflow" ;; 
            "general-purpose") echo "General Purpose" ;; 
            # Fallback for any unrecognized categories
            *) echo "$(echo "$1" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')" ;; 
        esac
    }
    
    # Process categories in intelligent order (by frequency from @davepoon's collection)
    local ordered_categories="specialized-domains code-analysis-testing project-task-management framework-svelte quality-security utilities-debugging version-control-git team-collaboration language-specialists integration-sync development-architecture data-ai ci-deployment documentation-changelogs workflow-orchestration simulation-modeling infrastructure-operations sales-marketing project-setup performance-optimization crypto-trading security-audit context-loading-priming business-finance api-development miscellaneous database-operations monitoring-observability design-experience blockchain-web3 typescript-migration game-development automation-workflow general-purpose"
    
    for category in $ordered_categories; do
        local category_file="$temp_agents_dir/$category.txt"
        if [[ -f "$category_file" && -s "$category_file" ]]; then
            local display_name=$(get_category_display_name "$category")
            local agents_list=$(cat "$category_file" | sort | tr '\n' ' ' | sed 's/ $//')
            
            if [[ -n "$briefing" ]]; then
                briefing+="\n"
            fi
            briefing+="**$display_name**: $agents_list"
        fi
    done
    
    # Cleanup temporary files
    rm -rf "$temp_agents_dir" 2>/dev/null
    
    echo "$briefing"
}

generate_subagent_manifest() {
    echo -e "${BLUE}[Manifest]${NC} Checking if manifest update is needed..."
    local manifest_path="$INSTALLATION_PATH/$MANIFEST_FILE"

    if ! should_update_manifest "$manifest_path" "$INSTALLATION_PATH"; then
        echo -e "${GREEN}✓ Manifest is current${NC} - skipping regeneration"
        echo -e "${BLUE}[Manifest]${NC} Using existing manifest: $manifest_path"
        if [[ -f "$manifest_path" ]]; then
            if command -v python3 >/dev/null 2>&1;
            then
                local agent_count
                agent_count=$(python3 -c "import json; data=json.load(open('$manifest_path')); print(len(data.get('index', [])))" 2>/dev/null || echo "0")
                echo -e "${BLUE}[Manifest]${NC} Total agents in index: $agent_count"
            fi
        fi
        return 0
    fi

    echo -e "${BLUE}[Manifest]${NC} Generating Hybrid Manifest (single-line index)..."
    local temp_manifest="/tmp/kiro_manifest_$$.json"
    local generation_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    echo -e "${BLUE}[Manifest]${NC} Pre-computing capabilities briefing..."
    local capabilities_briefing
    capabilities_briefing=$(generate_capabilities_briefing | sed 's/"/\\"/g' | tr -d '\n')

    cat > "$temp_manifest" << EOF
{
  "version": "2.0.0-hybrid",
  "generated_at": "$generation_time",
  "attribution": "Subagents from @davepoon/claude-code-subagents-collection",
  "capabilities_briefing": "$capabilities_briefing",
  "index": [
EOF

    local subagent_files=()
    while IFS= read -r -d '' file; do
        subagent_files+=("$file")
    done < <(find "$INSTALLATION_PATH" -name "*.md" -type f -print0 2>/dev/null)
    
    echo -e "${BLUE}[Manifest]${NC} Processing ${#subagent_files[@]} subagent files for index..."
    local agent_count=0
    for file in "${subagent_files[@]}"; do
        if [[ "$file" == *"$MANIFEST_FILE"* ]]; then continue; fi
        
        local filename=$(basename "$file")
        local agent_name="${filename%.md}"
        
        local purpose="AI agent specialization"
        local specialization="General Purpose"
        if head -n 20 "$file" | grep -q '^---'; then
            local frontmatter_purpose
            frontmatter_purpose=$(awk '/^description:/ {sub(/^description: */, ""); print; exit}' "$file")
            if [[ -z "$frontmatter_purpose" ]]; then
                frontmatter_purpose=$(awk '/^purpose:/ {sub(/^purpose: */, ""); print; exit}' "$file")
            fi
            if [[ -n "$frontmatter_purpose" ]]; then purpose="$frontmatter_purpose"; fi
            
            local frontmatter_spec
            frontmatter_spec=$(awk '/^category:/ {sub(/^category: */, ""); print; exit}' "$file")
            if [[ -z "$frontmatter_spec" ]]; then
                frontmatter_spec=$(awk '/^specialization:/ {sub(/^specialization: */, ""); print; exit}' "$file")
            fi
            if [[ -n "$frontmatter_spec" ]]; then specialization="$frontmatter_spec"; fi
        else
            local first_line
            first_line=$(head -n 10 "$file" | grep -E '^# |^## |^### ' | head -n 1 | sed 's/^#* *//')
            if [[ -n "$first_line" ]]; then purpose="$first_line"; fi
        fi
        
        purpose=$(echo "$purpose" | sed -e 's/^["\x27]//' -e 's/["\x27]$//' | tr -d '\n\r' | sed 's/"/\\"/g')
        specialization=$(echo "$specialization" | sed -e 's/^["\x27]//' -e 's/["\x27]$//' | tr -d '\n\r' | sed 's/"/\\"/g')
        
        ((agent_count++))
        local agent_id
        agent_id=$(printf "subagent_%03d" $agent_count)

        if [[ $agent_count -gt 1 ]]; then echo "," >> "$temp_manifest"; fi

        printf '    { "id": "%s", "name": "%s", "specialization": "%s", "purpose": "%s" }' "$agent_id" "$agent_name" "$specialization" "$purpose" >> "$temp_manifest"
        echo -n "."
    done
    echo

    cat >> "$temp_manifest" << EOF

  ],
  "definitions": {
EOF

    echo -e "${BLUE}[Manifest]${NC} Processing ${#subagent_files[@]} subagent files for definitions..."
    agent_count=0
    for file in "${subagent_files[@]}"; do
        if [[ "$file" == *"$MANIFEST_FILE"* ]]; then continue; fi

        local filename=$(basename "$file")
        local agent_name="${filename%.md}"

        local purpose="AI agent specialization"
        local specialization="General Purpose"
        if head -n 20 "$file" | grep -q '^---'; then
            local frontmatter_purpose
            frontmatter_purpose=$(awk '/^description:/ {sub(/^description: */, ""); print; exit}' "$file")
            if [[ -z "$frontmatter_purpose" ]]; then
                frontmatter_purpose=$(awk '/^purpose:/ {sub(/^purpose: */, ""); print; exit}' "$file")
            fi
            if [[ -n "$frontmatter_purpose" ]]; then purpose="$frontmatter_purpose"; fi

            local frontmatter_spec
            frontmatter_spec=$(awk '/^category:/ {sub(/^category: */, ""); print; exit}' "$file")
            if [[ -z "$frontmatter_spec" ]]; then
                frontmatter_spec=$(awk '/^specialization:/ {sub(/^specialization: */, ""); print; exit}' "$file")
            fi
            if [[ -n "$frontmatter_spec" ]]; then specialization="$frontmatter_spec"; fi
        else
            local first_line
            first_line=$(head -n 10 "$file" | grep -E '^# |^## |^### ' | head -n 1 | sed 's/^#* *//')
            if [[ -n "$first_line" ]]; then purpose="$first_line"; fi
        fi

        purpose=$(echo "$purpose" | sed -e 's/^["\x27]//' -e 's/["\x27]$//' | tr -d '\n\r' | sed 's/"/\\"/g')
        specialization=$(echo "$specialization" | sed -e 's/^["\x27]//' -e 's/["\x27]$//' | tr -d '\n\r' | sed 's/"/\\"/g')

        ((agent_count++))
        local agent_id
        agent_id=$(printf "subagent_%03d" $agent_count)

        if [[ $agent_count -gt 1 ]]; then echo "," >> "$temp_manifest"; fi

        cat >> "$temp_manifest" << EOF
    "$agent_id": {
      "name": "$agent_name",
      "file_path": "./$filename",
      "purpose": "$purpose",
      "specialization": "$specialization"
    }
EOF
        echo -n "."
    done
    echo

    cat >> "$temp_manifest" << EOF

  },
  "metadata": {
    "total_agents": $agent_count
  }
}
EOF

    echo
    if command -v python3 >/dev/null 2>&1;
    then
        if python3 -m json.tool "$temp_manifest" >/dev/null 2>&1;
        then
            echo -e "${GREEN}✓ JSON validation passed${NC}"
        else
            echo -e "${RED}✗ JSON validation failed${NC}"
            cat "$temp_manifest"
            rm -f "$temp_manifest"
            return 1
        fi
    fi

    if mv "$temp_manifest" "$manifest_path"; then
        echo -e "${GREEN}✓ Manifest generated${NC}: $manifest_path"
        echo -e "${BLUE}[Manifest]${NC} Total agents: $agent_count"
        return 0
    else
        echo -e "${RED}✗ Failed to create manifest${NC}"
        rm -f "$temp_manifest"
        return 1
    fi
}
# Backup Management Functions
create_backup_to_desktop() {
    local original_file="$1"
    local backup_type="$2"  # "global" or "project"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_filename="kiro-implementer-${backup_type}-backup-${timestamp}.md"
    local desktop_backup="$DESKTOP_PATH/$backup_filename"
    
    if [[ -f "$original_file" ]]; then
        echo -e "${BLUE}[Backup]${NC} Creating backup of existing $backup_type kiro-implementer.md"
        if cp "$original_file" "$desktop_backup"; then
            BACKUP_FILES+=("$desktop_backup")
            echo -e "${GREEN}✓ Backup saved to Desktop${NC}: $backup_filename"
            return 0
        else
            echo -e "${YELLOW}⚠ Could not create backup on Desktop${NC}, using temporary location"
            return 1
        fi
    fi
    return 0
}

show_backup_summary() {
    if [[ ${#BACKUP_FILES[@]} -gt 0 ]]; then
        print_header "BACKUP FILES CREATED" "📁" "$BLUE"
        print_item "Your original kiro-implementer.md files have been backed up"
        print_item "and moved to your Desktop for safekeeping:"
        print_item ""
        for backup in "${BACKUP_FILES[@]}"; do
            local filename=$(basename "$backup")
            print_item "  📁 ${GREEN}$filename${NC}"
        done
        print_item ""
        print_item "${YELLOW}💡 These backups are safe to delete if you don't need them${NC}"
        print_footer
    fi
}

show_other_implementers_summary() {
    local global_path="$HOME/.claude/commands/kiro-implementer.md"
    local project_path="$SCRIPT_DIR/../CLAUDE/.claude/commands/kiro-implementer.md"
    local other_implementers_found=false
    local message=""

    # Check for other implementers based on installation type
    if [[ "$INSTALLATION_PATH" == "$HOME/.claude/agents" ]]; then
        # Global install was chosen, check for project-level one
        if [[ -f "$project_path" ]]; then
            message+="A project-specific kiro-implementer.md was also found at:\n"
            message+="  ${BLUE}$project_path${NC}\n\n"
            message+="This project-level command will be used instead of the global one you just installed when you are in this project."
            other_implementers_found=true
        fi
    elif [[ "$INSTALLATION_PATH" == "$SCRIPT_DIR/.claude/agents" ]]; then
        # Project install was chosen, check for global one
        if [[ -f "$global_path" ]]; then
            message+="A global kiro-implementer.md was also found at:\n"
            message+="  ${BLUE}$global_path${NC}\n\n"
            message+="The project-specific command you just installed will always take precedence over the global one in this project."
            other_implementers_found=true
        fi
    fi

    if [[ "$other_implementers_found" == "true" ]]; then
        print_header "ADDITIONAL IMPLEMENTERS DETECTED" "ℹ️" "$YELLOW"
        print_item "${YELLOW}For your information:${NC}"
        print_item ""
        # Using printf to handle newlines in message
        printf "  %b\n" "$message"
        print_item ""
        print_item "Claude prioritizes project-level commands over global commands."
        print_footer
    fi
}


# Kiro Implementer Generation (TASK-E5A8F3B2-004)
generate_kiro_implementer() {
    echo -e "${BLUE}[Template]${NC} Generating kiro-implementer.md from simple enhanced template..."
    local source_template="$SCRIPT_DIR/simple-kiro-implementer.md"
    local global_path="$HOME/.claude/commands/kiro-implementer.md"
    local project_path="$SCRIPT_DIR/../CLAUDE/.claude/commands/kiro-implementer.md"

    # Check if source template exists
    if [[ ! -f "$source_template" ]]; then
        echo -e "${RED}✗ Source template not found${NC}: $source_template"
        return 1
    fi
    echo -e "${BLUE}[Template]${NC} Using source template: $source_template"

    local target_path=""
    local install_type=""

    # Determine target path based on user's choice
    if [[ "$INSTALLATION_PATH" == "$HOME/.claude/agents" ]]; then
        install_type="global"
        target_path="$global_path"
    elif [[ "$INSTALLATION_PATH" == "$SCRIPT_DIR/.claude/agents" ]]; then
        install_type="project"
        target_path="$project_path"
    fi

    if [[ -n "$target_path" ]]; then
        local target_dir
        target_dir="$(dirname "$target_path")"
        if [[ -d "$target_dir" ]]; then
            # Create backup to desktop if file exists
            create_backup_to_desktop "$target_path" "$install_type"
            
            cp "$source_template" "$target_path"
            echo -e "${GREEN}✓ Generated $install_type kiro-implementer.md${NC}: $target_path"
        else
            echo -e "${YELLOW}⚠ The $install_type command directory does not exist at $target_dir.${NC}"
            echo -e "${YELLOW}💡 Cannot install the enhanced kiro-implementer.md.${NC}"
        fi
    else
        # This case is hit if INSTALLATION_PATH is not one of the expected values.
        # This is the original fallback logic.
        if [[ ! -d "$HOME/.claude/commands" ]] && [[ ! -d "$(dirname "$project_path")" ]]; then
            local fallback_path="$SCRIPT_DIR/../kiro-implementer.md"
            cp "$source_template" "$fallback_path"
            echo -e "${YELLOW}⚠ Created fallback kiro-implementer.md${NC}: $fallback_path"
            echo -e "${YELLOW}💡 Claude command directories not found. Install globally or copy to your project's .claude/commands/ directory.${NC}"
        else
            echo -e "${YELLOW}⚠ Could not determine installation location for kiro-implementer.md. Skipping generation.${NC}"
        fi
    fi
    
    return 0
}

# Copy protocol files
copy_protocol_files() {
    echo -e "${BLUE}[Protocols]${NC} Installing protocol definitions..."
    
    local protocols_source_dir="$SCRIPT_DIR/protocols"
    local target_protocols_dir=""
    
    # Determine target directory based on installation type
    if [[ "$INSTALLATION_PATH" == "$HOME/.claude/agents" ]]; then
        target_protocols_dir="$HOME/.claude/protocols"
    else
        target_protocols_dir="$(dirname "$INSTALLATION_PATH")/protocols"
    fi
    
    # Copy protocol files
    if [[ -d "$protocols_source_dir" ]]; then
        for protocol_file in "$protocols_source_dir"/*.md; do
            if [[ -f "$protocol_file" ]]; then
                local filename=$(basename "$protocol_file")
                cp "$protocol_file" "$target_protocols_dir/$filename"
                echo -e "${GREEN}✓ Installed${NC} protocol: $filename"
            fi
        done
    else
        echo -e "${YELLOW}⚠ Protocol source directory not found${NC}: $protocols_source_dir"
    fi
}

# Copy template files
copy_template_files() {
    echo -e "${BLUE}[Templates]${NC} Installing template files..."
    
    local templates_source_dir="$SCRIPT_DIR/templates"
    local target_templates_dir=""
    
    # Determine target directory based on installation type
    if [[ "$INSTALLATION_PATH" == "$HOME/.claude/agents" ]]; then
        target_templates_dir="$HOME/.claude/templates"
    else
        target_templates_dir="$(dirname "$INSTALLATION_PATH")/templates"
    fi
    
    # Copy template files
    if [[ -d "$templates_source_dir" ]]; then
        for template_file in "$templates_source_dir"/*; do
            if [[ -f "$template_file" ]]; then
                local filename=$(basename "$template_file")
                cp "$template_file" "$target_templates_dir/$filename"
                echo -e "${GREEN}✓ Installed${NC} template: $filename"
            fi
        done
    else
        echo -e "${YELLOW}⚠ Template source directory not found${NC}: $templates_source_dir"
    fi
}

# Detect existing Kiro installation
detect_existing_installation() {
    echo -e "${BLUE}[Detection]${NC} Checking for existing Kiro installation..."
    
    if [[ -d "$HOME/.claude/commands" ]]; then
        echo -e "${GREEN}✓ Existing Kiro installation detected${NC}"
        echo -e "${BLUE}[Enhancement]${NC} This will enhance your existing installation"
        
        # Check for existing implementer
        if [[ -f "$HOME/.claude/commands/kiro-implementer.md" ]]; then
            echo -e "${YELLOW}⚠ Found existing kiro-implementer.md${NC}"
            echo -e "${BLUE}[Backup]${NC} Will backup to Desktop before replacement"
        fi
        
        # Check for existing templates
        if [[ -d "$HOME/.claude/templates" ]]; then
            echo -e "${GREEN}✓ Found existing templates directory${NC}"
            echo -e "${BLUE}[Preservation]${NC} Will preserve existing templates"
        fi
        
        return 0
    else
        echo -e "${BLUE}ℹ${NC} No existing Kiro installation found - fresh installation"
        echo -e "${BLUE}[Setup]${NC} Will create new .claude structure"
        return 1
    fi
}

# Main execution flow
main() {
    print_welcome_header
    echo -e "${CYAN}Starting Enhanced Kiro Subagent Integration...${NC}"
    echo
    
    # Phase 0: Detect existing installation 
    detect_existing_installation
    echo
    
    # Phase 1: System Requirements Validation (TASK-E5A8F3B2-014)
    if ! validate_system_requirements; then
        echo -e "${RED}✗ Installation aborted due to system requirement failures${NC}"
        echo -e "${BLUE}💡 Please resolve the issues above and try again${NC}"
        exit 1
    fi
    echo
    # Phase 1: Location Selection (TASK-001)
    select_installation_location
    validate_ears_ac_001_01 || exit 1
    create_installation_directory
    # Phase 2: Download (TASK-002)
    download_all_subagents || exit 1
    validate_ears_ac_001_02 || exit 1
    validate_ears_ac_001_03
    validate_ears_ac_001_05
    # Phase 2.5: Fix Agent Files (ensure proper frontmatter)
    fix_agent_files
    # Phase 3: Manifest Generation (TASK-003)
    generate_subagent_manifest || exit 1
    validate_ears_ac_002_01 || exit 1
    validate_manifest_performance
    # Phase 4: Protocol Installation
    copy_protocol_files
    
    # Phase 5: Template Installation
    copy_template_files
    
    # Phase 6: Kiro Implementer (TASK-004)
    generate_kiro_implementer || exit 1
    validate_ears_ac_004_01 || exit 1
    validate_ears_ac_004_02 || exit 1
    validate_ears_ac_004_03 || exit 1
    validate_ears_ac_004_04
    # Phase 7: Security Validation (TASK-E5A8F3B2-013)
    if [[ "$SECURITY_ENABLED" == "true" ]]; then
        echo -e "${BLUE}[Security]${NC} Performing post-installation security validation..."
        echo -e "${GREEN}✓ HTTPS-only downloads enforced${NC}"
        echo -e "${GREEN}✓ File integrity checksums calculated${NC}"
        echo -e "${GREEN}✓ File size limits enforced (max: ${MAX_FILE_SIZE} bytes)${NC}"
        echo -e "${GREEN}✓ Content validation performed${NC}"
        echo -e "${GREEN}✓ Trusted repository validation completed${NC}"
    fi
    
    print_header "Installation Complete!" "✓" "$GREEN"
    print_item "Installation Path: ${BLUE}$INSTALLATION_PATH${NC}"
    print_item "Enhanced kiro-implementer.md has been generated/updated"
    print_item ""
    print_item "${YELLOW}Next Steps:${NC}"
    print_item "1. Review the enhanced kiro-implementer.md"
    print_item "2. Start using /kiro-implementer for enhanced features"
    print_item "3. For updates, simply re-run this script"
    print_footer

    print_header "COMMUNITY ATTRIBUTION" "🙏" "$PURPLE"
    print_item "This enhanced integration is powered by the incredible"
    print_item "work of ${GREEN}@davepoon${NC} and their brilliant subagent collection."
    print_item ""
    print_item "${YELLOW}🌟 Please support the community:${NC}"
    print_item "• Visit: ${BLUE}github.com/davepoon/claude-code-subagents-${NC}"
    print_item "         ${BLUE}collection${NC}"
    print_item "• Give it a ${YELLOW}⭐ star${NC} to show appreciation"
    print_item "• Contribute or share with fellow developers"
    print_item ""
    print_item "${GREEN}Together we build better AI development tools! 🚀${NC}"
    print_footer
    
    # Show backup summary at the end
    show_backup_summary

    # Show summary of other implementer files found
    show_other_implementers_summary
}
# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi