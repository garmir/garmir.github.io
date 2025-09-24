#!/bin/bash

# Comprehensive Site Testing Framework for garmir.io
# Tests all claims about site transformation and functionality

set -e

echo "=== GARMIR.IO SITE COMPREHENSIVE TESTING ==="
echo "Testing all claims about site transformation..."
echo

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
ISSUES_FOUND=()

test_pass() {
    echo "✅ PASS: $1"
    ((TESTS_PASSED++))
}

test_fail() {
    echo "❌ FAIL: $1"
    echo "   Details: $2"
    ISSUES_FOUND+=("$1: $2")
    ((TESTS_FAILED++))
}

echo "=== 1. STRUCTURE VALIDATION ==="

# Test 1.1: Verify all expected files exist
echo "Testing file structure..."
REQUIRED_FILES=(
    "index.html"
    "posts.html"
    "projects.html"
    "pictures.html"
    "garmir.io_directory/directory.html"
    "garmir.io_assets/style.css"
    "garmir.io_assets/globe.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "/home/a/site-repo/$file" ]]; then
        test_pass "File exists: $file"
    else
        test_fail "Missing file: $file" "Required file not found"
    fi
done

echo
echo "=== 2. NAVIGATION CONSISTENCY ==="

# Test 2.1: Check for consistent sidebar navigation in all HTML files
echo "Testing navigation consistency..."
find /home/a/site-repo -name "*.html" -exec basename {} \; | while read html_file; do
    full_path=$(find /home/a/site-repo -name "$html_file" -type f)
    if grep -q "sidebar" "$full_path" && grep -q "nav-item" "$full_path"; then
        test_pass "Navigation present in: $html_file"
    else
        test_fail "Missing navigation in: $html_file" "No sidebar or nav-item elements found"
    fi
done

echo
echo "=== 3. CSS AND STYLING VALIDATION ==="

# Test 3.1: Check for no horizontal scrollbars
echo "Testing horizontal scroll prevention..."
if grep -q "overflow-x.*hidden\|max-width.*100%\|box-sizing.*border-box" /home/a/site-repo/garmir.io_assets/style.css; then
    test_pass "Horizontal scroll prevention implemented"
else
    test_fail "Horizontal scroll prevention" "No overflow-x controls found in CSS"
fi

# Test 3.2: Check for responsive design
echo "Testing responsive design implementation..."
if grep -q "@media" /home/a/site-repo/garmir.io_assets/style.css; then
    media_queries=$(grep -c "@media" /home/a/site-repo/garmir.io_assets/style.css)
    test_pass "Responsive design implemented ($media_queries media queries)"
else
    test_fail "Responsive design" "No media queries found in CSS"
fi

# Test 3.3: Check for ASCII/TUI compliance
echo "Testing ASCII/TUI theme compliance..."
if grep -q "monospace\|Courier\|Monaco" /home/a/site-repo/garmir.io_assets/style.css; then
    test_pass "Monospace fonts implemented"
else
    test_fail "Monospace fonts" "No monospace font declarations found"
fi

if grep -q "background.*#000\|background.*black\|color.*#0f0\|color.*green" /home/a/site-repo/garmir.io_assets/style.css; then
    test_pass "Dark theme colors implemented"
else
    test_fail "Dark theme colors" "No dark theme color scheme found"
fi

echo
echo "=== 4. GLOBE IMPLEMENTATION ==="

# Test 4.1: Check for globe JavaScript files
echo "Testing globe implementation..."
GLOBE_FILES=("globe.js" "terminal-globe.js" "globe-geolocation.js")
for globe_file in "${GLOBE_FILES[@]}"; do
    if [[ -f "/home/a/site-repo/garmir.io_assets/$globe_file" ]]; then
        test_pass "Globe file exists: $globe_file"
    else
        test_fail "Missing globe file: $globe_file" "Required globe implementation file not found"
    fi
done

# Test 4.2: Check if globe is properly integrated in HTML
if grep -q "globe\|terminal-globe" /home/a/site-repo/index.html; then
    test_pass "Globe integration in index.html"
else
    test_fail "Globe integration" "No globe references found in index.html"
fi

echo
echo "=== 5. LINK FUNCTIONALITY ==="

# Test 5.1: Check for relative path correctness
echo "Testing relative path structure..."
find /home/a/site-repo -name "*.html" -exec grep -l "href=" {} \; | while read html_file; do
    # Check if file contains relative links
    if grep -q 'href="\.\.' "$html_file" || grep -q 'href="garmir' "$html_file"; then
        test_pass "Relative paths found in: $(basename $html_file)"
    else
        # Could be root level files with simple relative paths
        if grep -q 'href="[^h]' "$html_file"; then
            test_pass "Local paths found in: $(basename $html_file)"
        fi
    fi
done

echo
echo "=== 6. MOBILE NAVIGATION ==="

# Test 6.1: Check for mobile drawer elements
echo "Testing mobile navigation implementation..."
if grep -q "drawer-mobile\|mobile-nav\|hamburger" /home/a/site-repo/garmir.io_assets/style.css; then
    test_pass "Mobile navigation elements implemented"
else
    test_fail "Mobile navigation" "No mobile navigation patterns found in CSS"
fi

echo
echo "=== 7. LAYOUT STRUCTURE ==="

# Test 7.1: Check for proper grid layouts
echo "Testing layout structure..."
if grep -q "page-grid\|sections-grid\|display.*grid" /home/a/site-repo/garmir.io_assets/style.css; then
    test_pass "Grid layout system implemented"
else
    test_fail "Grid layout" "No grid layout system found in CSS"
fi

echo
echo "=== 8. FAKE TERMINAL REMOVAL ==="

# Test 8.1: Check that fake terminal elements are removed
echo "Testing fake terminal removal..."
if grep -q "fake-terminal\|terminal-fake\|mock-terminal" /home/a/site-repo/garmir.io_assets/style.css ||
   find /home/a/site-repo -name "*.html" -exec grep -l "fake-terminal\|terminal-fake\|mock-terminal" {} \; | head -1; then
    test_fail "Fake terminal elements" "Fake terminal elements still present"
else
    test_pass "Fake terminal elements removed"
fi

echo
echo "=== 9. CONTENT VALIDATION ==="

# Test 9.1: Check that content pages exist and have proper structure
echo "Testing content page structure..."
CONTENT_DIRS=("garmir.io_posts" "garmir.io_projects")
for dir in "${CONTENT_DIRS[@]}"; do
    if [[ -d "/home/a/site-repo/garmir.io_directory/$dir" ]]; then
        file_count=$(find "/home/a/site-repo/garmir.io_directory/$dir" -name "*.html" | wc -l)
        if [[ $file_count -gt 0 ]]; then
            test_pass "Content directory $dir has $file_count files"
        else
            test_fail "Empty content directory: $dir" "Directory exists but contains no HTML files"
        fi
    else
        test_fail "Missing content directory: $dir" "Expected directory not found"
    fi
done

echo
echo "=== COMPREHENSIVE TEST RESULTS ==="
echo "Tests Passed: $TESTS_PASSED"
echo "Tests Failed: $TESTS_FAILED"
echo "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"

if [[ $TESTS_FAILED -gt 0 ]]; then
    echo
    echo "=== ISSUES FOUND ==="
    for issue in "${ISSUES_FOUND[@]}"; do
        echo "• $issue"
    done
    echo
    echo "❌ OVERALL RESULT: ISSUES DETECTED"
    exit 1
else
    echo
    echo "✅ OVERALL RESULT: ALL TESTS PASSED"
fi