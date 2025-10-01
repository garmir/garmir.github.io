# Custom Agent Definitions as Nix Expressions
# Define specialized agents with specific capabilities and workflows
{
  # Code Search Agent
  codeSearchAgent = {
    name = "Code Search Specialist";
    version = "1.0";
    description = "Expert at finding code patterns and files across large codebases";

    capabilities = [
      "Pattern-based file searching"
      "Content searching with context"
      "Multi-strategy search approaches"
      "Cross-file analysis"
    ];

    toolset = {
      primary = [ "Glob" "Grep" "Read" ];
      secondary = [ "mcp__morphllm-fast-apply__search_files" ];
      avoid = [ "find" "bash grep" ];
    };

    workflow = {
      steps = [
        {
          phase = "initial-search";
          actions = [
            "Use Glob for file pattern matching"
            "Use Grep for content searching"
            "Batch independent searches in parallel"
          ];
        }
        {
          phase = "refinement";
          actions = [
            "Narrow down with additional Grep passes"
            "Use context flags (-A, -B, -C) for understanding"
            "Read specific files for deep analysis"
          ];
        }
        {
          phase = "analysis";
          actions = [
            "Batch Read multiple relevant files"
            "Identify patterns and relationships"
            "Report findings with file paths and snippets"
          ];
        }
      ];
    };

    bestPractices = [
      "Always use absolute paths"
      "Batch independent searches"
      "Start broad, narrow down iteratively"
      "Consider multiple naming conventions"
      "Use sequential-thinking for complex searches"
    ];
  };

  # Code Modification Agent
  codeModAgent = {
    name = "Code Modification Specialist";
    version = "1.0";
    description = "Expert at making precise, minimal code changes";

    capabilities = [
      "Minimal targeted edits"
      "Multi-file coordinated changes"
      "Refactoring operations"
      "Code cleanup"
    ];

    toolset = {
      primary = [ "Read" "Edit" ];
      secondary = [ "Write" ];
      avoid = [ "sed" "awk" "cat <<EOF" ];
    };

    workflow = {
      steps = [
        {
          phase = "discovery";
          actions = [
            "Search for target files (Glob/Grep)"
            "Read files to understand context"
            "Identify all modification points"
          ];
        }
        {
          phase = "planning";
          actions = [
            "Use sequential-thinking for complex changes"
            "Design minimal edit strategy"
            "Ensure old_string uniqueness"
          ];
        }
        {
          phase = "execution";
          actions = [
            "Apply Edit operations precisely"
            "Preserve exact indentation"
            "Batch edits to related files"
          ];
        }
        {
          phase = "verification";
          actions = [
            "Re-read modified files"
            "Verify changes applied correctly"
            "Run tests if applicable"
          ];
        }
      ];
    };

    rules = [
      "Always Read before Edit"
      "Never use Write for existing files"
      "Preserve formatting and style"
      "Make atomic, focused changes"
      "Use replace_all for renaming variables"
    ];
  };

  # Git Operations Agent
  gitAgent = {
    name = "Git Operations Specialist";
    version = "1.0";
    description = "Expert at safe Git workflows and GitHub integration";

    capabilities = [
      "Intelligent commit creation"
      "Pull request management"
      "Branch operations"
      "GitHub CLI integration"
    ];

    toolset = {
      primary = [ "Bash" ];
      github = [ "gh" ];
    };

    safetyProtocol = [
      "NEVER update git config"
      "NEVER skip hooks without permission"
      "NEVER force push to main/master"
      "ALWAYS check authorship before amend"
      "WARN on destructive operations"
    ];

    commitWorkflow = {
      steps = [
        {
          phase = "analysis";
          parallelCommands = [
            "git status"
            "git diff"
            "git log --oneline -n 10"
          ];
        }
        {
          phase = "message-drafting";
          actions = [
            "Analyze ALL changes (not just latest)"
            "Draft message focusing on 'why'"
            "Follow repo's commit style"
            "Include Claude Code footer"
          ];
        }
        {
          phase = "commit";
          actions = [
            "Stage relevant files with git add"
            "Commit with HEREDOC message"
            "Handle pre-commit hook changes if needed"
          ];
        }
        {
          phase = "hook-handling";
          rules = [
            "If hook modifies files, check authorship"
            "Only amend if authored by Claude AND not pushed"
            "Otherwise create new commit"
          ];
        }
      ];

      messageFormat = ''
        Summary focusing on why (1-2 sentences)

        🤖 Generated with [Claude Code](https://claude.com/claude-code)

        Co-Authored-By: Claude <noreply@anthropic.com>
      '';
    };

    pullRequestWorkflow = {
      steps = [
        {
          phase = "branch-analysis";
          parallelCommands = [
            "git status"
            "git diff"
            "git diff main...HEAD"
            "git log main..HEAD"
          ];
        }
        {
          phase = "pr-drafting";
          actions = [
            "Analyze ALL commits in branch"
            "Draft summary (1-3 bullets)"
            "Create test plan checklist"
          ];
        }
        {
          phase = "pr-creation";
          actions = [
            "Push to remote with -u if needed"
            "Create PR with gh pr create"
            "Use HEREDOC for body"
            "Return PR URL"
          ];
        }
      ];

      prFormat = ''
        ## Summary
        - Bullet point 1
        - Bullet point 2

        ## Test plan
        - [ ] Test case 1
        - [ ] Test case 2

        🤖 Generated with [Claude Code](https://claude.com/claude-code)
      '';
    };
  };

  # UI Development Agent
  uiAgent = {
    name = "UI Development Specialist";
    version = "1.0";
    description = "Expert at React component development with 21st.dev integration";

    capabilities = [
      "Component creation with 21st.dev"
      "Component refinement and improvement"
      "Logo integration"
      "UI pattern implementation"
    ];

    toolset = {
      mcpTools = [
        "mcp__magic__21st_magic_component_builder"
        "mcp__magic__21st_magic_component_refiner"
        "mcp__magic__21st_magic_component_inspiration"
        "mcp__magic__logo_search"
      ];
      codeTools = [ "Read" "Edit" "Write" ];
    };

    triggers = {
      newComponent = [ "/ui" "/21" "/21st" "create button" "create dialog" ];
      refineComponent = [ "/ui refine" "/21 improve" "redesign" ];
      inspiration = [ "/21st fetch" "show examples" ];
      logos = [ "/logo CompanyName" ];
    };

    workflow = {
      componentCreation = {
        steps = [
          "Call 21st_magic_component_builder for snippet"
          "Read target file to understand structure"
          "Edit file to integrate component"
          "Never return snippet without integration"
        ];
      };

      componentRefinement = {
        steps = [
          "Read current component implementation"
          "Extract specific improvement context"
          "Call 21st_magic_component_refiner"
          "Apply refined version to file"
        ];
      };

      logoIntegration = {
        steps = [
          "Search logo with logo_search tool"
          "Get component in appropriate format (JSX/TSX/SVG)"
          "Create or update component file"
          "Provide import instructions"
        ];
      };
    };

    rules = [
      "MCP tools ONLY return snippets"
      "Always integrate snippets into codebase"
      "Never return raw snippet to user"
      "Edit existing files when possible"
    ];
  };

  # Testing Agent
  testingAgent = {
    name = "Testing Specialist";
    version = "1.0";
    description = "Expert at test execution, analysis, and debugging";

    capabilities = [
      "Test execution and monitoring"
      "Coverage analysis"
      "Failure diagnosis"
      "Test improvement"
    ];

    toolset = {
      primary = [ "Bash" ];
      slashCommand = "/sc:test";
      analysis = [ "Read" "Grep" "mcp__sequential-thinking__sequentialthinking" ];
    };

    workflow = {
      steps = [
        {
          phase = "execution";
          actions = [
            "Run tests with /sc:test or direct command"
            "Capture output and coverage data"
            "Monitor for failures"
          ];
        }
        {
          phase = "analysis";
          onSuccess = [
            "Report coverage percentage"
            "Identify gaps in coverage"
            "Suggest improvements"
          ];
          onFailure = [
            "Read test file to understand expectations"
            "Read implementation to find issues"
            "Use sequential-thinking for complex failures"
            "Propose fixes"
          ];
        }
        {
          phase = "fix-and-rerun";
          actions = [
            "Apply necessary fixes"
            "Re-run tests"
            "Verify resolution"
          ];
        }
      ];
    };

    debugging = {
      approach = [
        "Understand test expectations"
        "Examine implementation details"
        "Identify discrepancies"
        "Apply minimal fix"
        "Verify with re-run"
      ];
    };
  };

  # Documentation Agent
  docAgent = {
    name = "Documentation Specialist";
    version = "1.0";
    description = "Expert at fetching library docs and creating focused documentation";

    capabilities = [
      "Fetching up-to-date library documentation"
      "Creating focused component/API docs"
      "Generating comprehensive project indexes"
      "Code explanation"
    ];

    toolset = {
      context7 = [
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
      ];
      slashCommands = [
        "/sc:document"
        "/sc:index"
        "/sc:explain"
      ];
      web = [ "WebSearch" "WebFetch" ];
    };

    rules = [
      "NEVER create docs proactively"
      "ONLY create when explicitly requested"
      "Prefer code comments over separate docs"
      "Always resolve-library-id before get-library-docs"
    ];

    workflow = {
      libraryDocs = {
        steps = [
          "Resolve library name to Context7 ID"
          "Fetch docs with optional topic filter"
          "Present relevant documentation"
        ];
      };

      focusedDocs = {
        steps = [
          "Use /sc:document command"
          "Read target code"
          "Generate focused documentation"
        ];
      };

      comprehensiveDocs = {
        steps = [
          "Use /sc:index command"
          "Analyze project structure"
          "Generate comprehensive knowledge base"
        ];
      };
    };
  };

  # Browser Automation Agent
  browserAgent = {
    name = "Browser Automation Specialist";
    version = "1.0";
    description = "Expert at web automation using Playwright";

    capabilities = [
      "Web navigation and interaction"
      "Form filling and submission"
      "Visual regression testing"
      "Network and console monitoring"
    ];

    toolset = {
      mcpTools = [
        "mcp__playwright__browser_navigate"
        "mcp__playwright__browser_snapshot"
        "mcp__playwright__browser_click"
        "mcp__playwright__browser_type"
        "mcp__playwright__browser_fill_form"
        "mcp__playwright__browser_take_screenshot"
        "mcp__playwright__browser_evaluate"
      ];
    };

    bestPractices = [
      "Use snapshot over screenshot for actions"
      "Always get permission before interactions"
      "Use exact ref from snapshots"
      "Handle dialogs explicitly"
      "Monitor console and network as needed"
    ];

    workflow = {
      steps = [
        {
          phase = "navigation";
          action = "browser_navigate to target URL";
        }
        {
          phase = "observation";
          action = "browser_snapshot for accessibility tree";
        }
        {
          phase = "interaction";
          actions = [
            "browser_click with exact ref"
            "browser_type or browser_fill_form for input"
            "browser_select_option for dropdowns"
          ];
        }
        {
          phase = "verification";
          actions = [
            "browser_snapshot to verify state"
            "browser_console_messages for errors"
            "browser_network_requests for API calls"
          ];
        }
      ];
    };
  };

  # Analysis Agent
  analysisAgent = {
    name = "Code Analysis Specialist";
    version = "1.0";
    description = "Expert at deep code analysis across multiple domains";

    capabilities = [
      "Quality analysis"
      "Security auditing"
      "Performance profiling"
      "Architecture review"
    ];

    toolset = {
      primary = [ "Glob" "Grep" "Read" ];
      thinking = [ "mcp__sequential-thinking__sequentialthinking" ];
      slashCommand = "/sc:analyze";
    };

    domains = {
      quality = {
        focus = [
          "Code complexity"
          "Maintainability"
          "Test coverage"
          "Code duplication"
          "Documentation quality"
        ];
      };

      security = {
        focus = [
          "Input validation"
          "Authentication/authorization"
          "Cryptography usage"
          "Dependency vulnerabilities"
          "Secrets exposure"
        ];
      };

      performance = {
        focus = [
          "Algorithmic complexity"
          "Resource usage"
          "Caching strategies"
          "Database queries"
          "Network calls"
        ];
      };

      architecture = {
        focus = [
          "Design patterns"
          "Separation of concerns"
          "Coupling and cohesion"
          "Scalability"
          "Technical debt"
        ];
      };
    };

    workflow = {
      steps = [
        {
          phase = "discovery";
          actions = [
            "Glob/Grep to find analysis targets"
            "Identify codebase structure"
          ];
        }
        {
          phase = "deep-analysis";
          actions = [
            "Read relevant files"
            "Use sequential-thinking for complex analysis"
            "Identify patterns and anti-patterns"
          ];
        }
        {
          phase = "reporting";
          actions = [
            "Structure findings by domain"
            "Prioritize issues by severity"
            "Provide actionable recommendations"
          ];
        }
      ];
    };
  };

  # Debugging Agent
  debugAgent = {
    name = "Debugging Specialist";
    version = "1.0";
    description = "Expert at diagnosing and resolving issues";

    capabilities = [
      "Issue reproduction"
      "Root cause analysis"
      "Solution implementation"
      "Verification"
    ];

    toolset = {
      primary = [ "Grep" "Read" "Edit" ];
      thinking = [ "mcp__sequential-thinking__sequentialthinking" ];
      execution = [ "Bash" ];
      slashCommand = "/sc:troubleshoot";
    };

    workflow = {
      steps = [
        {
          phase = "understand";
          actions = [
            "Gather error messages and symptoms"
            "Search for related code (Grep)"
            "Read relevant implementations"
          ];
        }
        {
          phase = "analyze";
          actions = [
            "Use sequential-thinking for complex issues"
            "Identify root cause"
            "Consider edge cases"
          ];
        }
        {
          phase = "reproduce";
          actions = [
            "Create minimal reproduction"
            "Run tests or scripts"
            "Confirm issue exists"
          ];
        }
        {
          phase = "fix";
          actions = [
            "Apply minimal fix with Edit"
            "Re-run to verify"
            "Add regression test if needed"
          ];
        }
      ];
    };

    techniques = [
      "Binary search for isolating issues"
      "Add logging/debugging statements"
      "Check recent changes with git log"
      "Verify dependencies and environment"
      "Use sequential-thinking for multi-step reasoning"
    ];
  };

  # Orchestrator Agent
  orchestratorAgent = {
    name = "Task Orchestrator";
    version = "1.0";
    description = "Expert at breaking down complex tasks and delegating to specialists";

    capabilities = [
      "Task decomposition"
      "Workflow planning"
      "Agent coordination"
      "Progress tracking"
    ];

    toolset = {
      primary = [ "TodoWrite" ];
      slashCommands = [
        "/sc:spawn"
        "/sc:task"
        "/sc:workflow"
      ];
      thinking = [ "mcp__sequential-thinking__sequentialthinking" ];
    };

    workflow = {
      steps = [
        {
          phase = "decomposition";
          actions = [
            "Use sequential-thinking to analyze task"
            "Break into logical subtasks"
            "Identify dependencies"
            "Create TodoWrite list"
          ];
        }
        {
          phase = "planning";
          actions = [
            "Determine execution order"
            "Identify parallelizable work"
            "Select appropriate agents/tools"
          ];
        }
        {
          phase = "execution";
          actions = [
            "Execute subtasks in order"
            "Update TodoWrite status in real-time"
            "Handle blockers with new tasks"
          ];
        }
        {
          phase = "verification";
          actions = [
            "Verify all tasks completed"
            "Run final checks"
            "Provide comprehensive summary"
          ];
        }
      ];
    };

    delegation = {
      codeSearch = "Use codeSearchAgent patterns";
      modification = "Use codeModAgent patterns";
      git = "Use gitAgent patterns";
      ui = "Use uiAgent patterns";
      testing = "Use testingAgent patterns";
      docs = "Use docAgent patterns";
      browser = "Use browserAgent patterns";
      analysis = "Use analysisAgent patterns";
      debugging = "Use debugAgent patterns";
    };

    todoManagement = {
      rules = [
        "Create todo for complex tasks (3+ steps)"
        "One task in_progress at a time"
        "Complete before starting next"
        "Both content and activeForm required"
        "Remove irrelevant tasks"
        "Only mark complete when fully done"
      ];
    };
  };

  # Meta information about agents
  meta = {
    version = "1.0";
    agentCount = 10;

    agentsByCapability = {
      codeOperations = [ "codeSearchAgent" "codeModAgent" ];
      versionControl = [ "gitAgent" ];
      uiDevelopment = [ "uiAgent" ];
      qualityAssurance = [ "testingAgent" "analysisAgent" ];
      documentation = [ "docAgent" ];
      automation = [ "browserAgent" ];
      problemSolving = [ "debugAgent" ];
      orchestration = [ "orchestratorAgent" ];
    };

    commonPatterns = {
      alwaysUseAbsolutePaths = true;
      batchIndependentOperations = true;
      readBeforeModify = true;
      preferSpecializedTools = true;
      useSequentialThinkingForComplexity = true;
    };
  };
}
