# Tool Permissions and Access Control as Nix Expression
# Define what tools can do and when they require explicit user permission
{
  # File system permissions
  fileSystem = {
    read = {
      allowed = true;
      tools = [ "Read" "Glob" "Grep" ];
      mcpTools = [
        "mcp__morphllm-fast-apply__read_file"
        "mcp__morphllm-fast-apply__read_multiple_files"
        "mcp__morphllm-fast-apply__list_directory"
        "mcp__morphllm-fast-apply__directory_tree"
        "mcp__morphllm-fast-apply__get_file_info"
      ];
      restrictions = {
        assumeAccessible = true;
        noConfirmationNeeded = true;
      };
    };

    write = {
      allowed = true;
      tools = [ "Write" ];
      mcpTools = [ "mcp__morphllm-fast-apply__write_file" ];
      restrictions = {
        readBeforeWrite = true;
        onlyForNewFiles = true;
        neverOverwriteWithoutReading = true;
      };
    };

    edit = {
      allowed = true;
      tools = [ "Edit" "NotebookEdit" ];
      mcpTools = [ "mcp__morphllm-fast-apply__tiny_edit_file" ];
      restrictions = {
        readBeforeEdit = true;
        ensureUniqueOldString = true;
        preserveIndentation = true;
      };
    };

    delete = {
      allowed = false;
      requireExplicitUserRequest = true;
      tools = [ "bash rm" ];
      warnings = [
        "Confirm with user before deletion"
        "Never delete without explicit request"
      ];
    };

    move = {
      allowed = true;
      mcpTools = [ "mcp__morphllm-fast-apply__move_file" ];
      restrictions = {
        checkDestinationExists = false;
        mustBeInAllowedDirs = true;
      };
    };

    createDirectory = {
      allowed = true;
      mcpTools = [ "mcp__morphllm-fast-apply__create_directory" ];
      restrictions = {
        checkParentExists = true;
        canCreateNested = true;
      };
    };

    search = {
      allowed = true;
      tools = [ "Glob" "Grep" ];
      mcpTools = [ "mcp__morphllm-fast-apply__search_files" ];
      restrictions = {
        respectGitignore = true;
        onlyInAllowedDirs = true;
      };
    };
  };

  # Git permissions
  git = {
    read = {
      allowed = true;
      commands = [
        "git status"
        "git diff"
        "git log"
        "git show"
        "git branch"
        "git remote"
      ];
      noConfirmationNeeded = true;
    };

    write = {
      allowed = true;
      commands = [
        "git add"
        "git commit"
        "git push"
        "git pull"
        "git checkout"
        "git merge"
      ];
      restrictions = {
        neverUpdateConfig = true;
        neverSkipHooks = true;
        checkAuthorshipBeforeAmend = true;
        warnOnForcePush = true;
      };
    };

    destructive = {
      allowed = false;
      requireExplicitUserRequest = true;
      commands = [
        "git push --force"
        "git reset --hard"
        "git clean -fd"
        "git rebase -i"
      ];
      specialCases = {
        forcePushToMain = {
          allowed = false;
          warnUser = true;
        };
        amendOthersCommits = {
          allowed = false;
          checkAuthor = true;
        };
      };
    };

    github = {
      allowed = true;
      tool = "gh";
      commands = [
        "gh pr create"
        "gh pr view"
        "gh issue list"
        "gh repo view"
      ];
      useForAllGithubTasks = true;
    };
  };

  # Bash permissions
  bash = {
    allowed = true;
    tool = "Bash";

    allowedFor = [
      "git operations"
      "npm/yarn/pnpm package management"
      "docker/podman operations"
      "test execution (pytest, jest, etc.)"
      "build processes (make, cmake, etc.)"
      "system commands without specialized tools"
    ];

    forbidden = [
      "find (use Glob instead)"
      "grep/rg (use Grep instead)"
      "cat/head/tail (use Read instead)"
      "sed/awk (use Edit instead)"
      "echo > file (use Write instead)"
    ];

    restrictions = {
      quotePathsWithSpaces = true;
      chainDependentWithAnd = true;
      useAbsolutePaths = true;
      maxTimeout = 600000;  # 10 minutes in ms
      defaultTimeout = 120000;  # 2 minutes in ms
    };

    backgroundExecution = {
      allowed = true;
      neverRunSleepInBackground = true;
      monitorWithBashOutput = true;
    };
  };

  # Browser automation permissions
  browser = {
    allowed = true;
    toolPrefix = "mcp__playwright__";

    navigation = {
      allowed = true;
      tools = [
        "browser_navigate"
        "browser_navigate_back"
      ];
      noConfirmationNeeded = true;
    };

    interaction = {
      allowed = true;
      requirePermission = true;
      tools = [
        "browser_click"
        "browser_type"
        "browser_fill_form"
        "browser_select_option"
        "browser_hover"
        "browser_drag"
      ];
      restrictions = {
        useExactRef = true;
        getPermissionFirst = true;
        describeElementClearly = true;
      };
    };

    observation = {
      allowed = true;
      tools = [
        "browser_snapshot"
        "browser_take_screenshot"
        "browser_console_messages"
        "browser_network_requests"
      ];
      preferences = {
        snapshotOverScreenshot = true;
      };
    };

    management = {
      allowed = true;
      tools = [
        "browser_close"
        "browser_resize"
        "browser_tabs"
        "browser_handle_dialog"
      ];
    };

    scripting = {
      allowed = true;
      tools = [ "browser_evaluate" ];
      requirePermission = true;
    };
  };

  # UI component permissions
  uiComponents = {
    allowed = true;
    toolPrefix = "mcp__magic__";

    creation = {
      tool = "21st_magic_component_builder";
      requiresIntegration = true;
      neverReturnSnippetOnly = true;
      mustEditFiles = true;
    };

    refinement = {
      tool = "21st_magic_component_refiner";
      requiresContext = true;
      mustSpecifyFile = true;
    };

    inspiration = {
      tool = "21st_magic_component_inspiration";
      readOnly = true;
    };

    logos = {
      tool = "logo_search";
      formats = [ "JSX" "TSX" "SVG" ];
      mustIntegrateIntoProject = true;
    };
  };

  # Documentation permissions
  documentation = {
    read = {
      allowed = true;
      tools = [ "WebFetch" "WebSearch" ];

      context7 = {
        enabled = true;
        tools = [
          "mcp__context7__resolve-library-id"
          "mcp__context7__get-library-docs"
        ];
        alwaysResolveFirst = true;
      };
    };

    write = {
      allowed = false;
      requireExplicitUserRequest = true;
      neverCreateProactively = true;

      exceptions = {
        userExplicitlyRequests = true;
        slashDocumentCommand = true;
        slashIndexCommand = true;
      };

      forbidden = [
        "README.md (unless requested)"
        "CONTRIBUTING.md (unless requested)"
        "*.md (unless requested)"
      ];
    };
  };

  # Web access permissions
  web = {
    search = {
      allowed = true;
      tool = "WebSearch";
      restrictions = {
        usRegionOnly = true;
        allowDomainFiltering = true;
      };
    };

    fetch = {
      allowed = true;
      tool = "WebFetch";
      restrictions = {
        preferMcpToolsIfAvailable = true;
        autoUpgradeHttpToHttps = true;
        handleRedirects = true;
        cacheDuration = 900;  # 15 minutes in seconds
      };
    };
  };

  # Analysis and thinking permissions
  analysis = {
    sequentialThinking = {
      allowed = true;
      tool = "mcp__sequential-thinking__sequentialthinking";

      useFor = [
        "Complex multi-step problems"
        "Debugging investigations"
        "Architecture decisions"
        "Code analysis"
        "Problem decomposition"
      ];

      features = {
        flexibleThoughtCount = true;
        allowRevisions = true;
        allowBranching = true;
        hypothesisTesting = true;
      };
    };

    codeAnalysis = {
      allowed = true;
      slashCommand = "/sc:analyze";

      domains = [
        "quality"
        "security"
        "performance"
        "architecture"
      ];
    };
  };

  # Slash command permissions
  slashCommands = {
    allowed = true;
    tool = "SlashCommand";

    neverCallRecursively = true;
    checkIfAlreadyRunning = true;

    available = {
      git = { command = "/sc:git"; scope = "project"; };
      test = { command = "/sc:test"; scope = "project"; };
      improve = { command = "/sc:improve"; scope = "project"; };
      reflect = { command = "/sc:reflect"; scope = "project"; };
      spawn = { command = "/sc:spawn"; scope = "project"; };
      build = { command = "/sc:build"; scope = "project"; };
      workflow = { command = "/sc:workflow"; scope = "project"; };
      design = { command = "/sc:design"; scope = "project"; };
      estimate = { command = "/sc:estimate"; scope = "project"; };
      load = { command = "/sc:load"; scope = "project"; };
      analyze = { command = "/sc:analyze"; scope = "project"; };
      troubleshoot = { command = "/sc:troubleshoot"; scope = "project"; };
      index = { command = "/sc:index"; scope = "project"; };
      selectTool = { command = "/sc:select-tool"; scope = "project"; };
      brainstorm = { command = "/sc:brainstorm"; scope = "project"; };
      cleanup = { command = "/sc:cleanup"; scope = "project"; };
      task = { command = "/sc:task"; scope = "project"; };
      document = { command = "/sc:document"; scope = "project"; };
      implement = { command = "/sc:implement"; scope = "project"; };
      save = { command = "/sc:save"; scope = "project"; };
      explain = { command = "/sc:explain"; scope = "project"; };
    };
  };

  # Todo list permissions
  todoList = {
    allowed = true;
    tool = "TodoWrite";

    useWhen = [
      "Complex multi-step tasks (3+ steps)"
      "Non-trivial tasks requiring planning"
      "User explicitly requests todo list"
      "User provides multiple tasks"
    ];

    neverUseWhen = [
      "Single straightforward task"
      "Trivial operations"
      "Purely conversational requests"
    ];

    requirements = {
      bothForms = true;  # content AND activeForm
      validStates = [ "pending" "in_progress" "completed" ];
      oneInProgressAtATime = true;
      completeBeforeNext = true;
    };
  };

  # Jupyter notebook permissions
  jupyter = {
    allowed = true;
    tool = "NotebookEdit";

    operations = {
      replace = { allowed = true; };
      insert = { allowed = true; };
      delete = { allowed = true; };
    };

    cellTypes = [ "code" "markdown" ];

    restrictions = {
      useAbsolutePaths = true;
      specifyCellType = true;
    };
  };

  # MCP server permissions
  mcpServers = {
    sequential-thinking = {
      enabled = true;
      tools = [ "sequentialthinking" ];
      trusted = true;
    };

    magic = {
      enabled = true;
      tools = [
        "21st_magic_component_builder"
        "21st_magic_component_refiner"
        "21st_magic_component_inspiration"
        "logo_search"
      ];
      trusted = true;
    };

    context7 = {
      enabled = true;
      tools = [
        "resolve-library-id"
        "get-library-docs"
      ];
      trusted = true;
    };

    morphllm-fast-apply = {
      enabled = true;
      tools = [
        "read_file"
        "read_multiple_files"
        "write_file"
        "tiny_edit_file"
        "create_directory"
        "list_directory"
        "list_directory_with_sizes"
        "directory_tree"
        "move_file"
        "search_files"
        "get_file_info"
        "list_allowed_directories"
      ];
      trusted = true;
      restrictions = {
        onlyInAllowedDirs = true;
      };
    };

    playwright = {
      enabled = true;
      toolPrefix = "browser_";
      trusted = true;
      restrictions = {
        requirePermissionForInteraction = true;
      };
    };
  };

  # Security restrictions
  security = {
    neverCommitSecrets = true;
    secretFiles = [
      ".env"
      ".env.*"
      "credentials.json"
      "*.key"
      "*.pem"
      "*_rsa"
      "*.p12"
    ];
    warnIfCommittingSecrets = true;

    pathRestrictions = {
      alwaysUseAbsolute = true;
      neverUseRelativeInAgents = true;
    };

    commandRestrictions = {
      neverUpdateGitConfig = true;
      neverSkipHooks = true;
      neverRunInteractiveCommands = true;
      interactiveFlagsBlocked = [ "-i" "--interactive" ];
    };
  };

  # Resource limits
  limits = {
    bashTimeout = {
      default = 120000;  # 2 minutes
      max = 600000;  # 10 minutes
    };

    fileSize = {
      readLines = 2000;
      maxLineLength = 2000;
    };

    searchResults = {
      truncateAt = 30000;  # characters
    };
  };
}
