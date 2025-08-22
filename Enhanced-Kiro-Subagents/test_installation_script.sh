#!/bin/bash

# Integration Test for Enhanced Kiro Subagent Installation Script
# EARS Validation: Tests AC-E5A8F3B2-001-01 and core functionality

set -euo pipefail

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_SCRIPT="$SCRIPT_DIR/enhance-kiro-subagents.sh"
TEST_OUTPUT_FILE="/tmp/kiro_test_output.txt"
TEMP_TEST_DIR="/tmp/kiro_test_$$"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_test() {
    ((TESTS_RUN++))
    echo -e "${BLUE}[TEST $TESTS_RUN]${NC} $1"
}

assert_success() {
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((TESTS_FAILED++))
    fi
}

assert_contains() {
    local output="$1"
    local expected="$2"
    local test_name="$3"
    
    if echo "$output" | grep -q "$expected"; then
        echo -e "${GREEN}✓ PASS${NC} - $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - $test_name"
        echo -e "  Expected to find: '$expected'"
        echo -e "  In output: '$output'"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Setup test environment
setup_test_env() {
    echo -e "${YELLOW}Setting up test environment...${NC}"
    mkdir -p "$TEMP_TEST_DIR"
    cd "$TEMP_TEST_DIR"
}

# Cleanup test environment
cleanup_test_env() {
    echo -e "${YELLOW}Cleaning up test environment...${NC}"
    rm -rf "$TEMP_TEST_DIR"
    rm -f "$TEST_OUTPUT_FILE"
}

# Test 1: Script exists and is executable
test_script_executable() {
    log_test "Script exists and is executable"
    [[ -x "$TEST_SCRIPT" ]]
    assert_success
}

# Test 2: Script displays header with @davepoon attribution
test_header_attribution() {
    log_test "Header displays @davepoon attribution (AC-E5A8F3B2-005-01)"
    
    # Source the script to access functions without running main
    source "$TEST_SCRIPT"
    
    local output
    output=$(print_header 2>&1)
    
    assert_contains "$output" "@davepoon" "Contains @davepoon attribution"
    assert_contains "$output" "brilliant subagent" "Contains appreciation message"
    assert_contains "$output" "claude-code-subagents-collection" "Contains repository reference"
}

# Test 3: Installation menu displays options
test_installation_menu() {
    log_test "Installation menu displays location options (AC-E5A8F3B2-001-01)"
    
    source "$TEST_SCRIPT"
    
    local output
    output=$(print_installation_menu 2>&1)
    
    assert_contains "$output" "~/.claude/agents/" "Contains global option"
    assert_contains "$output" "./.claude/agents/" "Contains project-specific option"
    assert_contains "$output" "Cancel Installation" "Contains cancel option"
}

# Test 4: EARS validation functions exist
test_ears_validation_functions() {
    log_test "EARS validation functions exist"
    
    source "$TEST_SCRIPT"
    
    # Test that EARS validation functions are defined
    if declare -f validate_ears_ac_001_01 >/dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - validate_ears_ac_001_01 function exists"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - validate_ears_ac_001_01 function missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
    
    if declare -f validate_ears_ac_001_02 >/dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - validate_ears_ac_001_02 function exists"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - validate_ears_ac_001_02 function missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Test 5: Script structure validates bash syntax
test_bash_syntax() {
    log_test "Script has valid bash syntax"
    bash -n "$TEST_SCRIPT"
    assert_success
}

# Test 6: Required variables are defined
test_required_variables() {
    log_test "Required variables are defined"
    
    source "$TEST_SCRIPT"
    
    local variables=("SUBAGENTS_REPO" "MANIFEST_FILE")
    local all_defined=true
    
    for var in "${variables[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            echo -e "${RED}✗ Variable $var not defined${NC}"
            all_defined=false
        fi
    done
    
    if $all_defined; then
        echo -e "${GREEN}✓ PASS${NC} - All required variables defined"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - Some required variables missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Test 7: Repository URL is valid
test_repository_url() {
    log_test "Repository URL is valid format"
    
    source "$TEST_SCRIPT"
    
    if [[ "$SUBAGENTS_REPO" =~ ^https://github\.com/davepoon/claude-code-subagents-collection$ ]]; then
        echo -e "${GREEN}✓ PASS${NC} - Repository URL is correct"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - Repository URL incorrect: $SUBAGENTS_REPO"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Test 8: Download function exists and has proper structure
test_download_function() {
    log_test "Download function exists with proper structure"
    
    source "$TEST_SCRIPT"
    
    if declare -f download_all_subagents >/dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - download_all_subagents function exists"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - download_all_subagents function missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
    
    if declare -f cleanup_temp_dir >/dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - cleanup_temp_dir function exists"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - cleanup_temp_dir function missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Test 9: EARS validation functions for download phase
test_download_ears_validation() {
    log_test "EARS validation functions for download exist"
    
    source "$TEST_SCRIPT"
    
    local validation_functions=("validate_ears_ac_001_02" "validate_ears_ac_001_03" "validate_ears_ac_001_05")
    local all_exist=true
    
    for func in "${validation_functions[@]}"; do
        if declare -f "$func" >/dev/null; then
            echo -e "${GREEN}✓ Function $func exists${NC}"
        else
            echo -e "${RED}✗ Function $func missing${NC}"
            all_exist=false
        fi
    done
    
    if $all_exist; then
        echo -e "${GREEN}✓ PASS${NC} - All download EARS validation functions exist"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC} - Some download EARS validation functions missing"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

# Main test execution
run_tests() {
    echo -e "${BLUE}Enhanced Kiro Subagent Installation Script - Integration Tests${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo
    
    setup_test_env
    
    # Run all tests
    test_script_executable
    test_header_attribution
    test_installation_menu
    test_ears_validation_functions
    test_bash_syntax
    test_required_variables
    test_repository_url
    test_download_function
    test_download_ears_validation
    
    cleanup_test_env
    
    # Test summary
    echo
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}════════════${NC}"
    echo -e "Tests Run: $TESTS_RUN"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}All tests passed! ✓${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed! ✗${NC}"
        return 1
    fi
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests
fi