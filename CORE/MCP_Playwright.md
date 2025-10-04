# Playwright MCP Server

**Purpose**: Browser automation and E2E testing with real browser interaction

## Triggers
- Browser testing and E2E test scenarios
- Visual testing, screenshot, or UI validation requests
- Form submission and user interaction testing
- Cross-browser compatibility validation
- Performance testing requiring real browser rendering
- Accessibility testing with automated WCAG compliance

## Choose When
- **For real browser interaction**: When you need actual rendering, not just code
- **Over unit tests**: For integration testing, user journeys, visual validation
- **For E2E scenarios**: Login flows, form submissions, multi-page workflows
- **For visual testing**: Screenshot comparisons, responsive design validation
- **Not for code analysis**: Static code review, syntax checking, logic validation

## Nix Environment Integration

### Required Packages
```bash
nix-shell -p nodejs chromium firefox
```

### Browser Testing Environment Setup
```bash
# Standard browser testing environment
nix-shell -p nodejs chromium firefox --run "npx playwright test"

# Headless browser testing (CI/CD)
nix-shell -p nodejs chromium --run "npx playwright test --browser=chromium"

# Multi-browser compatibility testing
nix-shell -p nodejs chromium firefox --run "npx playwright test --browser=all"
```

### E2E Testing Patterns with Nix
```bash
# Development testing with live reload
nix-shell -p nodejs chromium --run "npx playwright test --ui"

# Production-like testing environment
nix-shell -p nodejs chromium firefox xvfb-run --run "xvfb-run npx playwright test"

# Accessibility testing with specific browser
nix-shell -p nodejs chromium --run "npx playwright test --grep='accessibility'"
```

### Browser Dependencies
| Browser | Nix Package | Use Case |
|---------|-------------|----------|
| `chromium` | Primary testing, screenshots, performance | Most stable for automation |
| `firefox` | Cross-browser validation, feature testing | Different rendering engine |
| `xvfb-run` | Headless CI/CD environments | Server environments without display |

### Environment Variables
```bash
# Browser executable paths in nix
PLAYWRIGHT_BROWSERS_PATH=/nix/store/.../browsers
PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=$(which chromium)
PLAYWRIGHT_FIREFOX_EXECUTABLE_PATH=$(which firefox)
```

## Works Best With
- **Sequential**: Sequential plans test strategy → Playwright executes browser automation
- **Magic**: Magic creates UI components → Playwright validates accessibility and behavior

## Examples
```
"test the login flow" → Playwright (browser automation)
"check if form validation works" → Playwright (real user interaction)
"take screenshots of responsive design" → Playwright (visual testing)
"validate accessibility compliance" → Playwright (automated WCAG testing)
"review this function's logic" → Native Claude (static analysis)
"explain the authentication code" → Native Claude (code review)
```