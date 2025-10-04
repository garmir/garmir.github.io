# Context7 MCP Server

**Purpose**: Official library documentation lookup and framework pattern guidance

## Triggers
- Import statements: `import`, `require`, `from`, `use`
- Framework keywords: React, Vue, Angular, Next.js, Express, etc.
- Library-specific questions about APIs or best practices
- Need for official documentation patterns vs generic solutions
- Version-specific implementation requirements

## Choose When
- **Over WebSearch**: When you need curated, version-specific documentation
- **Over native knowledge**: When implementation must follow official patterns
- **For frameworks**: React hooks, Vue composition API, Angular services
- **For libraries**: Correct API usage, authentication flows, configuration
- **For compliance**: When adherence to official standards is mandatory

## Works Best With
- **Sequential**: Context7 provides docs → Sequential analyzes implementation strategy
- **Magic**: Context7 supplies patterns → Magic generates framework-compliant components

## Nix Environment Integration

### Required Packages
Context7 MCP operations require specific nix packages for API interactions:
```bash
nix-shell -p curl jq nodejs --run 'command'
```

### Core Dependencies
- **curl**: HTTP API calls to Context7 documentation service
- **jq**: JSON response parsing and data extraction
- **nodejs**: MCP server runtime and package resolution

### Integration Patterns

#### Framework Documentation Access
```bash
# React patterns with nix environment
nix-shell -p nodejs curl jq --run '
  npx @anthropic-ai/claude-code "Get React useEffect patterns from Context7"
'

# Next.js optimization docs
nix-shell -p nodejs curl jq --run '
  npx @anthropic-ai/claude-code "Context7 Next.js performance patterns"
'
```

#### Library Integration Examples
```bash
# Auth0 documentation lookup
cd ~ && nix-shell -p nodejs curl jq --run 'expect -c "
  spawn npx @anthropic-ai/claude-code --dangerously-skip-permissions \"Context7: Auth0 integration patterns\"
  expect {
    -re {.*bypass permissions.*} { send \"2\r\" }
  }
  expect {
    -re {.*documentation.*|.*patterns.*} { exit 0 }
    timeout { exit 1 }
  }
"'

# Vue 3 migration guide access
cd ~ && nix-shell -p nodejs curl jq --run 'expect -c "
  spawn npx @anthropic-ai/claude-code --dangerously-skip-permissions \"Context7: Vue 3 migration documentation\"
  expect {
    -re {.*bypass permissions.*} { send \"2\r\" }
  }
  expect {
    -re {.*migration.*|.*guide.*} { exit 0 }
    timeout { exit 1 }
  }
"'
```

#### Package Management Integration
```bash
# Framework detection with package.json
nix-shell -p nodejs jq --run '
  FRAMEWORK=$(jq -r ".dependencies | keys[]" package.json | grep -E "react|vue|angular" | head -1)
  npx @anthropic-ai/claude-code "Context7: $FRAMEWORK best practices"
'

# Version-specific documentation
nix-shell -p nodejs jq --run '
  VERSION=$(jq -r ".dependencies.react" package.json)
  npx @anthropic-ai/claude-code "Context7: React $VERSION patterns"
'
```

### Environment Variables
```bash
# Context7 API configuration
export CONTEXT7_TOKEN="your_token_here"
export CONTEXT7_ENDPOINT="https://api.context7.dev"

# Nix shell with Context7 environment
nix-shell -p curl jq nodejs --run '
  npx @anthropic-ai/claude-code "Context7 documentation lookup"
'
```

## Examples
```
"implement React useEffect" → Context7 (official React patterns)
"add authentication with Auth0" → Context7 (official Auth0 docs)
"migrate to Vue 3" → Context7 (official migration guide)
"optimize Next.js performance" → Context7 (official optimization patterns)
"just explain this function" → Native Claude (no external docs needed)
```