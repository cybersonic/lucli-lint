#!/bin/bash
set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# LUCLI_JAR="target/lucli.jar"
# LUCLI_BINARY="target/lucli"
TEST_OUTPUT_FOLDER="test_output"
FAILED_TESTS=0
TOTAL_TESTS=0
# TEST_SERVER_NAME="test-server-$(date +%s)"



echo -e "${BLUE}🧪 Lint Comprehensive Test Suite${NC}"
echo -e "${BLUE}===================================${NC}"
echo ""
# Function to run a test
run_test() {
    local test_name="$1"
    local command="$2"
    local expected_exit_code="${3:-0}"
    local expected_output_contains="${4:-}"
    
    echo -e "${CYAN}Testing: ${test_name}${NC}"
    echo -e "${YELLOW}Command: ${command}${NC}"
    


    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    # Create output directory if it doesn't exist
    mkdir -p "${TEST_OUTPUT_FOLDER}"

    # Execute the command and capture output
    TEST_RESULT_NAME="${TEST_OUTPUT_FOLDER}/${test_name// /_}.txt"
    if eval "$command" > "${TEST_RESULT_NAME}" 2>&1; then
        actual_exit_code=0
    else
        actual_exit_code=$?
    fi

    # Check exit code
    if [ $actual_exit_code -eq $expected_exit_code ]; then
        # If expected output is specified, check if it contains the string
        if [ -n "$expected_output_contains" ]; then
            if grep -q "$expected_output_contains" "${TEST_RESULT_NAME}"; then
                echo -e "${GREEN}✅ PASSED${NC}"
            else
                echo -e "${RED}❌ FAILED (output doesn't contain expected string)${NC}"
                FAILED_TESTS=$((FAILED_TESTS + 1))
            fi
        else
            echo -e "${GREEN}✅ PASSED${NC}"
        fi
    else
        echo -e "${RED}❌ FAILED (wrong exit code: expected $expected_exit_code, got $actual_exit_code)${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TEST_RESULT_NAME="${TEST_OUTPUT_FOLDER}/${test_name// /_}.txt"
    if eval "$command" > ${TEST_RESULT_NAME} 2>&1; then
        if [ $? -eq $expected_exit_code ]; then
            echo -e "${GREEN}✅ PASSED${NC}"
        else
            echo -e "${RED}❌ FAILED (wrong exit code)${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        if [ $expected_exit_code -ne 0 ]; then
            echo -e "${GREEN}✅ PASSED (expected failure)${NC}"
        else
            echo -e "${RED}❌ FAILED${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    fi
    echo ""
}


# Test 1: Basic Help and Usage
echo -e "${BLUE}=== No Params, shows help ===${NC}"
run_test "No arguments (should show help)" "lucli lint" "0" "No file or folder specified."

echo -e "${BLUE}=== File Param ===${NC}"
run_test "No arguments (should show help)" "lucli Lint file=tests/example.cfm" "0"




# Test Results Summary
echo ""
echo -e "${BLUE}📊 Test Results Summary${NC}"
echo -e "${BLUE}======================${NC}"
echo -e "Total tests run: ${TOTAL_TESTS}"
echo -e "Tests passed: $((TOTAL_TESTS - FAILED_TESTS))"
echo -e "Tests failed: ${FAILED_TESTS}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed! LuCLi Lint is working correctly.${NC}"
    # echo -e "${GREEN}✨ Binary executable: ✓${NC}"
    # echo -e "${GREEN}✨ Internationalization: ✓${NC}"
    # echo -e "${GREEN}✨ Terminal commands: ✓${NC}"
    # echo -e "${GREEN}✨ CFML execution: ✓${NC}"
    # echo -e "${GREEN}✨ File operations: ✓${NC}"
    # echo -e "${GREEN}✨ Server management: ✓${NC}"
    # echo -e "${GREEN}✨ Server CFML integration: ✓${NC}"
    # echo -e "${GREEN}✨ HTTP .cfs/.cfm execution: ✓${NC}"
    # echo -e "${GREEN}✨ URL rewrite routing: ✓${NC}"
    # echo -e "${GREEN}✨ Framework-style routing: ✓${NC}"
    # echo -e "${GREEN}✨ JMX monitoring: ✓${NC}"
    # echo -e "${GREEN}✨ Configuration system: ✓${NC}"
    # echo -e "${GREEN}✨ Command consistency: ✓${NC}"
    # echo -e "${GREEN}✨ Template system: ✓${NC}"
    # echo -e "${GREEN}✨ Version bumping: ✓${NC}"
    # echo -e "${GREEN}✨ Settings persistence: ✓${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}⚠️  Some tests failed. Please review the output above.${NC}"
    # echo -e "${YELLOW}💡 Common issues:${NC}"
    # echo -e "${YELLOW}   - Ensure Maven build completed successfully with binary profile${NC}"
    # echo -e "${YELLOW}   - Check Java version compatibility (requires Java 17+)${NC}"
    # echo -e "${YELLOW}   - Verify Lucee engine is properly included${NC}"
    # echo -e "${YELLOW}   - Check network connectivity for Lucee Express downloads${NC}"
    # echo -e "${YELLOW}   - Ensure sufficient disk space for server instances${NC}"
    # echo -e "${YELLOW}   - Verify ports 8000-8999 range is available for testing${NC}"
    exit 1
fi
