#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash coreutils

# SuperClaude Framework - Complete Test Suite Runner
# Executes all framework validation tests

set -e

echo "🚀 SuperClaude Framework - Complete Test Suite"
echo "=============================================="
echo ""

# Test execution tracking
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

# Function to run a test
run_test() {
    local test_name="$1"
    local test_script="$2"

    echo "▶️  Running: $test_name"
    echo "=================="

    ((TESTS_RUN++))

    if nix-shell -p bash --run "$test_script"; then
        echo ""
        echo "✅ PASSED: $test_name"
        ((TESTS_PASSED++))
    else
        echo ""
        echo "❌ FAILED: $test_name"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$test_name")
    fi

    echo ""
    echo "================================================"
    echo ""
}

# Execute all test suites
echo "Starting comprehensive framework validation..."
echo ""

# Test Suite 1: Framework Compliance
run_test "Framework Compliance" "./tests/compliance-test.sh"

# Test Suite 2: Performance Validation
run_test "Performance Validation" "./tests/performance-test.sh"

# Test Suite 3: Tool Arsenal
run_test "Tool Arsenal Validation" "./tests/tool-arsenal-test.sh"

# Test Suite 4: Agent Automation
run_test "Agent Automation" "./tests/agent-automation-test.sh"

# Generate final report
echo "🎯 TEST SUITE COMPLETE"
echo "====================="
echo ""
echo "📊 Summary:"
echo "   Tests Run:    $TESTS_RUN"
echo "   Tests Passed: $TESTS_PASSED"
echo "   Tests Failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED!"
    echo "✅ SuperClaude Framework fully validated"
    echo "✅ Ready for production deployment"
    exit 0
else
    echo "⚠️  SOME TESTS FAILED"
    echo "❌ Failed tests:"
    nix-shell -p bash coreutils --run '
    FAILED_TESTS='"${FAILED_TESTS[*]}"'
    IFS=" " read -ra TESTS <<< "$FAILED_TESTS"
    nix-shell -p bash coreutils --run '
    for failed_test in "${TESTS[@]}"; do
        echo "   - $failed_test"
    done
    '
    echo ""
    echo "🔧 Review failed tests and framework compliance"
    exit 1
