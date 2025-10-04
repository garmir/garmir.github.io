# Morphllm MCP Server

**Purpose**: Pattern-based code editing engine with token optimization for bulk transformations

## Triggers
- Multi-file edit operations requiring consistent patterns
- Framework updates, style guide enforcement, code cleanup
- Bulk text replacements across multiple files
- Natural language edit instructions with specific scope
- Token optimization needed (efficiency gains 30-50%)

## Choose When
- **Over Serena**: For pattern-based edits, not symbol operations
- **For bulk operations**: Style enforcement, framework updates, text replacements
- **When token efficiency matters**: Fast Apply scenarios with compression needs
- **For simple to moderate complexity**: <10 files, straightforward transformations
- **Not for semantic operations**: Symbol renames, dependency tracking, LSP integration

## Works Best With
- **Serena**: Serena analyzes semantic context → Morphllm executes precise edits
- **Sequential**: Sequential plans edit strategy → Morphllm applies systematic changes

## Nix Environment Integration

### Language-Specific Tool Requirements
Morphllm operations often require language-specific tools available through nix packages:

```bash
# JavaScript/TypeScript transformations
nix-shell -p nodejs typescript eslint prettier

# Python bulk operations
nix-shell -p python3 black isort mypy

# Rust code transformations
nix-shell -p rustc cargo rustfmt clippy

# Go bulk edits
nix-shell -p go gofumpt golangci-lint

# General text processing
nix-shell -p ripgrep fd jq yq
```

### Bulk Transformation Patterns
**Framework Migrations**: Ensure nix environment has all required tools
```bash
nix-shell -p nodejs typescript --run 'morphllm "migrate from Vue 2 to Vue 3"'
```

**Style Enforcement**: Use language formatters within nix
```bash
nix-shell -p python3 black --run 'morphllm "enforce PEP8 across all Python files"'
```

**Multi-Language Projects**: Combined tool environments
```bash
nix-shell -p nodejs python3 go --run 'morphllm "standardize logging across all languages"'
```

### Token Optimization with Nix Tools
- **Preprocessing**: Use nix tools for initial analysis before Morphllm operations
- **Validation**: Leverage language servers and linters available in nix
- **Parallel Processing**: Utilize nix environment isolation for concurrent transformations

### Multi-File Editing Best Practices
1. **Tool Availability Check**: Verify required nix packages before bulk operations
2. **Environment Isolation**: Use separate nix shells for different language stacks
3. **Validation Pipeline**: Combine Morphllm edits with nix-provided validation tools
4. **Rollback Strategy**: Maintain git state with nix environment reproducibility

## Examples
```
"update all React class components to hooks" → Morphllm (pattern transformation)
"enforce ESLint rules across project" → Morphllm (style guide application)
"replace all console.log with logger calls" → Morphllm (bulk text replacement)
"rename getUserData function everywhere" → Serena (symbol operation)
"analyze code architecture" → Sequential (complex analysis)
"explain this algorithm" → Native Claude (simple explanation)
```