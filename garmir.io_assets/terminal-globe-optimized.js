/**
 * Terminal Globe - Optimized with SuperClaude Framework Patterns
 * garmir.io - High-performance geolocation display
 *
 * Framework Optimizations:
 * - Parallel resource loading
 * - Non-blocking API calls
 * - Lazy loading with graceful degradation
 * - Performance monitoring integration
 */

class OptimizedTerminalGlobe {
    constructor(containerId, options = {}) {
        this.container = document.getElementById(containerId);
        this.options = {
            timeout: 3000,
            fallbackEnabled: true,
            privacyMode: true,
            performanceMonitoring: true,
            ...options
        };

        this.locationData = null;
        this.loadStartTime = performance.now();
        this.privacyNoticeShown = false;

        if (this.container) {
            this.initializeGlobe();
        } else {
            console.warn('[TerminalGlobe] Container not found:', containerId);
        }
    }

    async initializeGlobe() {
        // SuperClaude Framework: Parallel execution pattern
        const initTasks = [
            this.createGlobeElement(),
            this.loadLocationDataAsync()
        ];

        try {
            await Promise.allSettled(initTasks);
            this.finalizeInitialization();
        } catch (error) {
            console.warn('[TerminalGlobe] Initialization failed:', error);
            this.showFallbackDisplay();
        }
    }

    createGlobeElement() {
        // Immediate UI creation - no blocking
        const globe = document.createElement('div');
        globe.className = 'terminal-globe';
        globe.setAttribute('role', 'button');
        globe.setAttribute('tabindex', '0');
        globe.setAttribute('aria-label', 'Terminal globe - click to show location information');

        globe.innerHTML = `
            <div class="globe-surface" aria-hidden="true"></div>
            <div class="location-display" role="region" aria-label="Location information"></div>
        `;

        // Event handlers with accessibility support
        const toggleHandler = () => this.toggleLocationDisplay();
        globe.addEventListener('click', toggleHandler);
        globe.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                toggleHandler();
            }
        });

        this.container.appendChild(globe);
        this.globeElement = globe;
        this.locationDisplay = globe.querySelector('.location-display');

        return Promise.resolve();
    }

    async loadLocationDataAsync() {
        // SuperClaude Framework: Non-blocking external dependency
        if (!navigator.onLine) {
            this.locationData = this.createFallbackData('offline');
            return;
        }

        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), this.options.timeout);

        try {
            const startTime = performance.now();

            // Parallel DNS prefetch should already be done via HTML hints
            const response = await fetch('https://ipapi.co/json/', {
                signal: controller.signal,
                headers: {
                    'Accept': 'application/json',
                    'User-Agent': 'garmir.io-terminal-globe/1.0'
                }
            });

            clearTimeout(timeoutId);

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            this.locationData = await response.json();

            // Performance monitoring
            if (this.options.performanceMonitoring) {
                const loadTime = performance.now() - startTime;
                console.debug(`[TerminalGlobe] API response time: ${loadTime.toFixed(2)}ms`);
            }

        } catch (error) {
            clearTimeout(timeoutId);
            console.debug('[TerminalGlobe] API fallback:', error.message);
            this.locationData = this.createFallbackData('api_error');
        }
    }

    createFallbackData(reason) {
        return {
            city: 'Unknown',
            region: 'Unknown',
            country_name: 'Unknown',
            ip: '0.0.0.0',
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone || 'UTC',
            fallback: true,
            fallback_reason: reason
        };
    }

    finalizeInitialization() {
        if (!this.locationData || !this.locationDisplay) return;

        this.updateLocationDisplay();

        // Visual enhancement when data is available
        if (!this.locationData.fallback) {
            this.globeElement.classList.add('location-active');
        }

        // Total initialization performance
        if (this.options.performanceMonitoring) {
            const totalTime = performance.now() - this.loadStartTime;
            console.debug(`[TerminalGlobe] Total initialization: ${totalTime.toFixed(2)}ms`);
        }
    }

    updateLocationDisplay() {
        if (!this.locationDisplay || !this.locationData) return;

        const terminalOutput = this.createTerminalOutput();
        this.locationDisplay.innerHTML = terminalOutput;
    }

    createTerminalOutput() {
        const { city, region, country_name, timezone, fallback, fallback_reason } = this.locationData;

        // Privacy-conscious display
        const locationString = fallback
            ? `Location: [${fallback_reason?.toUpperCase() || 'PRIVATE'}]`
            : this.options.privacyMode
                ? `${city}, ${region}`
                : `${city}, ${region}, ${country_name}`;

        const timestampString = new Date().toLocaleTimeString();

        return `
            <div class="terminal-line">
                <span class="terminal-prompt">visitor@garmir.io:~$</span>
                <span class="terminal-command">whoami --location</span>
            </div>
            <div class="terminal-line">
                <span class="terminal-output">${locationString}</span>
            </div>
            <div class="terminal-line">
                <span class="terminal-output">Timezone: ${timezone}</span>
            </div>
            <div class="terminal-line">
                <span class="terminal-output">Time: ${timestampString}</span>
            </div>
            ${fallback ? '<div class="terminal-line"><span class="terminal-warning">⚠ Using fallback data</span></div>' : ''}
            <div class="terminal-cursor" aria-hidden="true">█</div>
        `;
    }

    toggleLocationDisplay() {
        if (!this.locationDisplay) return;

        const isVisible = this.locationDisplay.style.display !== 'none';
        this.locationDisplay.style.display = isVisible ? 'none' : 'block';

        // Update ARIA attributes
        this.globeElement.setAttribute('aria-expanded', (!isVisible).toString());

        // Privacy notice on first display
        if (!isVisible && !this.privacyNoticeShown) {
            this.showPrivacyNotice();
            this.privacyNoticeShown = true;
        }
    }

    showPrivacyNotice() {
        const notice = document.createElement('div');
        notice.className = 'privacy-notice';
        notice.setAttribute('role', 'alert');
        notice.setAttribute('aria-live', 'polite');

        notice.innerHTML = `
            <div class="notice-content">
                <p>📍 Location display uses IP geolocation for general area only.</p>
                <p>No personal data is stored or tracked.</p>
                <button type="button" aria-label="Dismiss privacy notice">Understood</button>
            </div>
        `;

        const dismissButton = notice.querySelector('button');
        dismissButton.addEventListener('click', () => {
            notice.remove();
        });

        document.body.appendChild(notice);

        // Auto-remove after 8 seconds
        setTimeout(() => {
            if (notice.parentNode) {
                notice.remove();
            }
        }, 8000);
    }

    showFallbackDisplay() {
        if (!this.container) return;

        this.container.innerHTML = `
            <div class="terminal-globe fallback">
                <div class="globe-surface"></div>
                <p class="fallback-message">Globe temporarily unavailable</p>
            </div>
        `;
    }
}

// Enhanced CSS with SuperClaude Framework optimizations
const optimizedStyles = `
    /* SuperClaude Framework: Performance-optimized styles */
    .terminal-globe {
        width: 40px;
        height: 40px;
        display: inline-block;
        background: linear-gradient(45deg, #007acc, #0066aa);
        border-radius: 50%;
        position: relative;
        cursor: pointer;
        transition: all 0.2s ease;
        /* GPU acceleration */
        transform: translateZ(0);
        will-change: transform;
    }

    .terminal-globe:hover,
    .terminal-globe:focus {
        transform: scale(1.05) translateZ(0);
        box-shadow: 0 0 15px rgba(0, 122, 204, 0.4);
        outline: none;
    }

    .terminal-globe.location-active {
        animation: globe-pulse 2s ease-in-out infinite;
        box-shadow: 0 0 20px rgba(0, 122, 204, 0.3);
    }

    .terminal-globe.fallback {
        background: linear-gradient(45deg, #666, #999);
        cursor: default;
    }

    .terminal-globe::before {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 20px;
        height: 20px;
        background: repeating-linear-gradient(
            0deg,
            transparent,
            transparent 2px,
            rgba(255, 255, 255, 0.3) 2px,
            rgba(255, 255, 255, 0.3) 4px
        );
        border-radius: 50%;
        animation: globe-rotate 4s linear infinite;
    }

    .location-display {
        position: absolute;
        top: 50px;
        left: 0;
        background: #1a1a1a;
        color: #00ff00;
        padding: 12px;
        border-radius: 6px;
        font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Fira Code', 'Droid Sans Mono', 'Source Code Pro', monospace;
        font-size: 13px;
        min-width: 220px;
        max-width: 300px;
        display: none;
        z-index: 1000;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(0, 255, 0, 0.2);
    }

    .terminal-line {
        margin: 3px 0;
        word-wrap: break-word;
    }

    .terminal-prompt {
        color: #00ff00;
        font-weight: 600;
    }

    .terminal-command {
        color: #ffffff;
        margin-left: 5px;
    }

    .terminal-output {
        color: #00aaff;
    }

    .terminal-warning {
        color: #ffaa00;
    }

    .terminal-cursor {
        color: #00ff00;
        animation: cursor-blink 1.2s infinite;
    }

    .fallback-message {
        position: absolute;
        top: 50px;
        left: 0;
        font-size: 12px;
        color: #666;
        white-space: nowrap;
    }

    .privacy-notice {
        position: fixed;
        top: 20px;
        right: 20px;
        background: #333;
        color: white;
        padding: 16px;
        border-radius: 8px;
        max-width: 320px;
        z-index: 2000;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
        border: 1px solid #555;
    }

    .notice-content p {
        margin: 6px 0;
        font-size: 14px;
        line-height: 1.4;
    }

    .notice-content button {
        background: #007acc;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
        cursor: pointer;
        margin-top: 12px;
        font-size: 13px;
        transition: background 0.2s ease;
    }

    .notice-content button:hover {
        background: #005999;
    }

    .notice-content button:focus {
        outline: 2px solid #00aaff;
        outline-offset: 1px;
    }

    /* Animations */
    @keyframes globe-pulse {
        0%, 100% {
            transform: scale(1) translateZ(0);
            opacity: 0.9;
        }
        50% {
            transform: scale(1.08) translateZ(0);
            opacity: 1;
        }
    }

    @keyframes globe-rotate {
        from { transform: translate(-50%, -50%) rotate(0deg); }
        to { transform: translate(-50%, -50%) rotate(360deg); }
    }

    @keyframes cursor-blink {
        0%, 60% { opacity: 1; }
        61%, 100% { opacity: 0; }
    }

    /* Performance optimizations */
    @media (prefers-reduced-motion: reduce) {
        .terminal-globe,
        .terminal-globe::before,
        .terminal-cursor {
            animation: none !important;
        }

        .terminal-globe {
            transition: none !important;
        }
    }

    /* Mobile responsiveness */
    @media (max-width: 480px) {
        .location-display {
            left: -100px;
            min-width: 200px;
            font-size: 12px;
        }

        .privacy-notice {
            left: 10px;
            right: 10px;
            max-width: none;
        }
    }
`;

// Optimized style injection with error handling
function injectOptimizedStyles() {
    try {
        const existingStyle = document.getElementById('terminal-globe-styles');
        if (existingStyle) {
            existingStyle.remove();
        }

        const styleSheet = document.createElement('style');
        styleSheet.id = 'terminal-globe-styles';
        styleSheet.textContent = optimizedStyles;

        // Insert before any existing styles to allow overriding
        const firstStyle = document.querySelector('style, link[rel="stylesheet"]');
        if (firstStyle) {
            firstStyle.parentNode.insertBefore(styleSheet, firstStyle);
        } else {
            document.head.appendChild(styleSheet);
        }
    } catch (error) {
        console.warn('[TerminalGlobe] Style injection failed:', error);
    }
}

// SuperClaude Framework: Parallel initialization
function initializeTerminalGlobe() {
    injectOptimizedStyles();

    const globeContainer = document.getElementById('terminal-globe-container');
    if (globeContainer) {
        return new OptimizedTerminalGlobe('terminal-globe-container', {
            performanceMonitoring: true,
            privacyMode: true
        });
    }

    return null;
}

// Initialize based on document state
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeTerminalGlobe);
} else {
    // Document already loaded, initialize immediately
    if (typeof requestIdleCallback === 'function') {
        requestIdleCallback(initializeTerminalGlobe);
    } else {
        setTimeout(initializeTerminalGlobe, 0);
    }
}

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = OptimizedTerminalGlobe;
}

// Export for browser global usage
if (typeof window !== 'undefined') {
    window.OptimizedTerminalGlobe = OptimizedTerminalGlobe;
}