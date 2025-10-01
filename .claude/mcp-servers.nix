# .claude/mcp-servers.nix
# MCP (Model Context Protocol) Server Declarations
# Declarative configuration for all MCP servers used by Claude Code

{ pkgs }:

{
  # MCP Server definitions
  servers = {
    # Sequential Thinking MCP - Advanced reasoning and chain-of-thought
    sequential-thinking = {
      enable = true;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@modelcontextprotocol/server-sequential-thinking" ];
      env = {};
      description = ''
        Provides advanced sequential reasoning capabilities.
        Use for: Complex problem-solving, multi-step analysis, hypothesis generation.
      '';
      useCases = [
        "Breaking down complex problems into steps"
        "Planning and design with room for revision"
        "Analysis that might need course correction"
        "Hypothesis generation and verification"
      ];
    };

    # Morphllm Fast Apply - Pattern application and transformations
    morphllm-fast-apply = {
      enable = true;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@modelcontextprotocol/server-morphllm-fast-apply" ];
      env = {};
      description = ''
        Optimized file operations and pattern transformations.
        Use for: Bulk edits, multi-file changes, systematic refactoring.
      '';
      useCases = [
        "Read/write/edit operations with high performance"
        "Multi-file pattern application"
        "Directory tree operations"
        "Search and replace across files"
      ];
    };

    # Context7 - Up-to-date library documentation
    context7 = {
      enable = true;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@modelcontextprotocol/server-context7" ];
      env = {};
      description = ''
        Provides up-to-date documentation for libraries and frameworks.
        Use for: NixOS docs, package references, API documentation.
      '';
      useCases = [
        "Resolve library IDs for documentation"
        "Fetch current NixOS/nixpkgs documentation"
        "Get framework-specific guides"
        "Access API references"
      ];
    };

    # Playwright - Browser automation and testing
    playwright = {
      enable = true;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@modelcontextprotocol/server-playwright" ];
      env = {};
      description = ''
        Browser automation for testing and web scraping.
        Use for: E2E testing, web interactions, screenshots.
      '';
      useCases = [
        "Navigate and interact with websites"
        "Take screenshots and page snapshots"
        "Fill forms and click elements"
        "Monitor network requests"
      ];
    };

    # Magic UI - 21st.dev component generation
    magic = {
      enable = true;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@21st-dev/mcp-server-magic" ];
      env = {};
      description = ''
        UI component search and generation from 21st.dev library.
        Use for: Creating React components, UI inspiration, rapid prototyping.
      '';
      useCases = [
        "Search for UI components (buttons, forms, modals)"
        "Generate React/TypeScript components"
        "Fetch component previews"
        "Build UI rapidly with pre-made components"
      ];
    };

    # Serena - Task orchestration (disabled by default)
    serena = {
      enable = false;
      command = "${pkgs.nodejs}/bin/npx";
      args = [ "-y" "@serena/mcp-server" ];
      env = {};
      description = ''
        Advanced task orchestration and session management.
        Use for: Complex workflows, session persistence, task delegation.
      '';
      useCases = [
        "Load and save session contexts"
        "Orchestrate multi-step workflows"
        "Manage task delegation"
        "Session lifecycle management"
      ];
    };
  };

  # Helper functions
  utils = rec {
    # MCP Configuration generation
    toConfig = servers: {
      mcpServers = builtins.mapAttrs (name: cfg:
        if cfg.enable then {
          inherit (cfg) command args env;
        } else null
      ) servers;
    };

    # Get all enabled servers
    enabledServers = servers:
      builtins.filter (name: servers.${name}.enable) (builtins.attrNames servers);

    # Generate MCP config JSON
    generateConfig = servers:
      builtins.toJSON (toConfig servers);
  };
}
