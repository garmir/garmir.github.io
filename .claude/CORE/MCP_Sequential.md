# Sequential MCP Server

**Purpose**: Multi-step reasoning engine for complex analysis and systematic problem solving

## Triggers
- Complex debugging scenarios with multiple layers
- Architectural analysis and system design questions
- `--think`, `--think-hard`, `--ultrathink` flags
- Problems requiring hypothesis testing and validation
- Multi-component failure investigation
- Performance bottleneck identification requiring methodical approach

## Choose When
- **Over native reasoning**: When problems have 3+ interconnected components
- **For systematic analysis**: Root cause analysis, architecture review, security assessment
- **When structure matters**: Problems benefit from decomposition and evidence gathering
- **For cross-domain issues**: Problems spanning frontend, backend, database, infrastructure
- **Not for simple tasks**: Basic explanations, single-file changes, straightforward fixes

## Works Best With
- **Context7**: Sequential coordinates analysis → Context7 provides official patterns
- **Magic**: Sequential analyzes UI logic → Magic implements structured components
- **Playwright**: Sequential identifies testing strategy → Playwright executes validation

## Nix Environment Integration

### Required Packages for Complex Analysis
```nix
# Essential analysis tools
ripgrep           # High-performance text search for code pattern analysis
fd                # Fast file discovery for architectural exploration
tree              # Directory structure visualization
jq                # JSON processing for configuration analysis
yq                # YAML processing for deployment configs
bat               # Enhanced file viewing with syntax highlighting

# Language-specific analysis tools
nodejs            # JavaScript/TypeScript project analysis
nix-shell -p python3 --run 'python3           # Python project analysis and scripting
go                # Go project analysis
rust              # Rust project analysis
```

### Multi-Step Reasoning with Tool Availability
```bash
# Performance analysis workflow
nix-shell -p ripgrep fd nodejs --run '
  # Step 1: Identify bottlenecks
  rg "setTimeout|setInterval" --type js
  # Step 2: Analyze async patterns
  fd -e js -x node -e "console.log(require(\"util\").inspect(require(\"{}\")))"
  # Step 3: Cross-reference with profiling
'

# Architecture analysis workflow
nix-shell -p tree jq yq --run '
  # Step 1: Map project structure
  tree -I node_modules
  # Step 2: Analyze configurations
  find . -name "*.json" -exec jq . {} \;
  # Step 3: Review deployment configs
  find . -name "*.yml" -o -name "*.yaml" | xargs yq .
'
```

### Environment Requirements for Systematic Debugging

**Memory-Intensive Analysis**: Requires nix-shell with sufficient resources
```bash
# Large codebase analysis
nix-shell -p ripgrep fd bat --run 'export RIPGREP_CONFIG_PATH=~/.ripgreprc'
```

**Cross-Language Projects**: Multi-runtime environment
```bash
# Full-stack analysis environment
nix-shell -p nodejs python3 go rust jq ripgrep fd tree
```

**Security Assessment**: Specialized tooling
```bash
# Security-focused analysis
nix-shell -p ripgrep semgrep bandit safety --run '
  # Pattern-based vulnerability detection
  rg "(eval|exec|system|shell_exec)" --type py
  # Static analysis integration
'
```

### Integration Patterns

**Hypothesis Testing**: Sequential reasoning → nix tool validation
```
1. Sequential identifies potential issue
2. nix-shell provides analysis tools
3. Tools gather evidence systematically
4. Sequential validates hypothesis with data
```

**Root Cause Analysis**: Tool-assisted investigation
```
1. Sequential structures investigation approach
2. nix tools provide deep scanning capability
3. Evidence accumulation across multiple angles
4. Sequential synthesizes findings into conclusion
```

**Architecture Review**: Multi-tool orchestration
```
1. Sequential plans review methodology
2. nix environment provides complete toolchain
3. Systematic analysis across all components
4. Sequential integrates findings into recommendations
```

## Examples
```
"why is this API slow?" → Sequential (systematic performance analysis)
"design a microservices architecture" → Sequential (structured system design)
"debug this authentication flow" → Sequential (multi-component investigation)
"analyze security vulnerabilities" → Sequential (comprehensive threat modeling)
"explain this function" → Native Claude (simple explanation)
"fix this typo" → Native Claude (straightforward change)
```