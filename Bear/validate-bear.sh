#!/bin/bash
# Bear V2 Installation Validation Script
# Comprehensive testing and verification tool

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_PATH="$HOME/.claude"
PROJECT_PATH="$SCRIPT_DIR/../.claude"

# Validation results tracking
VALIDATION_RESULTS=()
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Helper functions
print_header() {
    local title="$1"
    local icon="${2:-🔍}"
    local color="${3:-$CYAN}"
    
    echo
    echo -e "${color}${icon} ${title}${NC}"
    printf '%*s\n' "60" '' | tr ' ' '─'
}

print_footer() {
    printf '%*s\n' "60" '' | tr ' ' '─'
    echo
}

add_result() {
    local status="$1"  # PASS, FAIL, WARN
    local message="$2"
    local details="${3:-}"
    
    VALIDATION_RESULTS+=("$status:$message:$details")
    ((TOTAL_CHECKS++))
    
    case "$status" in
        PASS)
            echo -e "${GREEN}✅ PASS${NC}: $message"
            ((PASSED_CHECKS++))
            ;;
        FAIL)
            echo -e "${RED}❌ FAIL${NC}: $message"
            if [[ -n "$details" ]]; then
                echo -e "    ${RED}Details:${NC} $details"
            fi
            ((FAILED_CHECKS++))
            ;;
        WARN)
            echo -e "${YELLOW}⚠️  WARN${NC}: $message"
            if [[ -n "$details" ]]; then
                echo -e "    ${YELLOW}Details:${NC} $details"
            fi
            ((WARNING_CHECKS++))
            ;;
    esac
}

# Detect installation type and path
detect_installation() {
    echo -e "${BLUE}[Detection]${NC} Identifying Bear V2 installation..."
    
    local installation_found=false
    local installation_path=""
    local installation_type=""
    
    # Check global installation
    if [[ -d "$GLOBAL_PATH/protocols" ]] && [[ -f "$GLOBAL_PATH/protocols/bear_protocol.md" ]]; then
        installation_path="$GLOBAL_PATH"
        installation_type="Global"
        installation_found=true
        echo -e "${GREEN}✓ Global installation detected${NC}: $GLOBAL_PATH"
    fi
    
    # Check project-specific installation
    if [[ -d "$PROJECT_PATH/protocols" ]] && [[ -f "$PROJECT_PATH/protocols/bear_protocol.md" ]]; then
        if [[ "$installation_found" == "true" ]]; then
            echo -e "${YELLOW}⚠ Multiple installations detected${NC}"
            echo -e "${BLUE}ℹ Project-specific takes precedence${NC}: $PROJECT_PATH"
        fi
        installation_path="$PROJECT_PATH"
        installation_type="Project-specific"
        installation_found=true
        echo -e "${GREEN}✓ Project-specific installation detected${NC}: $PROJECT_PATH"
    fi
    
    if [[ "$installation_found" == "false" ]]; then
        add_result "FAIL" "No Bear V2 installation detected" "Run install-bear.sh first"
        return 1
    fi
    
    echo "$installation_path"
    return 0
}

# Validate directory structure
validate_directories() {
    local install_path="$1"
    echo -e "${BLUE}[Structure]${NC} Validating directory structure..."
    
    local required_dirs=(
        "memory"
        "memory/projects"
        "memory/templates"
        "memory/patterns"
        "agents"
        "agents/performance"
        "protocols"
        "commands"
        "templates"
        "state"
        "state/bear"
        "state/sessions"
    )
    
    for dir in "${required_dirs[@]}"; do
        local full_path="$install_path/$dir"
        if [[ -d "$full_path" ]]; then
            add_result "PASS" "Directory exists: $dir"
        else
            add_result "FAIL" "Missing directory: $dir" "Expected at $full_path"
        fi
    done
}

# Validate core files
validate_files() {
    local install_path="$1"
    echo -e "${BLUE}[Files]${NC} Validating core Bear V2 files..."
    
    local required_files=(
        "protocols/bear_protocol.md:Bear V2 Protocol"
        "agents/knowledge-synthesizer-v2.md:Knowledge Synthesizer"
        "agents/agent-performance.json:Performance Database"
        "commands/bear.md:Bear Commands"
        "state/bear/config.json:Bear Configuration"
    )
    
    for file_info in "${required_files[@]}"; do
        IFS=':' read -r file_path description <<< "$file_info"
        local full_path="$install_path/$file_path"
        
        if [[ -f "$full_path" ]]; then
            # Check file size (should not be empty)
            local file_size=$(stat -f%z "$full_path" 2>/dev/null || stat -c%s "$full_path" 2>/dev/null || echo "0")
            if [[ $file_size -gt 0 ]]; then
                add_result "PASS" "$description file exists and non-empty"
            else
                add_result "FAIL" "$description file is empty" "$full_path"
            fi
        else
            add_result "FAIL" "Missing $description" "Expected at $full_path"
        fi
    done
}

# Validate JSON configuration files
validate_json_files() {
    local install_path="$1"
    echo -e "${BLUE}[JSON]${NC} Validating JSON configuration files..."
    
    local json_files=(
        "agents/agent-performance.json"
        "state/bear/config.json"
    )
    
    if command -v python3 >/dev/null 2>&1; then
        for json_file in "${json_files[@]}"; do
            local full_path="$install_path/$json_file"
            if [[ -f "$full_path" ]]; then
                if python3 -m json.tool "$full_path" >/dev/null 2>&1; then
                    add_result "PASS" "Valid JSON: $(basename "$json_file")"
                    
                    # Validate specific JSON structure
                    case "$json_file" in
                        "agents/agent-performance.json")
                            local version=$(python3 -c "import json; data=json.load(open('$full_path')); print(data.get('version', 'missing'))" 2>/dev/null)
                            if [[ "$version" == "2.0.0" ]]; then
                                add_result "PASS" "Agent performance database has correct version"
                            else
                                add_result "WARN" "Agent performance database version mismatch" "Found: $version, Expected: 2.0.0"
                            fi
                            ;;
                        "state/bear/config.json")
                            local bear_version=$(python3 -c "import json; data=json.load(open('$full_path')); print(data.get('bear_version', 'missing'))" 2>/dev/null)
                            if [[ "$bear_version" == "2.0.0" ]]; then
                                add_result "PASS" "Bear configuration has correct version"
                            else
                                add_result "WARN" "Bear configuration version mismatch" "Found: $bear_version, Expected: 2.0.0"
                            fi
                            ;;
                    esac
                else
                    add_result "FAIL" "Invalid JSON: $(basename "$json_file")" "JSON syntax error in $full_path"
                fi
            fi
        done
    else
        add_result "WARN" "Python3 not available" "Cannot validate JSON file syntax"
    fi
}

# Validate command integration
validate_commands() {
    local install_path="$1"
    echo -e "${BLUE}[Commands]${NC} Validating Bear command integration..."
    
    # Check main bear command
    local bear_command="$install_path/commands/bear.md"
    if [[ -f "$bear_command" ]]; then
        # Validate frontmatter
        if head -n 5 "$bear_command" | grep -q "name: bear"; then
            add_result "PASS" "Bear command has proper frontmatter"
        else
            add_result "FAIL" "Bear command missing proper frontmatter" "Check $bear_command"
        fi
        
        # Validate protocol reference
        if grep -q "bear_protocol.md" "$bear_command"; then
            add_result "PASS" "Bear command references protocol file"
        else
            add_result "WARN" "Bear command may not reference protocol file"
        fi
    fi
    
    # Check for bear-memory command  
    local bear_memory_command="$install_path/commands/bear-memory.md"
    if [[ -f "$bear_memory_command" ]]; then
        add_result "PASS" "Bear memory command exists"
    else
        add_result "WARN" "Bear memory command not found" "Optional but recommended"
    fi
}

# Validate memory system
validate_memory_system() {
    local install_path="$1"
    echo -e "${BLUE}[Memory]${NC} Validating Bear memory system..."
    
    # Check memory directories are writable
    local memory_path="$install_path/memory"
    if [[ -w "$memory_path" ]]; then
        add_result "PASS" "Memory directory is writable"
        
        # Test memory creation
        local test_dir="$memory_path/validation-test-$$"
        if mkdir -p "$test_dir" 2>/dev/null; then
            add_result "PASS" "Can create memory entries"
            rm -rf "$test_dir"
        else
            add_result "FAIL" "Cannot create memory entries" "Permission issue in $memory_path"
        fi
    else
        add_result "FAIL" "Memory directory not writable" "$memory_path"
    fi
    
    # Check for sample memory
    local sample_count=$(find "$memory_path/projects" -name "memory-summary.md" 2>/dev/null | wc -l)
    if [[ $sample_count -gt 0 ]]; then
        add_result "PASS" "Sample memory entries found ($sample_count)"
    else
        add_result "WARN" "No memory entries found" "Expected for new installation"
    fi
}

# Validate integration points
validate_integration() {
    local install_path="$1"
    echo -e "${BLUE}[Integration]${NC} Validating system integrations..."
    
    # Check Kiro integration
    local kiro_bridge="$install_path/protocols/bear-kiro-bridge.md"
    if [[ -f "$kiro_bridge" ]]; then
        add_result "PASS" "Kiro framework integration detected"
        
        # Check if CLAUDE.md was updated
        local claude_md=""
        if [[ -f "$SCRIPT_DIR/../CLAUDE/CLAUDE.md" ]]; then
            claude_md="$SCRIPT_DIR/../CLAUDE/CLAUDE.md"
        elif [[ -f "$SCRIPT_DIR/../CLAUDE.md" ]]; then
            claude_md="$SCRIPT_DIR/../CLAUDE.md"
        fi
        
        if [[ -n "$claude_md" ]] && grep -q "/bear" "$claude_md"; then
            add_result "PASS" "CLAUDE.md updated with Bear commands"
        else
            add_result "WARN" "CLAUDE.md may not include Bear commands" "Manual update may be needed"
        fi
    else
        add_result "WARN" "No Kiro framework integration" "Standalone installation"
    fi
    
    # Check for existing .claude structure compatibility
    if [[ -d "$SCRIPT_DIR/../.claude/state/implementer-state" ]]; then
        add_result "PASS" "Compatible with existing .claude state system"
    fi
}

# Performance testing
validate_performance() {
    local install_path="$1"
    echo -e "${BLUE}[Performance]${NC} Testing Bear system performance..."
    
    # Test configuration loading speed
    local config_file="$install_path/state/bear/config.json"
    if [[ -f "$config_file" ]]; then
        local start_time=$(date +%s%N)
        cat "$config_file" >/dev/null 2>&1
        local end_time=$(date +%s%N)
        local duration_ms=$(( (end_time - start_time) / 1000000 ))
        
        if [[ $duration_ms -lt 100 ]]; then
            add_result "PASS" "Configuration loads quickly (${duration_ms}ms)"
        elif [[ $duration_ms -lt 500 ]]; then
            add_result "WARN" "Configuration load time acceptable (${duration_ms}ms)"
        else
            add_result "FAIL" "Configuration loads slowly (${duration_ms}ms)" "May impact performance"
        fi
    fi
    
    # Test memory directory listing speed
    local memory_path="$install_path/memory"
    local start_time=$(date +%s%N)
    find "$memory_path" -type f -name "*.md" >/dev/null 2>&1 || true
    local end_time=$(date +%s%N)
    local duration_ms=$(( (end_time - start_time) / 1000000 ))
    
    if [[ $duration_ms -lt 200 ]]; then
        add_result "PASS" "Memory system responsive (${duration_ms}ms)"
    else
        add_result "WARN" "Memory system slow (${duration_ms}ms)" "May need optimization with many projects"
    fi
}

# Security validation
validate_security() {
    local install_path="$1"
    echo -e "${BLUE}[Security]${NC} Validating security configuration..."
    
    # Check directory permissions
    local memory_perms=$(stat -f%A "$install_path/memory" 2>/dev/null || stat -c%a "$install_path/memory" 2>/dev/null || echo "unknown")
    if [[ "$memory_perms" == "755" ]] || [[ "$memory_perms" == "700" ]]; then
        add_result "PASS" "Memory directory has secure permissions ($memory_perms)"
    else
        add_result "WARN" "Memory directory permissions may be too open" "Current: $memory_perms"
    fi
    
    # Check for sensitive data patterns
    local sensitive_patterns=("password" "secret" "key" "token" "api_key")
    local found_sensitive=false
    
    for pattern in "${sensitive_patterns[@]}"; do
        if grep -r -i "$pattern" "$install_path/state/bear/" >/dev/null 2>&1; then
            found_sensitive=true
            break
        fi
    done
    
    if [[ "$found_sensitive" == "false" ]]; then
        add_result "PASS" "No sensitive data patterns in configuration"
    else
        add_result "WARN" "Possible sensitive data in configuration" "Review config files manually"
    fi
}

# Generate validation report
generate_report() {
    local install_path="$1"
    
    print_header "Bear V2 Validation Report" "📊" "$PURPLE"
    
    echo -e "${BLUE}Installation Details:${NC}"
    echo -e "  Path: ${GREEN}$install_path${NC}"
    echo -e "  Type: $(basename "$install_path" | sed 's/\.claude/Project-specific/' | sed 's/.*claude/Global/')"
    echo -e "  Timestamp: $(date)"
    echo
    
    echo -e "${BLUE}Validation Summary:${NC}"
    echo -e "  Total Checks: ${CYAN}$TOTAL_CHECKS${NC}"
    echo -e "  Passed: ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "  Failed: ${RED}$FAILED_CHECKS${NC}"
    echo -e "  Warnings: ${YELLOW}$WARNING_CHECKS${NC}"
    echo
    
    local success_rate=0
    if [[ $TOTAL_CHECKS -gt 0 ]]; then
        success_rate=$(( (PASSED_CHECKS * 100) / TOTAL_CHECKS ))
    fi
    
    echo -e "${BLUE}Success Rate: ${NC}"
    if [[ $success_rate -ge 90 ]]; then
        echo -e "  ${GREEN}$success_rate% - Excellent${NC}"
    elif [[ $success_rate -ge 75 ]]; then
        echo -e "  ${YELLOW}$success_rate% - Good${NC}"
    elif [[ $success_rate -ge 50 ]]; then
        echo -e "  ${YELLOW}$success_rate% - Fair${NC}"
    else
        echo -e "  ${RED}$success_rate% - Poor${NC}"
    fi
    
    # Critical issues summary
    if [[ $FAILED_CHECKS -gt 0 ]]; then
        echo
        echo -e "${RED}Critical Issues Found:${NC}"
        for result in "${VALIDATION_RESULTS[@]}"; do
            IFS=':' read -r status message details <<< "$result"
            if [[ "$status" == "FAIL" ]]; then
                echo -e "  ${RED}•${NC} $message"
                if [[ -n "$details" ]]; then
                    echo -e "    $details"
                fi
            fi
        done
        echo
        echo -e "${RED}⚠️  Please resolve critical issues before using Bear V2${NC}"
    fi
    
    # Recommendations
    echo
    echo -e "${BLUE}Recommendations:${NC}"
    
    if [[ $FAILED_CHECKS -eq 0 ]] && [[ $WARNING_CHECKS -eq 0 ]]; then
        echo -e "  ${GREEN}✅ Installation is perfect! Bear V2 is ready for use.${NC}"
        echo -e "  • Try: ${BLUE}/bear \"help me understand this project\"${NC}"
        echo -e "  • Explore: ${BLUE}/bear-memory \"installation\"${NC}"
    elif [[ $FAILED_CHECKS -eq 0 ]]; then
        echo -e "  ${YELLOW}⚠️  Installation is functional with minor issues.${NC}"
        echo -e "  • Review warnings above for optimal performance"
        echo -e "  • Bear V2 should work normally despite warnings"
    else
        echo -e "  ${RED}❌ Installation has critical issues that need attention.${NC}"
        echo -e "  • Resolve all failed checks before using Bear V2"
        echo -e "  • Consider re-running install-bear.sh"
        echo -e "  • Check file permissions and disk space"
    fi
    
    print_footer
    
    # Return appropriate exit code
    if [[ $FAILED_CHECKS -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

# Main validation function
main() {
    print_header "Bear V2 Installation Validator" "🔍" "$CYAN"
    echo -e "Comprehensive validation and testing tool for Bear V2 installations"
    print_footer
    
    # Detect installation
    local install_path
    if ! install_path=$(detect_installation); then
        echo -e "${RED}Cannot proceed without a valid Bear V2 installation${NC}"
        exit 1
    fi
    
    # Run all validation checks
    validate_directories "$install_path"
    validate_files "$install_path"  
    validate_json_files "$install_path"
    validate_commands "$install_path"
    validate_memory_system "$install_path"
    validate_integration "$install_path"
    validate_performance "$install_path"
    validate_security "$install_path"
    
    # Generate final report
    if generate_report "$install_path"; then
        echo -e "${GREEN}🎉 Bear V2 validation completed successfully!${NC}"
        exit 0
    else
        echo -e "${RED}💥 Bear V2 validation found critical issues!${NC}"
        exit 1
    fi
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi