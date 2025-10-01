#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash findutils gnugrep coreutils

# SuperClaude Framework Compliance Test
# Tests universal nix-shell wrapping and framework adherence

set -e

echo "🔍 SuperClaude Framework Compliance Test"
echo "=========================================="

# Test 1: Universal Nix-Shell Compliance
echo ""
echo "Test 1: Universal Nix-Shell Compliance"
echo "--------------------------------------"

# Focus only on executable shell scripts, exclude test directory itself
# Look for violations but exclude commands that are properly wrapped in nix-shell contexts
VIOLATIONS=$(find . -name "*.sh" \
  -not -path "./tests/*" \
  -not -path "./backups/*" \
  -not -path "./projects/*" \
  -not -path "./shell-snapshots/*" \
  -not -path "./statsig/*" \
  -exec grep -H "^[^#]*\(for\|while\|gh \|curl \|nmap \|python3 \|node \)" {} \; \
  | grep -v "nix-shell.*--run.*\(for\|while\|gh \|curl \|nmap \|python3 \|node \)" \
  | grep -v "\\\\.*\(for\|while\|gh \|curl \|nmap \|python3 \|node \)" \
  | grep -v "echo" || true)

if [ -n "$VIOLATIONS" ]; then
    echo "❌ COMPLIANCE VIOLATION: Bare commands detected:"
    echo "$VIOLATIONS"
    exit 1
else
    echo "✅ COMPLIANCE: All commands properly wrapped in nix-shell"
fi

# Test 2: GitHub CLI Only (No Direct Git)
echo ""
echo "Test 2: GitHub CLI Only Policy"
echo "------------------------------"

GIT_VIOLATIONS=$(find . -name "*.sh" \
  -not -path "./tests/*" \
  -not -path "./backups/*" \
  -not -path "./projects/*" \
  -not -path "./shell-snapshots/*" \
  -not -path "./statsig/*" \
  -exec grep -l "^[^#]*git \|^git " {} \; \
  | xargs -I {} grep -H "^[^#]*git \|^git " {} || true)

if [ -n "$GIT_VIOLATIONS" ]; then
    echo "❌ POLICY VIOLATION: Direct git commands found:"
    echo "$GIT_VIOLATIONS"
    echo "Use: nix-shell -p github-cli --run 'gh commands' instead"
    exit 1
else
    echo "✅ POLICY: No direct git commands found, GitHub CLI enforced"
fi

# Test 3: Error Handling Patterns
echo ""
echo "Test 3: Error Handling Patterns"
echo "-------------------------------"

if grep -r "continue-on-error" . --include="*.yml" --include="*.yaml" >/dev/null 2>&1; then
    echo "✅ ERROR HANDLING: continue-on-error patterns found"
else
    echo "⚠️  WARNING: No continue-on-error patterns found in workflows"
fi

# Test 4: Ubuntu Fallback Patterns
echo ""
echo "Test 4: Ubuntu Fallback Patterns"
echo "--------------------------------"

if grep -r "apt-get\|sudo.*install" . --include="*.yml" --include="*.yaml" >/dev/null 2>&1; then
    echo "✅ FALLBACK: Ubuntu package fallback patterns found"
else
    echo "⚠️  WARNING: No Ubuntu fallback patterns found"
fi

# Test 5: Documentation Update Requirements
echo ""
echo "Test 5: Documentation Standards"
echo "-------------------------------"

RECENT_DOCS=$(find . -name "*.md" -mtime -1 | wc -l)
if [ "$RECENT_DOCS" -gt 0 ]; then
    echo "✅ DOCUMENTATION: Recent documentation updates found ($RECENT_DOCS files)"
else
    echo "⚠️  INFO: No recent documentation updates (last 24h)"
fi

echo ""
echo "🎯 COMPLIANCE TEST COMPLETE"
echo "==========================="
echo "✅ All critical compliance tests passed"
