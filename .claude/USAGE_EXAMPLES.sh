#!/usr/bin/env bash
# Usage examples for .claude/ Nix configuration

echo "=== .claude/ Nix Configuration Usage Examples ==="
echo

# Example 1: Evaluate the entire configuration
echo "1. Evaluate complete configuration:"
echo "   nix-instantiate --eval --strict --json default.nix"
echo

# Example 2: Get specific methodology
echo "2. Get SuperClaude methodology:"
echo "   nix-instantiate --eval --strict --json -E '(import ./default.nix).getMethodology \"superClaude\"'"
echo

# Example 3: Get all agent definitions
echo "3. Get all agents:"
echo "   nix-instantiate --eval --strict --json -E '(import ./default.nix).getAllAgents'"
echo

# Example 4: Query specific agent
echo "4. Get codeSearchAgent capabilities:"
echo "   nix-instantiate --eval --strict --json -E '(import ./agents.nix).codeSearchAgent.capabilities'"
echo

# Example 5: Get all workflows
echo "5. List all workflows:"
echo "   nix-instantiate --eval --strict --json -E 'builtins.attrNames (import ./workflows.nix)'"
echo

# Example 6: Generate settings JSON
echo "6. Generate settings JSON for Claude Code:"
echo "   nix-instantiate --eval --strict --json -E '(import ./default.nix).generateSettings' | jq . > claude-settings.json"
echo

# Example 7: Query tool permissions
echo "7. Check Git permissions:"
echo "   nix-instantiate --eval --strict --json -E '(import ./permissions.nix).git'"
echo

# Example 8: Get workflow by name
echo "8. Get featureImplementation workflow:"
echo "   nix-instantiate --eval --strict --json -E '(import ./workflows.nix).featureImplementation'"
echo

# Example 9: List all methodologies
echo "9. List all available methodologies:"
echo "   nix-instantiate --eval --strict --json -E 'builtins.attrNames (import ./methodologies.nix)'"
echo

# Example 10: Get tool preferences
echo "10. Get tool preferences:"
echo "    nix-instantiate --eval --strict --json -E '(import ./settings.nix).toolPreferences'"
echo

echo "=== Running Example 1 ==="
nix-instantiate --eval --strict --json default.nix | jq '.meta'

echo
echo "=== Running Example 9 ==="
nix-instantiate --eval --strict --json -E 'builtins.attrNames (import ./methodologies.nix)'
