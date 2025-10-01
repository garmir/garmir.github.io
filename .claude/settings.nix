# Claude Code Settings as Nix Expression
# Generate JSON with: nix-instantiate --eval --strict --json settings.nix
{
  # Core behavior settings
  behavior = {
    explicitOverImplicit = true;
    minimalFileOperations = true;
    preferEditOverWrite = true;
    requireExplicitDocCreation = true;
    useAbsolutePaths = true;
    batchIndependentOperations = true;
  };

  # Tool preferences
  toolPreferences = {
    fileSearch = {
      primary = "Glob";
      avoid = [ "find" "ls" ];
    };

    contentSearch = {
      primary = "Grep";
      avoid = [ "bash grep" "bash rg" ];
      options = {
        useContext = true;  # -A, -B, -C flags
        showLineNumbers = true;  # -n flag
      };
    };

    fileOperations = {
      read = {
        primary = "Read";
        avoid = [ "cat" "head" "tail" ];
      };

      edit = {
        primary = "Edit";
        avoid = [ "sed" "awk" ];
        rules = [
          "Always Read before Edit"
          "Preserve exact indentation"
          "Ensure old_string is unique"
        ];
      };

      write = {
        primary = "Write";
        avoid = [ "echo >" "cat <<EOF" ];
        rules = [
          "Read before Write for existing files"
          "Only for new files when necessary"
        ];
      };
    };

    bashUsage = {
      allowedFor = [
        "git operations"
        "npm/yarn/package managers"
        "docker/container operations"
        "test execution"
        "build processes"
        "system commands without specialized tools"
      ];

      forbidden = [
        "find (use Glob)"
        "grep/rg (use Grep)"
        "cat/head/tail (use Read)"
        "sed/awk (use Edit)"
        "echo > (use Write)"
      ];

      chainDependentCommands = true;  # Use && for sequential deps
      parallelIndependent = true;  # Multiple tool calls for independent ops
    };
  };

  # Git settings
  git = {
    safety = {
      neverUpdateConfig = true;
      neverSkipHooks = true;
      neverForcePushToMainBranches = [ "main" "master" ];
      checkAuthorshipBeforeAmend = true;
      warnOnDestructiveOps = true;
    };

    commit = {
      messageStyle = "imperative-with-why";
      includeClaudeFooter = true;
      useHeredoc = true;
      analyzeBeforeCommit = true;

      batchCommands = [
        "git status"
        "git diff"
        "git log"
      ];

      footer = ''
        🤖 Generated with [Claude Code](https://claude.com/claude-code)

        Co-Authored-By: Claude <noreply@anthropic.com>
      '';
    };

    pullRequest = {
      analyzeFullBranch = true;  # ALL commits, not just latest
      includeTestPlan = true;
      useHeredoc = true;

      batchCommands = [
        "git status"
        "git diff"
        "git diff [base]...HEAD"
        "git log"
      ];

      template = {
        sections = [ "Summary" "Test plan" ];
        footer = "🤖 Generated with [Claude Code](https://claude.com/claude-code)";
      };
    };
  };

  # UI development settings
  ui = {
    mcpTools = {
      builder = "mcp__magic__21st_magic_component_builder";
      refiner = "mcp__magic__21st_magic_component_refiner";
      inspiration = "mcp__magic__21st_magic_component_inspiration";
      logoSearch = "mcp__magic__logo_search";
    };

    workflow = {
      callMcpForSnippet = true;
      alwaysIntegrateSnippets = true;
      neverReturnSnippetOnly = true;
    };

    triggers = {
      newComponent = [ "/ui" "/21" "/21st" ];
      refineComponent = [ "/ui refine" "/21 improve" ];
      inspiration = [ "/21st fetch" ];
      logos = [ "/logo" ];
    };
  };

  # Documentation settings
  documentation = {
    neverCreateProactively = true;
    onlyWhenExplicitlyRequested = true;
    preferCodeComments = true;

    tools = {
      focused = "/document";
      comprehensive = "/index";
    };

    avoidCreating = [
      "README.md"
      "CONTRIBUTING.md"
      "*.md (unless requested)"
    ];
  };

  # Testing settings
  testing = {
    command = "/test";
    analyzeCoverage = true;
    reportQualityMetrics = true;

    onFailure = {
      readTestFile = true;
      readImplementation = true;
      useSequentialThinking = true;
      fixAndRerun = true;
    };
  };

  # Analysis settings
  analysis = {
    command = "/analyze";

    domains = [
      "quality"
      "security"
      "performance"
      "architecture"
    ];

    useSequentialThinking = true;
    provideStructuredFindings = true;
  };

  # Browser automation settings
  browser = {
    preferSnapshotOverScreenshot = true;
    alwaysGetPermission = true;
    useExactRefs = true;
    handleDialogsExplicitly = true;

    workflow = [
      "navigate"
      "snapshot"
      "interact"
      "verify"
    ];
  };

  # File system MCP settings
  fileSystemMcp = {
    enabled = true;

    tools = {
      read = "mcp__morphllm-fast-apply__read_file";
      readMultiple = "mcp__morphllm-fast-apply__read_multiple_files";
      write = "mcp__morphllm-fast-apply__write_file";
      edit = "mcp__morphllm-fast-apply__tiny_edit_file";
      list = "mcp__morphllm-fast-apply__list_directory";
      tree = "mcp__morphllm-fast-apply__directory_tree";
      search = "mcp__morphllm-fast-apply__search_files";
    };

    preferBuiltInTools = true;
    useMcpWhen = [
      "Built-in tools are restricted"
      "Batch operations needed"
      "Directory tree visualization"
      "File size information required"
    ];
  };

  # Context7 documentation settings
  context7 = {
    enabled = true;
    alwaysResolveFirst = true;

    workflow = [
      "resolve-library-id (unless user provides /org/project)"
      "get-library-docs with Context7 ID"
    ];

    tools = {
      resolve = "mcp__context7__resolve-library-id";
      getDocs = "mcp__context7__get-library-docs";
    };
  };

  # Sequential thinking settings
  sequentialThinking = {
    enabled = true;
    tool = "mcp__sequential-thinking__sequentialthinking";

    useFor = [
      "Complex multi-step analysis"
      "Debugging complex issues"
      "Architecture decisions"
      "Problem decomposition"
      "Code analysis"
      "Test failure investigation"
    ];

    features = {
      flexibleThoughtCount = true;
      allowRevisions = true;
      allowBranching = true;
      expressUncertainty = true;
      hypothesisVerification = true;
    };
  };

  # Agent thread settings
  agentThreads = {
    alwaysUseAbsolutePaths = true;
    cwdResetsBetweenBashCalls = true;
    batchIndependentOps = true;
    chainDependentOpsWithAnd = true;

    toolSelection = {
      fileSearch = "Glob";
      contentSearch = "Grep";
      readFiles = "Read";
      editFiles = "Edit";
      writeFiles = "Write";
      communication = "Direct output (not echo)";
    };
  };

  # Response formatting
  responseFormat = {
    useAbsolutePaths = true;
    includeFileNames = true;
    includeCodeSnippets = true;
    avoidEmojis = true;
    clearCommunication = true;
  };

  # Todo list settings
  todoList = {
    useForComplexTasks = true;
    minimumSteps = 3;

    taskStates = [
      "pending"
      "in_progress"
      "completed"
    ];

    rules = [
      "One task in_progress at a time"
      "Complete before starting next"
      "Remove irrelevant tasks"
      "Only mark complete when fully done"
      "Create new task for blockers"
    ];

    requireBothForms = {
      content = "Imperative form (e.g., 'Run tests')";
      activeForm = "Present continuous (e.g., 'Running tests')";
    };
  };

  # Slash command settings
  slashCommands = {
    enabled = true;

    available = {
      git = "/sc:git";
      test = "/sc:test";
      improve = "/sc:improve";
      reflect = "/sc:reflect";
      spawn = "/sc:spawn";
      build = "/sc:build";
      workflow = "/sc:workflow";
      design = "/sc:design";
      estimate = "/sc:estimate";
      load = "/sc:load";
      analyze = "/sc:analyze";
      troubleshoot = "/sc:troubleshoot";
      index = "/sc:index";
      selectTool = "/sc:select-tool";
      brainstorm = "/sc:brainstorm";
      cleanup = "/sc:cleanup";
      task = "/sc:task";
      document = "/sc:document";
      implement = "/sc:implement";
      save = "/sc:save";
      explain = "/sc:explain";
    };
  };

  # Environment awareness
  environment = {
    platform = "linux";
    workingDirectory = "/home/a/.claude";
    isGitRepo = false;
    accountForPlatformDifferences = true;
  };
}
