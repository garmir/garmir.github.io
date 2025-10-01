#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash coreutils nmap curl netcat dnsutils iputils nodejs python3 go rustc gcc jq ripgrep fd tree file github-cli bc

# SuperClaude Framework Tool Arsenal Test
# Tests comprehensive tool availability via nix-shell

set -e

echo "🛠️  SuperClaude Framework Tool Arsenal Test"
echo "==========================================="

# Test 1: Network Security Tools
echo ""
echo "Test 1: Network Security Tools"
echo "------------------------------"

NETWORK_TOOLS=0
NETWORK_TOTAL=5

echo "Testing network tools availability..."

if nix-shell -p nmap --run 'nmap --version' >/dev/null 2>&1; then
    echo "✅ nmap: Available"
    ((NETWORK_TOOLS++))
else
    echo "❌ nmap: Not available"
fi

if nix-shell -p curl --run 'curl --version' >/dev/null 2>&1; then
    echo "✅ curl: Available"
    ((NETWORK_TOOLS++))
else
    echo "❌ curl: Not available"
fi

if nix-shell -p netcat --run 'nc -h' >/dev/null 2>&1; then
    echo "✅ netcat: Available"
    ((NETWORK_TOOLS++))
else
    echo "❌ netcat: Not available"
fi

if nix-shell -p dnsutils --run 'dig -v' >/dev/null 2>&1; then
    echo "✅ dig: Available"
    ((NETWORK_TOOLS++))
else
    echo "❌ dig: Not available"
fi

if nix-shell -p iputils --run 'ping -V' >/dev/null 2>&1; then
    echo "✅ ping: Available"
    ((NETWORK_TOOLS++))
else
    echo "❌ ping: Not available"
fi

echo "Network tools: $NETWORK_TOOLS/$NETWORK_TOTAL available"

# Test 2: Development Tools
echo ""
echo "Test 2: Development Tools"
echo "-------------------------"

DEV_TOOLS=0
DEV_TOTAL=5

echo "Testing development tools availability..."

if nix-shell -p nodejs --run 'node --version' >/dev/null 2>&1; then
    echo "✅ nodejs: Available"
    ((DEV_TOOLS++))
else
    echo "❌ nodejs: Not available"
fi

if nix-shell -p python3 --run 'python3 --version' >/dev/null 2>&1; then
    echo "✅ python3: Available"
    ((DEV_TOOLS++))
else
    echo "❌ python3: Not available"
fi

if nix-shell -p go --run 'go version' >/dev/null 2>&1; then
    echo "✅ go: Available"
    ((DEV_TOOLS++))
else
    echo "❌ go: Not available"
fi

if nix-shell -p rustc --run 'rustc --version' >/dev/null 2>&1; then
    echo "✅ rust: Available"
    ((DEV_TOOLS++))
else
    echo "❌ rust: Not available"
fi

if nix-shell -p gcc --run 'gcc --version' >/dev/null 2>&1; then
    echo "✅ gcc: Available"
    ((DEV_TOOLS++))
else
    echo "❌ gcc: Not available"
fi

echo "Development tools: $DEV_TOOLS/$DEV_TOTAL available"

# Test 3: Analysis Tools
echo ""
echo "Test 3: Analysis Tools"
echo "----------------------"

ANALYSIS_TOOLS=0
ANALYSIS_TOTAL=5

echo "Testing analysis tools availability..."

if nix-shell -p jq --run 'jq --version' >/dev/null 2>&1; then
    echo "✅ jq: Available"
    ((ANALYSIS_TOOLS++))
else
    echo "❌ jq: Not available"
fi

if nix-shell -p ripgrep --run 'rg --version' >/dev/null 2>&1; then
    echo "✅ ripgrep: Available"
    ((ANALYSIS_TOOLS++))
else
    echo "❌ ripgrep: Not available"
fi

if nix-shell -p fd --run 'fd --version' >/dev/null 2>&1; then
    echo "✅ fd: Available"
    ((ANALYSIS_TOOLS++))
else
    echo "❌ fd: Not available"
fi

if nix-shell -p tree --run 'tree --version' >/dev/null 2>&1; then
    echo "✅ tree: Available"
    ((ANALYSIS_TOOLS++))
else
    echo "❌ tree: Not available"
fi

if nix-shell -p file --run 'file --version' >/dev/null 2>&1; then
    echo "✅ file: Available"
    ((ANALYSIS_TOOLS++))
else
    echo "❌ file: Not available"
fi

echo "Analysis tools: $ANALYSIS_TOOLS/$ANALYSIS_TOTAL available"

# Test 4: GitHub CLI (Critical)
echo ""
echo "Test 4: GitHub CLI (Critical)"
echo "-----------------------------"

if nix-shell -p github-cli --run 'gh --version' >/dev/null 2>&1; then
    echo "✅ GitHub CLI: Available (CRITICAL tool confirmed)"
else
    echo "❌ GitHub CLI: Not available (CRITICAL FAILURE)"
    exit 1
fi

# Test 5: Comprehensive Environment Test
echo ""
echo "Test 5: Comprehensive Environment"
echo "---------------------------------"

echo "Testing comprehensive tool environment..."
if nix-shell -p github-cli nodejs python3 ripgrep fd jq curl nmap --run 'echo "All tools loaded successfully"' >/dev/null 2>&1; then
    echo "✅ COMPREHENSIVE: All critical tools can be loaded together"
else
    echo "❌ COMPREHENSIVE: Failed to load all tools in single environment"
    exit 1
fi

# Calculate overall success rate
TOTAL_TOOLS=$((NETWORK_TOOLS + DEV_TOOLS + ANALYSIS_TOOLS + 1))  # +1 for GitHub CLI
TOTAL_POSSIBLE=$((NETWORK_TOTAL + DEV_TOTAL + ANALYSIS_TOTAL + 1))
SUCCESS_RATE=$(echo "scale=1; $TOTAL_TOOLS * 100 / $TOTAL_POSSIBLE" | nix-shell -p bc --run 'bc')

echo ""
echo "🎯 TOOL ARSENAL TEST COMPLETE"
echo "============================="
echo "📊 Overall success rate: ${SUCCESS_RATE}% ($TOTAL_TOOLS/$TOTAL_POSSIBLE tools)"

if [ "$TOTAL_TOOLS" -eq "$TOTAL_POSSIBLE" ]; then
    echo "✅ EXCELLENT: All tools available via nix-shell"
elif [ "$TOTAL_TOOLS" -ge $((TOTAL_POSSIBLE * 80 / 100)) ]; then
    echo "✅ GOOD: Most tools available (>80%)"
else
    echo "⚠️  WARNING: Tool availability below threshold (<80%)"
