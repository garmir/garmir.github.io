# ASCII/TUI Design Specification for garmir.io
===============================================

## phrack.org design language analysis
--------------------------------------

### typography patterns
- monospaced fonts: courier new, monaco, 'lucida console'
- consistent rem units: 1rem base, 0.875rem small, 1.125rem headers
- all lowercase text with strategic uppercase for emphasis
- structured spacing with ascii characters

### ascii/tui elements
```
┌─────────────────────────────────────────────────────────────────┐
│ section headers with box drawing characters                     │
├─────────────────────────────────────────────────────────────────┤
│ content area with consistent spacing                            │
└─────────────────────────────────────────────────────────────────┘
```

### design principles
- function over form
- high information density
- minimal color palette (black/white/green accent)
- terminal-authentic experience
- structured, grid-like layouts
- symbolic navigation using ascii

### implementation patterns
```css
/* phrack-inspired typography */
body {
  font-family: 'courier new', monaco, 'lucida console', monospace;
  font-size: 1rem;
  line-height: 1.4;
  color: #00ff00; /* terminal green */
  background: #000000; /* terminal black */
}

/* ascii section dividers */
.section-divider::before {
  content: '├─────────────────────────────────────┤';
  display: block;
  font-family: monospace;
}
```

### text formatting rules
- all body text: lowercase
- navigation labels: lowercase
- section headers: lowercase with ascii decoration
- links: lowercase with terminal-style brackets [link]
- emphasis: uppercase sparingly for critical elements only