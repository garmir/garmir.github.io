#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash tmux python3 curl

# SuperClaude Framework Integration Test
# Tests complete end-to-end framework integration

set -e

echo "🔗 SuperClaude Framework Integration Test"
echo "========================================="

# Test 1: Session Management Integration
echo ""
echo "Test 1: Session Management Integration"
echo "-------------------------------------"

if tmux list-sessions | grep -q "superclaude-test"; then
    echo "✅ INTEGRATION: Active session found"
    SESSION_STATUS=$(tmux display-message -t superclaude-test -p "#{session_name}")
    echo "   Session: $SESSION_STATUS operational"
else
    echo "❌ INTEGRATION: No active session found"
    exit 1
fi

# Test 2: Content Server Integration
echo ""
echo "Test 2: Content Server Integration"
echo "---------------------------------"

if netstat -tlnp 2>/dev/null | grep -q ":8080"; then
    echo "✅ INTEGRATION: Local server operational"
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ | grep -q "200"; then
        echo "   Server responding: 200 OK"
    else
        echo "❌ Server not responding correctly"
        exit 1
    fi
else
    echo "❌ INTEGRATION: Local server not found"
    exit 1
fi

# Test 3: Content and Framework Integration
echo ""
echo "Test 3: Content and Framework Integration"
echo "---------------------------------------"

SITE_CONTENT_COUNT=$(find /home/a/.claude/site-content -type f | wc -l)
if [ "$SITE_CONTENT_COUNT" -ge 8 ]; then
    echo "✅ INTEGRATION: Site content complete ($SITE_CONTENT_COUNT files)"
else
    echo "❌ INTEGRATION: Incomplete site content"
    exit 1
fi

# Test 4: Automation Scripts Integration
echo ""
echo "Test 4: Automation Scripts Integration"
echo "------------------------------------"

AUTOMATION_SCRIPTS=$(find /home/a/.claude -name "*automation*.sh" | wc -l)
if [ "$AUTOMATION_SCRIPTS" -ge 2 ]; then
    echo "✅ INTEGRATION: Automation scripts available ($AUTOMATION_SCRIPTS scripts)"
else
    echo "❌ INTEGRATION: Missing automation scripts"
    exit 1
fi

# Test 5: Complete System Integration
echo ""
echo "Test 5: Complete System Integration"
echo "----------------------------------"

echo "Testing complete workflow integration..."
if [ -f "/home/a/.claude/site-deployment.tar.gz" ]; then
    echo "✅ INTEGRATION: Deployment package prepared"
    PACKAGE_SIZE=$(stat -c%s "/home/a/.claude/site-deployment.tar.gz")
    echo "   Package size: $PACKAGE_SIZE bytes"
else
    echo "❌ INTEGRATION: Deployment package missing"
    exit 1
fi

echo ""
echo "🎯 INTEGRATION TEST COMPLETE"
echo "============================"
echo "✅ All components successfully integrated"
echo "✅ End-to-end workflow operational"
