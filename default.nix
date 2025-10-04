# Main entry point for .claude configuration
# Usage: nix-instantiate --eval --strict --json default.nix
{
  # Import all configuration modules
  methodologies = import ./methodologies.nix;
  settings = import ./settings.nix;
  permissions = import ./permissions.nix;
  agents = import ./agents.nix;
  workflows = import ./workflows.nix;

  # Metadata about this configuration
  meta = {
    version = "1.0.0";
    description = "Claude Code configuration as pure Nix expressions";
    lastModified = "2025-09-30";
  };

  # Helper function to generate Claude Code settings JSON
  generateSettings = builtins.toJSON (import ./settings.nix);

  # Helper function to generate permissions JSON
  generatePermissions = builtins.toJSON (import ./permissions.nix);

  # Helper function to get all agent definitions
  getAllAgents = import ./agents.nix;

  # Helper function to get all workflows
  getAllWorkflows = import ./workflows.nix;

  # Helper function to get methodology by name
  getMethodology = name:
    let methodologies = import ./methodologies.nix;
    in methodologies.${name} or null;

  # Export complete configuration for Claude Code
  claudeConfig = {
    settings = import ./settings.nix;
    permissions = import ./permissions.nix;
    agents = import ./agents.nix;
    workflows = import ./workflows.nix;
  };
}
