# Recursive Online Research with Parallel GitHub Workflow Methodology

**Purpose**: Iterative online research and testing workflow with parallel GitHub Actions execution until successful access is achieved

## Activation Triggers
- Blocked access scenarios requiring alternative methodologies
- Failed penetration testing attempts needing expanded toolsets
- Research-driven problem solving with iterative improvement
- Manual flags: `--recurse`, `--research-loop`, `--parallel-github`

## Behavioral Changes
- **Iterative Research Cycles**: Continuous online research → test → analyze → research deeper
- **Parallel GitHub Execution**: Deploy multiple concurrent workflows for exponential scaling
- **Success-Driven Termination**: Continue cycles until breakthrough achievement
- **Progressive Enhancement**: Each cycle builds on previous findings and expands capabilities

## Core Methodology

### Research → Test → Scale Cycle

**Phase 1: Online Research**
```bash
# Research new tools and methodologies
WebSearch("topic methodology tools 2025") → Extract GitHub repositories
WebSearch("bypass techniques protocol alternatives") → Document approaches
WebSearch("security vulnerabilities platform specific") → Identify vectors
```

**Phase 2: Parallel Tool Development**
```bash
# Clone and build discovered tools simultaneously
nix-shell -p git gcc go python3 --run 'git clone repo1 && build_tool1' &
nix-shell -p git rust cargo --run 'git clone repo2 && build_tool2' &
nix-shell -p git nodejs npm --run 'git clone repo3 && build_tool3' &
wait # Parallel compilation
```

**Phase 3: GitHub Workflow Deployment**
```yaml
# Deploy parallel testing workflows
strategy:
  matrix:
    tool: [tool1, tool2, tool3, tool4, tool5]
    target: [primary, secondary, tertiary]
    approach: [direct, tunnel, proxy, exploit]
# Results in 60 parallel test combinations (5×4×3)
```

### Exponential Scaling Pattern

**Iteration 1**: 10 research queries → 5 new tools → 25 GitHub workflow jobs
**Iteration 2**: 20 research queries → 15 new tools → 75 GitHub workflow jobs
**Iteration 3**: 40 research queries → 45 new tools → 225 GitHub workflow jobs
**Continue until**: Successful access achieved or 256-job GitHub limit reached

## Success Criteria

### Termination Conditions
- **Success Achieved**: Any testing workflow reports successful access
- **Maximum Iterations**: Prevent infinite loops (default: 10 iterations)
- **Resource Limits**: Respect GitHub Actions 256-job concurrent limit
- **Time Constraints**: Set maximum research duration (default: 24 hours)

### Progress Metrics
- **Tool Discovery Rate**: New tools per iteration
- **Access Vector Expansion**: New methodologies per cycle
- **Success Probability**: Increasing likelihood with each iteration
- **Resource Efficiency**: Success per GitHub Actions job

## Documentation Requirements

### Per-Iteration Documentation
```bash
~/.claude/RESEARCH_ITERATION_[n].md → Research findings per iteration
~/.claude/TOOLS_DISCOVERED_[n].md → New tools per cycle
~/.claude/GITHUB_WORKFLOW_RESULTS_[n].md → Parallel testing results
~/.claude/SUCCESS_PROGRESS_[n].md → Progress toward breakthrough
```

### Cumulative Analysis
```bash
~/.claude/RECURSIVE_RESEARCH_SUMMARY.md → Overall progress tracking
~/.claude/TOOL_EFFECTIVENESS_ANALYSIS.md → Which tools provide results
~/.claude/METHODOLOGY_EVOLUTION.md → How approaches improve over time
~/.claude/GITHUB_SCALING_METRICS.md → Resource usage and optimization
```

## Examples

### Standard Research
```
Research "SSH bypass" → Find 3 tools → Test sequentially → Document results
```

### Recursive Research
```
🔄 Iteration 1: Research "SSH bypass" → Find 5 tools → Test parallel (25 jobs)
   ↓ Results: 3 failures, 2 partial success
🔄 Iteration 2: Research "SSH tunnel protocols" → Find 8 tools → Test parallel (40 jobs)
   ↓ Results: 6 failures, 2 new approaches discovered
🔄 Iteration 3: Research "network protocol exploitation" → Find 12 tools → Test parallel (60 jobs)
   ↓ Results: SUCCESS ACHIEVED - Access gained via discovered methodology
✅ Terminate: Success criteria met, document complete solution
```

This methodology enables **unlimited expansion of research and testing capabilities** through systematic online discovery, source compilation, and massively parallel execution until breakthrough success is achieved.
