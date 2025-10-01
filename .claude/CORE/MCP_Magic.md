# Magic MCP Server

**Purpose**: Modern UI component generation from 21st.dev patterns with design system integration

## Triggers
- UI component requests: button, form, modal, card, table, nav
- Design system implementation needs
- `/ui` or `/21` commands
- Frontend-specific keywords: responsive, accessible, interactive
- Component enhancement or refinement requests

## Choose When
- **For UI components**: Use Magic, not native HTML/CSS generation
- **Over manual coding**: When you need production-ready, accessible components
- **For design systems**: When consistency with existing patterns matters
- **For modern frameworks**: React, Vue, Angular with current best practices
- **Not for backend**: API logic, database queries, server configuration

## Works Best With
- **Context7**: Magic uses 21st.dev patterns → Context7 provides framework integration
- **Sequential**: Sequential analyzes UI requirements → Magic implements structured components

## Nix Environment Integration

### Required Packages
Magic MCP requires a Node.js environment for 21st.dev pattern integration:

```bash
# Standard UI development environment
nix-shell -p nodejs npm

# Full frontend development stack
nix-shell -p nodejs npm yarn typescript tailwindcss

# Framework-specific environments
nix-shell -p nodejs npm react-tools  # React development
nix-shell -p nodejs npm vue-cli      # Vue development
```

### Environment Setup Patterns

**React + TypeScript + Tailwind**:
```bash
nix-shell -p nodejs npm typescript tailwindcss --run '
  npx create-react-app my-app --template typescript
  cd my-app && npm install @tailwindcss/forms @headlessui/react
'
```

**Vue 3 + Composition API**:
```bash
nix-shell -p nodejs npm vue-cli --run '
  vue create my-project --preset typescript
  cd my-project && npm install @vue/composition-api
'
```

**Next.js with Modern Stack**:
```bash
nix-shell -p nodejs npm --run '
  npx create-next-app@latest --typescript --tailwind --app
'
```

### Design System Integration

**Component Library Development**:
```bash
# Storybook + Design Tokens
nix-shell -p nodejs npm --run '
  npx create-react-app design-system
  cd design-system && npx storybook@latest init
  npm install style-dictionary @tokens-studio/sd-transforms
'
```

**Pattern Library Management**:
```bash
# 21st.dev pattern synchronization
nix-shell -p nodejs npm git --run '
  npm install @21st-dev/cli
  npx 21st sync --patterns components/**/*.tsx
'
```

### Framework Integration Examples

**Magic + Nix + React**:
```bash
# Component generation workflow
nix-shell -p nodejs npm typescript --run '
  # Magic generates component
  npx claude-code "Generate login form with Magic MCP"

  # Integrate with project
  npm install @headlessui/react @heroicons/react
  npm run type-check && npm run build
'
```

**Magic + Nix + Vue**:
```bash
# Vue 3 Composition API workflow
nix-shell -p nodejs npm vue-cli --run '
  # Magic creates Vue component
  npx claude-code "/ui responsive data table"

  # Add to Vue project
  npm install @vueuse/core @vue/composition-api
  npm run dev
'
```

### Package Management Best Practices

**Shell.nix for Project Consistency**:
```nix
# shell.nix for UI projects using Magic MCP
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_20
    npm
    typescript
    tailwindcss
    # Framework-specific additions
    nodePackages.vue-cli
    nodePackages.create-react-app
  ];

  shellHook = ''
    echo "UI Development Environment Ready"
    echo "Magic MCP: Available for component generation"
    echo "21st.dev: Pattern library integration enabled"
  '';
}
```

## Examples
```
"create a login form" → Magic (UI component generation)
"build a responsive navbar" → Magic (UI pattern with accessibility)
"add a data table with sorting" → Magic (complex UI component)
"make this component accessible" → Magic (UI enhancement)
"write a REST API" → Native Claude (backend logic)
"fix database query" → Native Claude (non-UI task)
```