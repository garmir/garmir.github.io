#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash coreutils bc procps

# SuperClaude Framework Performance Test
# Tests exponential tree optimization vs linear execution

set -e

echo "⚡ SuperClaude Framework Performance Test"
echo "========================================="

# Test 1: Sequential vs Parallel Execution
echo ""
echo "Test 1: Sequential vs Parallel Execution"
echo "----------------------------------------"

# Sequential execution benchmark
echo "🔄 Testing sequential execution..."
START_SEQ=$(date +%s%N)
nix-shell -p coreutils --run 'sleep 0.5'
nix-shell -p coreutils --run 'sleep 0.5'
nix-shell -p coreutils --run 'sleep 0.5'
END_SEQ=$(date +%s%N)
SEQ_TIME=$(echo "scale=3; ($END_SEQ - $START_SEQ) / 1000000000" | bc)

# Parallel execution benchmark
echo "🚀 Testing parallel execution..."
START_PAR=$(date +%s%N)
nix-shell -p coreutils --run 'sleep 0.5' &
nix-shell -p coreutils --run 'sleep 0.5' &
nix-shell -p coreutils --run 'sleep 0.5' &
wait
END_PAR=$(date +%s%N)
PAR_TIME=$(echo "scale=3; ($END_PAR - $START_PAR) / 1000000000" | bc)

# Calculate speedup
SPEEDUP=$(echo "scale=2; $SEQ_TIME / $PAR_TIME" | bc)

echo "📊 Results:"
echo "   Sequential time: ${SEQ_TIME}s"
echo "   Parallel time:   ${PAR_TIME}s"
echo "   Speedup:         ${SPEEDUP}x"

if (( $(echo "$SPEEDUP > 2.0" | bc -l) )); then
    echo "✅ PERFORMANCE: Parallel execution shows significant speedup (${SPEEDUP}x)"
else
    echo "⚠️  WARNING: Parallel speedup less than expected (${SPEEDUP}x < 2.0x)"
fi

# Test 2: Tool Loading Performance
echo ""
echo "Test 2: Tool Loading Performance"
echo "--------------------------------"

# Single comprehensive environment
echo "🔄 Testing comprehensive environment..."
START_COMP=$(date +%s%N)
nix-shell -p coreutils findutils gnugrep jq curl --run 'echo "Tools loaded"' >/dev/null
END_COMP=$(date +%s%N)
COMP_TIME=$(echo "scale=3; ($END_COMP - $START_COMP) / 1000000000" | bc)

# Multiple separate environments
echo "🔄 Testing separate environments..."
START_SEP=$(date +%s%N)
nix-shell -p coreutils --run 'echo "coreutils"' >/dev/null
nix-shell -p findutils --run 'echo "findutils"' >/dev/null
nix-shell -p gnugrep --run 'echo "gnugrep"' >/dev/null
nix-shell -p jq --run 'echo "jq"' >/dev/null
nix-shell -p curl --run 'echo "curl"' >/dev/null
END_SEP=$(date +%s%N)
SEP_TIME=$(echo "scale=3; ($END_SEP - $START_SEP) / 1000000000" | bc)

# Calculate efficiency
EFFICIENCY=$(echo "scale=2; $SEP_TIME / $COMP_TIME" | bc)

echo "📊 Results:"
echo "   Comprehensive env: ${COMP_TIME}s"
echo "   Separate envs:     ${SEP_TIME}s"
echo "   Efficiency ratio:  ${EFFICIENCY}x"

if (( $(echo "$EFFICIENCY > 2.0" | bc -l) )); then
    echo "✅ EFFICIENCY: Comprehensive environment is more efficient (${EFFICIENCY}x faster)"
else
    echo "⚠️  WARNING: Efficiency gain less than expected (${EFFICIENCY}x)"
fi

# Test 3: Memory Usage Estimation
echo ""
echo "Test 3: Resource Usage Analysis"
echo "-------------------------------"

# Get system memory info
TOTAL_MEM=$(nix-shell -p procps --run 'free -m | grep "Mem:" | awk "{print \$2}"')
echo "📊 System total memory: ${TOTAL_MEM}MB"

# Estimate parallel agent capacity
AGENT_MEM=650  # MB per agent (from documentation)
MAX_AGENTS=$(echo "$TOTAL_MEM / $AGENT_MEM" | bc)
echo "📊 Estimated max parallel agents: ${MAX_AGENTS} (at ${AGENT_MEM}MB each)"

if [ "$MAX_AGENTS" -gt 5 ]; then
    echo "✅ CAPACITY: System can handle parallel agent execution (${MAX_AGENTS} agents)"
else
    echo "⚠️  WARNING: Limited parallel capacity (${MAX_AGENTS} agents)"
fi

echo ""
echo "🎯 PERFORMANCE TEST COMPLETE"
echo "============================"
