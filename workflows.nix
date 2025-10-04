# Workflow Patterns as Nix Expressions
# Define reusable workflow templates for common development tasks
{
  # Feature Implementation Workflow
  featureImplementation = {
    name = "Feature Implementation";
    description = "Complete workflow for implementing a new feature";
    version = "1.0";

    phases = {
      planning = {
        order = 1;
        steps = [
          {
            action = "Understand requirements";
            tools = [ "sequential-thinking" ];
            deliverable = "Clear understanding of feature scope";
          }
          {
            action = "Search codebase for integration points";
            tools = [ "Glob" "Grep" ];
            deliverable = "List of files to modify";
          }
          {
            action = "Read relevant files";
            tools = [ "Read" ];
            deliverable = "Understanding of current implementation";
          }
          {
            action = "Design approach";
            tools = [ "sequential-thinking" ];
            deliverable = "Implementation plan";
          }
        ];
      };

      implementation = {
        order = 2;
        steps = [
          {
            action = "Create/modify code";
            tools = [ "Edit" "Write" ];
            rules = [
              "Prefer Edit over Write"
              "Read before modifying"
              "Make minimal changes"
            ];
          }
          {
            action = "Add/update tests";
            tools = [ "Edit" "Write" ];
            deliverable = "Test coverage for new feature";
          }
        ];
      };

      verification = {
        order = 3;
        steps = [
          {
            action = "Run tests";
            tools = [ "Bash" "/sc:test" ];
            deliverable = "Passing tests";
          }
          {
            action = "Verify functionality";
            tools = [ "Bash" ];
            deliverable = "Working feature";
          }
        ];
      };

      documentation = {
        order = 4;
        condition = "If explicitly requested";
        steps = [
          {
            action = "Update docs";
            tools = [ "/sc:document" ];
            deliverable = "Feature documentation";
          }
        ];
      };

      commit = {
        order = 5;
        steps = [
          {
            action = "Stage and commit";
            tools = [ "Bash" ];
            workflow = "gitAgent.commitWorkflow";
          }
        ];
      };
    };

    checklist = [
      "Requirements understood"
      "Code implemented"
      "Tests added"
      "Tests passing"
      "Documentation updated (if requested)"
      "Changes committed"
    ];
  };

  # Bug Fix Workflow
  bugFix = {
    name = "Bug Fix";
    description = "Systematic approach to diagnosing and fixing bugs";
    version = "1.0";

    phases = {
      reproduction = {
        order = 1;
        steps = [
          {
            action = "Gather bug information";
            inputs = [
              "Error messages"
              "Stack traces"
              "Reproduction steps"
            ];
          }
          {
            action = "Reproduce issue";
            tools = [ "Bash" ];
            deliverable = "Confirmed reproduction";
          }
        ];
      };

      diagnosis = {
        order = 2;
        steps = [
          {
            action = "Search for related code";
            tools = [ "Grep" ];
            deliverable = "Candidate files";
          }
          {
            action = "Read implementations";
            tools = [ "Read" ];
            deliverable = "Understanding of code flow";
          }
          {
            action = "Analyze root cause";
            tools = [ "sequential-thinking" ];
            deliverable = "Root cause identification";
          }
        ];
      };

      fix = {
        order = 3;
        steps = [
          {
            action = "Apply minimal fix";
            tools = [ "Edit" ];
            rules = [
              "Fix root cause, not symptoms"
              "Make minimal changes"
              "Preserve existing behavior"
            ];
          }
          {
            action = "Add regression test";
            tools = [ "Edit" "Write" ];
            deliverable = "Test preventing regression";
          }
        ];
      };

      verification = {
        order = 4;
        steps = [
          {
            action = "Run tests";
            tools = [ "Bash" "/sc:test" ];
            deliverable = "All tests passing";
          }
          {
            action = "Verify fix";
            tools = [ "Bash" ];
            deliverable = "Bug resolved";
          }
        ];
      };

      commit = {
        order = 5;
        steps = [
          {
            action = "Commit fix";
            tools = [ "Bash" ];
            messagePattern = "fix: [brief description of bug fix]";
          }
        ];
      };
    };
  };

  # Refactoring Workflow
  refactoring = {
    name = "Code Refactoring";
    description = "Safe refactoring with verification";
    version = "1.0";

    phases = {
      analysis = {
        order = 1;
        steps = [
          {
            action = "Identify refactoring target";
            tools = [ "Grep" "Read" ];
            deliverable = "Target code identified";
          }
          {
            action = "Understand current behavior";
            tools = [ "Read" "sequential-thinking" ];
            deliverable = "Clear understanding of current implementation";
          }
          {
            action = "Ensure test coverage";
            tools = [ "Bash" "/sc:test" ];
            deliverable = "Baseline test coverage";
          }
        ];
      };

      planning = {
        order = 2;
        steps = [
          {
            action = "Design refactoring approach";
            tools = [ "sequential-thinking" ];
            deliverable = "Refactoring plan";
          }
          {
            action = "Identify all modification points";
            tools = [ "Grep" ];
            deliverable = "Complete list of changes needed";
          }
        ];
      };

      execution = {
        order = 3;
        steps = [
          {
            action = "Apply refactoring incrementally";
            tools = [ "Edit" ];
            rules = [
              "Make atomic changes"
              "Preserve behavior"
              "Run tests after each step"
            ];
          }
        ];
      };

      verification = {
        order = 4;
        steps = [
          {
            action = "Run full test suite";
            tools = [ "Bash" "/sc:test" ];
            deliverable = "All tests passing";
          }
          {
            action = "Verify no behavior changes";
            tools = [ "Bash" ];
            deliverable = "Same functionality";
          }
        ];
      };

      commit = {
        order = 5;
        steps = [
          {
            action = "Commit refactoring";
            tools = [ "Bash" ];
            messagePattern = "refactor: [description of what was refactored]";
          }
        ];
      };
    };
  };

  # Pull Request Workflow
  pullRequest = {
    name = "Pull Request Creation";
    description = "Creating well-documented pull requests";
    version = "1.0";

    phases = {
      branchAnalysis = {
        order = 1;
        steps = [
          {
            action = "Analyze all changes in branch";
            parallelCommands = [
              "git status"
              "git diff"
              "git diff main...HEAD"
              "git log main..HEAD"
            ];
            deliverable = "Complete understanding of branch changes";
          }
        ];
      };

      prDrafting = {
        order = 2;
        steps = [
          {
            action = "Draft PR summary";
            rules = [
              "Analyze ALL commits, not just latest"
              "Summarize in 1-3 bullet points"
              "Focus on user-facing changes"
            ];
          }
          {
            action = "Create test plan";
            deliverable = "Checklist of testing steps";
          }
        ];
      };

      prCreation = {
        order = 3;
        steps = [
          {
            action = "Push and create PR";
            parallelCommands = [
              "git push -u origin [branch]"
              "gh pr create --title '...' --body '...'"
            ];
            useHeredoc = true;
          }
        ];
      };

      completion = {
        order = 4;
        steps = [
          {
            action = "Return PR URL";
            deliverable = "PR link for user review";
          }
        ];
      };
    };

    prTemplate = ''
      ## Summary
      - Bullet point 1
      - Bullet point 2
      - Bullet point 3

      ## Test plan
      - [ ] Test case 1
      - [ ] Test case 2
      - [ ] Test case 3

      🤖 Generated with [Claude Code](https://claude.com/claude-code)
    '';
  };

  # Code Review Workflow
  codeReview = {
    name = "Code Review";
    description = "Systematic code review process";
    version = "1.0";

    phases = {
      preparation = {
        order = 1;
        steps = [
          {
            action = "Fetch PR details";
            tools = [ "Bash" ];
            command = "gh pr view [number]";
          }
          {
            action = "Get changed files";
            tools = [ "Bash" ];
            command = "gh pr diff [number]";
          }
        ];
      };

      analysis = {
        order = 2;
        aspects = {
          correctness = [
            "Logic is sound"
            "Edge cases handled"
            "No obvious bugs"
          ];

          quality = [
            "Code is readable"
            "Follows project conventions"
            "Appropriate abstractions"
            "No unnecessary complexity"
          ];

          testing = [
            "Tests cover new code"
            "Tests are meaningful"
            "Edge cases tested"
          ];

          security = [
            "No security vulnerabilities"
            "Input validation present"
            "No secrets exposed"
          ];

          performance = [
            "No obvious performance issues"
            "Appropriate algorithms"
            "Resource usage reasonable"
          ];
        };
      };

      feedback = {
        order = 3;
        steps = [
          {
            action = "Provide structured feedback";
            tools = [ "Bash" ];
            command = "gh pr review [number] --comment";
            format = {
              approvals = "What's done well";
              suggestions = "Potential improvements";
              issues = "Required changes";
            };
          }
        ];
      };
    };
  };

  # UI Component Development Workflow
  uiComponentDevelopment = {
    name = "UI Component Development";
    description = "Creating or refining UI components with 21st.dev";
    version = "1.0";

    phases = {
      creation = {
        order = 1;
        condition = "New component";
        steps = [
          {
            action = "Generate component";
            tools = [ "mcp__magic__21st_magic_component_builder" ];
            inputs = [
              "Component description"
              "Target file path"
              "Project context"
            ];
          }
          {
            action = "Read target file";
            tools = [ "Read" ];
            deliverable = "Understanding of integration point";
          }
          {
            action = "Integrate component";
            tools = [ "Edit" ];
            deliverable = "Component integrated into codebase";
          }
        ];
      };

      refinement = {
        order = 1;
        condition = "Existing component";
        steps = [
          {
            action = "Read current implementation";
            tools = [ "Read" ];
            deliverable = "Current component code";
          }
          {
            action = "Refine component";
            tools = [ "mcp__magic__21st_magic_component_refiner" ];
            inputs = [
              "Improvement context"
              "File path"
            ];
          }
          {
            action = "Apply refinements";
            tools = [ "Edit" ];
            deliverable = "Improved component";
          }
        ];
      };

      styling = {
        order = 2;
        steps = [
          {
            action = "Apply styling";
            considerations = [
              "Project design system"
              "Responsive design"
              "Accessibility"
            ];
          }
        ];
      };

      verification = {
        order = 3;
        steps = [
          {
            action = "Visual verification";
            tools = [ "Bash" ];
            command = "npm run dev";
          }
          {
            action = "Test component";
            tools = [ "Bash" ];
            deliverable = "Component tests passing";
          }
        ];
      };
    };

    rules = [
      "Never return raw snippet without integration"
      "Always edit files to add components"
      "Respect existing code structure"
      "Follow project conventions"
    ];
  };

  # Documentation Workflow
  documentation = {
    name = "Documentation";
    description = "Creating focused or comprehensive documentation";
    version = "1.0";

    phases = {
      libraryDocs = {
        order = 1;
        condition = "Fetching external library docs";
        steps = [
          {
            action = "Resolve library ID";
            tools = [ "mcp__context7__resolve-library-id" ];
            input = "Library name";
            output = "Context7-compatible ID";
          }
          {
            action = "Fetch documentation";
            tools = [ "mcp__context7__get-library-docs" ];
            inputs = [
              "Library ID"
              "Optional topic filter"
            ];
            output = "Up-to-date documentation";
          }
        ];
      };

      focusedDocs = {
        order = 1;
        condition = "Documenting specific code";
        steps = [
          {
            action = "Identify documentation target";
            tools = [ "Grep" "Read" ];
            deliverable = "Code to document";
          }
          {
            action = "Generate documentation";
            tools = [ "/sc:document" ];
            deliverable = "Focused documentation";
          }
        ];
      };

      comprehensiveDocs = {
        order = 1;
        condition = "Creating project documentation";
        steps = [
          {
            action = "Analyze project structure";
            tools = [ "Glob" "Grep" "Read" ];
            deliverable = "Project understanding";
          }
          {
            action = "Generate comprehensive docs";
            tools = [ "/sc:index" ];
            deliverable = "Full project documentation";
          }
        ];
      };
    };

    rules = [
      "Never create docs proactively"
      "Only when explicitly requested"
      "Prefer code comments when appropriate"
      "Use Context7 for up-to-date library docs"
    ];
  };

  # Testing Workflow
  testing = {
    name = "Test Development and Execution";
    description = "Comprehensive testing workflow";
    version = "1.0";

    phases = {
      testCreation = {
        order = 1;
        condition = "Creating new tests";
        steps = [
          {
            action = "Identify test scenarios";
            tools = [ "Read" "sequential-thinking" ];
            deliverable = "Test plan";
          }
          {
            action = "Write tests";
            tools = [ "Edit" "Write" ];
            deliverable = "Test implementation";
          }
        ];
      };

      testExecution = {
        order = 2;
        steps = [
          {
            action = "Run test suite";
            tools = [ "Bash" "/sc:test" ];
            deliverable = "Test results";
          }
          {
            action = "Analyze coverage";
            deliverable = "Coverage report and gaps";
          }
        ];
      };

      debugging = {
        order = 3;
        condition = "Tests failing";
        steps = [
          {
            action = "Read test expectations";
            tools = [ "Read" ];
            deliverable = "Understanding of test intent";
          }
          {
            action = "Read implementation";
            tools = [ "Read" ];
            deliverable = "Understanding of actual behavior";
          }
          {
            action = "Diagnose failure";
            tools = [ "sequential-thinking" ];
            deliverable = "Root cause";
          }
          {
            action = "Fix and re-run";
            tools = [ "Edit" "Bash" ];
            deliverable = "Passing tests";
          }
        ];
      };

      reporting = {
        order = 4;
        steps = [
          {
            action = "Generate test report";
            include = [
              "Pass/fail status"
              "Coverage percentage"
              "Coverage gaps"
              "Recommendations"
            ];
          }
        ];
      };
    };
  };

  # Debugging Workflow
  debugging = {
    name = "Systematic Debugging";
    description = "Step-by-step debugging process";
    version = "1.0";

    phases = {
      informationGathering = {
        order = 1;
        steps = [
          {
            action = "Collect error information";
            gather = [
              "Error messages"
              "Stack traces"
              "Reproduction steps"
              "Environment details"
            ];
          }
        ];
      };

      reproduction = {
        order = 2;
        steps = [
          {
            action = "Reproduce issue";
            tools = [ "Bash" ];
            deliverable = "Consistent reproduction";
          }
          {
            action = "Create minimal reproduction";
            deliverable = "Simplest case that triggers bug";
          }
        ];
      };

      investigation = {
        order = 3;
        steps = [
          {
            action = "Search related code";
            tools = [ "Grep" ];
            deliverable = "Candidate files";
          }
          {
            action = "Read implementations";
            tools = [ "Read" ];
            deliverable = "Code understanding";
          }
          {
            action = "Analyze with sequential thinking";
            tools = [ "sequential-thinking" ];
            deliverable = "Hypothesis about cause";
          }
        ];
      };

      verification = {
        order = 4;
        steps = [
          {
            action = "Test hypothesis";
            techniques = [
              "Add logging"
              "Modify state"
              "Test edge cases"
            ];
          }
          {
            action = "Confirm root cause";
            deliverable = "Verified root cause";
          }
        ];
      };

      resolution = {
        order = 5;
        steps = [
          {
            action = "Apply fix";
            tools = [ "Edit" ];
            deliverable = "Bug fix";
          }
          {
            action = "Add regression test";
            tools = [ "Edit" ];
            deliverable = "Test preventing recurrence";
          }
          {
            action = "Verify fix";
            tools = [ "Bash" ];
            deliverable = "Issue resolved";
          }
        ];
      };
    };

    techniques = [
      "Binary search to isolate"
      "Add debug logging"
      "Check recent changes (git log)"
      "Verify dependencies"
      "Test in isolation"
      "Use sequential-thinking for complex issues"
    ];
  };

  # Browser Automation Workflow
  browserAutomation = {
    name = "Browser Automation";
    description = "Web interaction and testing with Playwright";
    version = "1.0";

    phases = {
      setup = {
        order = 1;
        steps = [
          {
            action = "Ensure browser installed";
            tools = [ "mcp__playwright__browser_install" ];
          }
          {
            action = "Navigate to target";
            tools = [ "mcp__playwright__browser_navigate" ];
            input = "URL";
          }
        ];
      };

      interaction = {
        order = 2;
        steps = [
          {
            action = "Capture page state";
            tools = [ "mcp__playwright__browser_snapshot" ];
            deliverable = "Accessibility tree";
          }
          {
            action = "Interact with elements";
            tools = [
              "mcp__playwright__browser_click"
              "mcp__playwright__browser_type"
              "mcp__playwright__browser_fill_form"
            ];
            rules = [
              "Use exact ref from snapshot"
              "Get permission for interactions"
              "Describe element clearly"
            ];
          }
        ];
      };

      verification = {
        order = 3;
        steps = [
          {
            action = "Verify state";
            tools = [ "mcp__playwright__browser_snapshot" ];
            deliverable = "Confirmed state change";
          }
          {
            action = "Check console";
            tools = [ "mcp__playwright__browser_console_messages" ];
            deliverable = "No errors";
          }
          {
            action = "Monitor network";
            tools = [ "mcp__playwright__browser_network_requests" ];
            deliverable = "Expected API calls";
          }
        ];
      };

      capture = {
        order = 4;
        condition = "If visual verification needed";
        steps = [
          {
            action = "Take screenshot";
            tools = [ "mcp__playwright__browser_take_screenshot" ];
            deliverable = "Visual proof";
          }
        ];
      };
    };
  };

  # Code Analysis Workflow
  codeAnalysis = {
    name = "Comprehensive Code Analysis";
    description = "Multi-domain code analysis";
    version = "1.0";

    phases = {
      discovery = {
        order = 1;
        steps = [
          {
            action = "Identify analysis scope";
            tools = [ "Glob" ];
            deliverable = "List of files to analyze";
          }
        ];
      };

      qualityAnalysis = {
        order = 2;
        steps = [
          {
            action = "Analyze code quality";
            tools = [ "Read" "sequential-thinking" ];
            focus = [
              "Complexity"
              "Maintainability"
              "Code duplication"
              "Test coverage"
            ];
          }
        ];
      };

      securityAnalysis = {
        order = 3;
        steps = [
          {
            action = "Analyze security";
            tools = [ "Grep" "Read" "sequential-thinking" ];
            focus = [
              "Input validation"
              "Authentication/authorization"
              "Secrets exposure"
              "Dependencies"
            ];
          }
        ];
      };

      performanceAnalysis = {
        order = 4;
        steps = [
          {
            action = "Analyze performance";
            tools = [ "Read" "sequential-thinking" ];
            focus = [
              "Algorithmic complexity"
              "Resource usage"
              "Caching"
              "Database queries"
            ];
          }
        ];
      };

      architectureAnalysis = {
        order = 5;
        steps = [
          {
            action = "Analyze architecture";
            tools = [ "Read" "sequential-thinking" ];
            focus = [
              "Design patterns"
              "Coupling/cohesion"
              "Scalability"
              "Technical debt"
            ];
          }
        ];
      };

      reporting = {
        order = 6;
        steps = [
          {
            action = "Generate comprehensive report";
            structure = {
              findings = "By domain and severity";
              recommendations = "Prioritized action items";
              metrics = "Quantitative measures";
            };
          }
        ];
      };
    };
  };

  # Meta information about workflows
  meta = {
    version = "1.0";
    workflowCount = 11;

    workflowsByCategory = {
      development = [
        "featureImplementation"
        "bugFix"
        "refactoring"
      ];

      versionControl = [
        "pullRequest"
        "codeReview"
      ];

      userInterface = [
        "uiComponentDevelopment"
      ];

      quality = [
        "testing"
        "debugging"
        "codeAnalysis"
      ];

      documentation = [
        "documentation"
      ];

      automation = [
        "browserAutomation"
      ];
    };

    commonPatterns = {
      phaseStructure = "All workflows use ordered phases";
      toolSelection = "Specific tools for each step";
      deliverables = "Clear outputs for each phase";
      rules = "Explicit constraints and best practices";
      conditions = "Conditional execution based on context";
    };
  };
}
