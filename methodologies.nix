# SuperClaude Methodologies as Nix Attributes
# Each methodology is a structured attribute set with principles, patterns, and practices
{
  # Core SuperClaude Methodology
  superClaude = {
    description = "Advanced AI-assisted development patterns for Claude Code";
    version = "2.0";

    principles = [
      "Explicit over implicit"
      "Structured thinking before action"
      "Minimal file operations"
      "Prefer editing over creating"
      "Context-aware tool selection"
      "Iterative refinement"
    ];

    patterns = {
      searchThenAct = {
        description = "Always search before making changes";
        steps = [
          "Use Grep/Glob to find relevant files"
          "Read files to understand context"
          "Plan changes using structured thinking"
          "Execute minimal necessary edits"
          "Verify changes"
        ];
        tools = [ "Grep" "Glob" "Read" "Edit" ];
      };

      batchOperations = {
        description = "Group independent operations for efficiency";
        steps = [
          "Identify independent operations"
          "Execute parallel tool calls in single response"
          "Process results together"
        ];
        example = "Batch multiple Grep searches or Read operations";
      };

      minimalEdits = {
        description = "Prefer Edit over Write, never create unnecessary files";
        rules = [
          "Always Read before Write"
          "Use Edit for existing files"
          "Only Write for new files when absolutely necessary"
          "Never create README.md or docs unless explicitly requested"
        ];
      };

      structuredThinking = {
        description = "Use sequential-thinking MCP for complex problems";
        when = [
          "Multi-step analysis required"
          "Complex debugging"
          "Architecture decisions"
          "Problem decomposition"
        ];
        tool = "mcp__sequential-thinking__sequentialthinking";
      };
    };

    antiPatterns = [
      "Creating files before checking if they exist"
      "Using relative paths in agent threads"
      "Making assumptions without searching"
      "Premature documentation creation"
      "Using bash for file operations when specialized tools exist"
    ];

    workflows = {
      codeSearch = {
        steps = [
          { action = "Glob"; purpose = "Find candidate files by pattern"; }
          { action = "Grep"; purpose = "Search content with context"; }
          { action = "Read"; purpose = "Deep dive into specific files"; }
        ];
      };

      codeModification = {
        steps = [
          { action = "Search"; purpose = "Locate target files"; }
          { action = "Read"; purpose = "Understand current state"; }
          { action = "Plan"; purpose = "Design minimal changes"; }
          { action = "Edit"; purpose = "Apply precise edits"; }
          { action = "Verify"; purpose = "Confirm changes"; }
        ];
      };

      debugging = {
        steps = [
          { action = "Think"; purpose = "Use sequential-thinking to analyze"; }
          { action = "Search"; purpose = "Find relevant code"; }
          { action = "Read"; purpose = "Examine implementation"; }
          { action = "Test"; purpose = "Reproduce issue"; }
          { action = "Fix"; purpose = "Apply solution"; }
        ];
      };
    };
  };

  # Agent-Specific Methodologies
  agentBestPractices = {
    description = "Patterns for working within agent threads";

    rules = [
      "Always use absolute paths (cwd resets between bash calls)"
      "Prefer specialized tools over bash (Read > cat, Grep > grep)"
      "Batch independent operations in single response"
      "Chain dependent commands with && in single bash call"
    ];

    toolSelection = {
      fileSearch = "Use Glob (NOT find or ls)";
      contentSearch = "Use Grep (NOT grep or rg)";
      readFiles = "Use Read (NOT cat/head/tail)";
      editFiles = "Use Edit (NOT sed/awk)";
      writeFiles = "Use Write (NOT echo >/cat <<EOF)";
    };

    bashUsage = {
      when = [
        "Git operations"
        "npm/package manager commands"
        "Docker operations"
        "Running tests or builds"
        "System commands not covered by specialized tools"
      ];

      avoid = [
        "find (use Glob)"
        "grep/rg (use Grep)"
        "cat/head/tail (use Read)"
        "sed/awk (use Edit)"
        "echo > (use Write)"
      ];
    };
  };

  # Git Workflow Methodology
  gitWorkflow = {
    description = "Structured Git operations with safety protocols";

    safetyProtocol = [
      "NEVER update git config"
      "NEVER run destructive commands without explicit user request"
      "NEVER skip hooks (--no-verify) unless requested"
      "NEVER force push to main/master"
      "ALWAYS check authorship before amending"
    ];

    commitProcess = {
      steps = [
        {
          action = "Batch status/diff/log";
          tools = [ "git status" "git diff" "git log" ];
          parallel = true;
        }
        {
          action = "Analyze changes";
          purpose = "Draft commit message (why, not what)";
        }
        {
          action = "Stage and commit";
          format = "HEREDOC with Claude Code footer";
        }
        {
          action = "Handle pre-commit";
          rule = "Only amend if authored by Claude and not pushed";
        }
      ];

      commitMessageFormat = ''
        Summary of changes (1-2 sentences focusing on why)

        🤖 Generated with [Claude Code](https://claude.com/claude-code)

        Co-Authored-By: Claude <noreply@anthropic.com>
      '';
    };

    pullRequestProcess = {
      steps = [
        { action = "Batch analysis"; tools = [ "git status" "git diff" "git log" "git diff [base]...HEAD" ]; }
        { action = "Draft PR summary"; include = "ALL commits in branch"; }
        { action = "Create/push/PR"; parallel = true; }
      ];

      prFormat = ''
        ## Summary
        <1-3 bullet points>

        ## Test plan
        [Bulleted markdown checklist of TODOs for testing the pull request...]

        🤖 Generated with [Claude Code](https://claude.com/claude-code)
      '';
    };
  };

  # UI Development Methodology
  uiWorkflow = {
    description = "Patterns for UI component development with MCP tools";

    tools = {
      componentBuilder = "mcp__magic__21st_magic_component_builder";
      componentRefiner = "mcp__magic__21st_magic_component_refiner";
      componentInspiration = "mcp__magic__21st_magic_component_inspiration";
      logoSearch = "mcp__magic__logo_search";
    };

    triggers = {
      newComponent = [ "/ui" "/21" "/21st" "create button" "create dialog" ];
      refineComponent = [ "/ui refine" "/21 improve" "redesign component" ];
      inspiration = [ "/21st fetch" "show examples" "component inspiration" ];
      logos = [ "/logo CompanyName" "add logo" ];
    };

    workflow = {
      steps = [
        { action = "Call MCP tool"; purpose = "Get component snippet"; }
        { action = "Read target file"; purpose = "Understand integration point"; }
        { action = "Edit file"; purpose = "Integrate snippet into codebase"; }
      ];

      note = "MCP tools ONLY return snippets - you must integrate them";
    };
  };

  # Documentation Methodology
  docWorkflow = {
    description = "When and how to create documentation";

    rules = [
      "NEVER create docs proactively"
      "ONLY create when explicitly requested"
      "Prefer code comments over separate docs"
      "Use /document slash command for focused docs"
    ];

    tools = {
      focused = "/document";
      comprehensive = "/index";
    };
  };

  # Testing Methodology
  testWorkflow = {
    description = "Test execution and analysis patterns";

    command = "/test";

    process = {
      steps = [
        { action = "Execute tests"; tool = "/test or bash"; }
        { action = "Analyze coverage"; tool = "coverage reports"; }
        { action = "Report quality"; include = [ "pass/fail" "coverage %" "gaps" ]; }
      ];
    };

    debugging = {
      onFailure = [
        "Read test file to understand expectations"
        "Read implementation to find issue"
        "Use sequential-thinking for complex failures"
        "Fix and re-run"
      ];
    };
  };

  # Code Analysis Methodology
  analysisWorkflow = {
    description = "Systematic code analysis patterns";

    command = "/analyze";

    domains = [
      "quality"
      "security"
      "performance"
      "architecture"
    ];

    process = {
      steps = [
        { action = "Glob/Grep"; purpose = "Find analysis targets"; }
        { action = "Read"; purpose = "Examine code"; }
        { action = "Think"; purpose = "Use sequential-thinking for deep analysis"; }
        { action = "Report"; purpose = "Structured findings"; }
      ];
    };
  };

  # Browser Automation Methodology
  browserWorkflow = {
    description = "Playwright MCP patterns for browser automation";

    tools = {
      snapshot = "mcp__playwright__browser_snapshot";
      click = "mcp__playwright__browser_click";
      type = "mcp__playwright__browser_type";
      navigate = "mcp__playwright__browser_navigate";
    };

    bestPractices = [
      "Use snapshot (accessibility) over screenshot for actions"
      "Always get permission before interactions"
      "Use exact ref from snapshots"
      "Handle dialogs explicitly"
    ];

    workflow = {
      steps = [
        { action = "Navigate"; tool = "browser_navigate"; }
        { action = "Snapshot"; tool = "browser_snapshot"; }
        { action = "Interact"; tools = [ "click" "type" "fill_form" ]; }
        { action = "Verify"; tool = "browser_snapshot"; }
      ];
    };
  };

  # File System Methodology
  fileSystemWorkflow = {
    description = "MCP file system operation patterns";

    mcpTools = {
      read = "mcp__morphllm-fast-apply__read_file";
      readMultiple = "mcp__morphllm-fast-apply__read_multiple_files";
      write = "mcp__morphllm-fast-apply__write_file";
      edit = "mcp__morphllm-fast-apply__tiny_edit_file";
      list = "mcp__morphllm-fast-apply__list_directory";
      tree = "mcp__morphllm-fast-apply__directory_tree";
      search = "mcp__morphllm-fast-apply__search_files";
    };

    whenToUseMcp = [
      "When built-in tools are restricted"
      "For batch file operations"
      "For directory tree visualization"
      "When you need file size info"
    ];

    preference = "Prefer built-in Read/Edit/Write unless MCP is specifically needed";
  };

  # Context7 Documentation Methodology
  context7Workflow = {
    description = "Fetching up-to-date library documentation";

    tools = {
      resolve = "mcp__context7__resolve-library-id";
      getDocs = "mcp__context7__get-library-docs";
    };

    process = {
      steps = [
        {
          action = "Resolve library ID";
          tool = "resolve-library-id";
          input = "library name";
          output = "/org/project or /org/project/version";
        }
        {
          action = "Fetch docs";
          tool = "get-library-docs";
          input = "Context7-compatible ID + optional topic";
          output = "Up-to-date documentation";
        }
      ];
    };

    note = "Always resolve-library-id FIRST unless user provides exact /org/project format";
  };
}
