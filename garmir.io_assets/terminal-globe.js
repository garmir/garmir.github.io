/**
 * Terminal Globe - IP Geolocation Display
 * garmir.io - Privacy-conscious visitor location display
 */

class TerminalGlobe {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.locationData = null;
        this.initializeGlobe();
    }

    async initializeGlobe() {
        if (!this.container) {
            console.warn('Terminal globe container not found');
            return;
        }

        this.createGlobeElement();
        await this.fetchLocationData();
        this.startLocationDisplay();
    }

    createGlobeElement() {
        // Create terminal globe visual element
        const globe = document.createElement('div');
        globe.className = 'terminal-globe';
        globe.innerHTML = `
            <div class="globe-surface"></div>
            <div class="location-display"></div>
        `;

        // Add click handler for privacy-conscious display
        globe.addEventListener('click', () => this.toggleLocationDisplay());

        this.container.appendChild(globe);
        this.globeElement = globe;
        this.locationDisplay = globe.querySelector('.location-display');
    }

    async fetchLocationData() {
        try {
            // Use privacy-friendly IP geolocation with timeout
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 5000);

            const response = await fetch('https://ipapi.co/json/', {
                headers: {
                    'Accept': 'application/json'
                },
                signal: controller.signal
            });

            clearTimeout(timeoutId);

            if (!response.ok) {
                throw new Error(`Geolocation service returned ${response.status}`);
            }

            this.locationData = await response.json();

            // Validate response data
            if (!this.locationData || typeof this.locationData !== 'object') {
                throw new Error('Invalid response format');
            }

            console.log('Location data fetched successfully');

        } catch (error) {
            console.warn('Geolocation failed:', error.message);
            this.locationData = {
                city: 'Unknown',
                region: 'Unknown',
                country_name: 'Unknown',
                ip: '0.0.0.0',
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone || 'UTC',
                error: true
            };
        }
    }

    startLocationDisplay() {
        if (!this.locationData) return;

        // Create terminal-style output
        this.updateLocationDisplay();

        // Add subtle pulsing when location is available
        if (!this.locationData.error) {
            this.globeElement.classList.add('location-active');
        }
    }

    updateLocationDisplay() {
        if (!this.locationDisplay || !this.locationData) return;

        const terminalOutput = this.createTerminalOutput();
        this.locationDisplay.innerHTML = terminalOutput;
    }

    createTerminalOutput() {
        const { city, region, country_name, ip, timezone } = this.locationData;

        // Privacy-conscious display - only show general location
        const locationString = this.locationData.error
            ? 'Location: [PRIVATE]'
            : `${city}, ${region}`;

        return `
            <div class="terminal-line">
                <span class="terminal-prompt">visitor@garmir.io:~$</span>
                <span class="terminal-command">whoami --location</span>
            </div>
            <div class="terminal-line">
                <span class="terminal-output">${locationString}</span>
            </div>
            <div class="terminal-line">
                <span class="terminal-output">Timezone: ${timezone || 'UTC'}</span>
            </div>
            <div class="terminal-cursor">█</div>
        `;
    }

    toggleLocationDisplay() {
        if (!this.locationDisplay) return;

        const isVisible = this.locationDisplay.style.display !== 'none';
        this.locationDisplay.style.display = isVisible ? 'none' : 'block';

        // Add privacy notice on first display
        if (!isVisible && !this.privacyNoticeShown) {
            this.showPrivacyNotice();
            this.privacyNoticeShown = true;
        }
    }

    showPrivacyNotice() {
        const notice = document.createElement('div');
        notice.className = 'privacy-notice';
        notice.innerHTML = `
            <div class="notice-content">
                <p>📍 Location display uses IP geolocation for general area only.</p>
                <p>No personal data is stored or tracked.</p>
                <button onclick="this.parentElement.parentElement.remove()">Understood</button>
            </div>
        `;

        document.body.appendChild(notice);

        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (notice.parentNode) {
                notice.remove();
            }
        }, 5000);
    }
}

// CSS additions for terminal globe functionality
const additionalStyles = `
    .terminal-globe {
        position: relative;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .terminal-globe.location-active {
        box-shadow: 0 0 20px rgba(0, 122, 204, 0.3);
    }

    .location-display {
        position: absolute;
        top: 50px;
        left: 0;
        background: #1a1a1a;
        color: #00ff00;
        padding: 10px;
        border-radius: 4px;
        font-family: 'Courier New', monospace;
        font-size: 12px;
        min-width: 200px;
        display: none;
        z-index: 1000;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    }

    .terminal-line {
        margin: 2px 0;
    }

    .terminal-prompt {
        color: #00ff00;
        font-weight: bold;
    }

    .terminal-command {
        color: #ffffff;
        margin-left: 5px;
    }

    .terminal-output {
        color: #00aaff;
    }

    .terminal-cursor {
        color: #00ff00;
        animation: cursor-blink 1s infinite;
    }

    @keyframes cursor-blink {
        0%, 50% { opacity: 1; }
        51%, 100% { opacity: 0; }
    }

    .privacy-notice {
        position: fixed;
        top: 20px;
        right: 20px;
        background: #333;
        color: white;
        padding: 15px;
        border-radius: 8px;
        max-width: 300px;
        z-index: 2000;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }

    .notice-content p {
        margin: 5px 0;
        font-size: 14px;
    }

    .notice-content button {
        background: #007acc;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 3px;
        cursor: pointer;
        margin-top: 10px;
    }

    .notice-content button:hover {
        background: #005999;
    }
`;

// Inject additional styles
const styleSheet = document.createElement('style');
styleSheet.textContent = additionalStyles;
document.head.appendChild(styleSheet);

// Initialize on DOM ready with error boundary
document.addEventListener('DOMContentLoaded', () => {
    try {
        // Initialize terminal globe if container exists
        const globeContainer = document.getElementById('terminal-globe-container');
        if (globeContainer) {
            new TerminalGlobe('terminal-globe-container');
        }
    } catch (error) {
        console.error('Failed to initialize terminal globe:', error);
        // Graceful degradation - hide container if initialization fails
        const container = document.getElementById('terminal-globe-container');
        if (container) {
            container.style.display = 'none';
        }
    }
});

// Performance monitoring
if ('performance' in window && 'mark' in performance) {
    performance.mark('terminal-globe-script-loaded');
}

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = TerminalGlobe;
}