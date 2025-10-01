# Serena MCP Server

**Purpose**: Semantic code understanding with project memory and session persistence

## Triggers
- Symbol operations: rename, extract, move functions/classes
- Project-wide code navigation and exploration
- Multi-language projects requiring LSP integration
- Session lifecycle: `/sc:load`, `/sc:save`, project activation
- Memory-driven development workflows
- Large codebase analysis (>50 files, complex architecture)

## Choose When
- **Over Morphllm**: For symbol operations, not pattern-based edits
- **For semantic understanding**: Symbol references, dependency tracking, LSP integration
- **For session persistence**: Project context, memory management, cross-session learning
- **For large projects**: Multi-language codebases requiring architectural understanding
- **Not for simple edits**: Basic text replacements, style enforcement, bulk operations

## Nix Environment Integration

### Required Nix Packages for Semantic Operations
```nix
# Common LSP servers and language tools
- nodePackages.typescript-language-server  # TypeScript/JavaScript
- python3Packages.python-lsp-server       # Python
- rust-analyzer                           # Rust
- gopls                                   # Go
- clang-tools                            # C/C++
- java-language-server                   # Java
- metals                                 # Scala
- omnisharp-roslyn                       # C#
- lua-language-server                    # Lua
```

### Environment Setup Patterns
```bash
# Project activation with LSP integration
nix-shell -p typescript-language-server nodePackages.typescript --run "
  serena activate-project --lsp-mode --memory-persist
"

# Multi-language project support
nix-shell -p rust-analyzer gopls python3Packages.python-lsp-server --run "
  serena load-workspace --multi-lang --symbol-index
"

# Session persistence with nix environment state
nix-shell -p git jq ripgrep --run "
  serena save-session --include-env --memory-checkpoint
"
```

### Symbol Operation Environment Requirements
| Operation | Required Packages | Environment |
|-----------|------------------|-------------|
| TypeScript rename | `typescript-language-server` | Node.js project |
| Python refactor | `python-lsp-server`, `black` | Python development |
| Rust symbol analysis | `rust-analyzer`, `cargo` | Rust workspace |
| Multi-lang project | Language-specific LSPs | Polyglot environment |
| Memory persistence | `git`, `jq`, `sqlite` | All projects |

### Project Memory with Nix Integration
```bash
# Save project state including nix environment
serena memory write "nix_env" "$(nix-instantiate --eval --expr 'builtins.currentSystem')"
serena memory write "project_deps" "$(nix-shell --run 'which typescript-language-server rust-analyzer')"

# Restore project with environment reconstruction
serena load-project --restore-env --nix-shell-deps
```

## Works Best With
- **Morphllm**: Serena analyzes semantic context → Morphllm executes precise edits
- **Sequential**: Serena provides project context → Sequential performs architectural analysis

## Examples
```
"rename getUserData function everywhere" → Serena (symbol operation with dependency tracking)
"find all references to this class" → Serena (semantic search and navigation)
"load my project context" → Serena (/sc:load with project activation)
"save my current work session" → Serena (/sc:save with memory persistence)
"update all console.log to logger" → Morphllm (pattern-based replacement)
"create a login form" → Magic (UI component generation)
```