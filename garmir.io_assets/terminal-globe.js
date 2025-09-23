// Terminal-style ASCII Globe with IP Geolocation
// Simple, reliable implementation without external dependencies

class TerminalGlobe {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.userLocation = null;
    this.animationFrame = 0;

    if (this.container) {
      this.init();
    }
  }

  async init() {
    // Get visitor location first
    await this.getVisitorLocation();

    // Create terminal-style globe
    this.createTerminalGlobe();

    // Start rotation animation
    this.animate();
  }

  async getVisitorLocation() {
    try {
      // Use ipapi.co as primary service (no CORS issues)
      const response = await fetch('https://ipapi.co/json/');
      const data = await response.json();

      if (data.latitude && data.longitude) {
        this.userLocation = {
          lat: parseFloat(data.latitude),
          lon: parseFloat(data.longitude),
          city: data.city || 'Unknown',
          country: data.country_name || 'Unknown',
          ip: data.ip || 'Unknown'
        };
        console.log('Terminal Globe: Visitor location detected', this.userLocation);
      }
    } catch (error) {
      console.log('Terminal Globe: Using fallback mode');
    }
  }

  createTerminalGlobe() {
    // Clear container
    this.container.innerHTML = '';

    // Create ASCII art globe container
    const globeDiv = document.createElement('div');
    globeDiv.className = 'terminal-globe';
    globeDiv.style.cssText = `
      font-family: JetBrains Mono, monospace;
      font-size: 8px;
      line-height: 1;
      color: #bbbbbb;
      text-align: center;
      white-space: pre;
      margin: 20px auto;
      width: 200px;
      height: 140px;
      overflow: hidden;
    `;

    // Generate ASCII globe frames for rotation
    this.globeFrames = this.generateGlobeFrames();

    // Set initial frame
    globeDiv.textContent = this.globeFrames[0];
    this.container.appendChild(globeDiv);

    // Add location info if available
    if (this.userLocation) {
      this.addLocationInfo();
    } else {
      this.addDefaultInfo();
    }
  }

  generateGlobeFrames() {
    // ASCII art globe with different rotation phases
    const frames = [
      `        .-""""""-.
      .'          '.
     /   O      o   \\
    :           ★     :
    |                |
    :    \\     /    :
     \\    '..'    /
      '.          .'
        '-......-'`,

      `        .-""""""-.
      .'          '.
     /   o      O   \\
    :     ★          :
    |                |
    :    \\     /    :
     \\    '..'    /
      '.          .'
        '-......-'`,

      `        .-""""""-.
      .'          '.
     /              \\
    :   ★      o     :
    |                |
    :    \\  O  /    :
     \\    '..'    /
      '.          .'
        '-......-'`,

      `        .-""""""-.
      .'          '.
     /              \\
    :        ★       :
    |     O          |
    :    \\  o  /    :
     \\    '..'    /
      '.          .'
        '-......-'`
    ];

    return frames;
  }

  addLocationInfo() {
    const infoDiv = document.createElement('div');
    infoDiv.className = 'location-info';
    infoDiv.style.cssText = `
      margin-top: 15px;
      font-size: 12px;
      color: #00ff00;
      text-align: center;
      font-family: JetBrains Mono, monospace;
      line-height: 1.4;
    `;

    infoDiv.innerHTML = `
      <div>► visitor located</div>
      <div>${this.userLocation.city}, ${this.userLocation.country}</div>
      <div>[${this.userLocation.lat.toFixed(2)}, ${this.userLocation.lon.toFixed(2)}]</div>
      <div style="color: #666; font-size: 10px; margin-top: 5px;">ip: ${this.userLocation.ip}</div>
    `;

    this.container.appendChild(infoDiv);
  }

  addDefaultInfo() {
    const infoDiv = document.createElement('div');
    infoDiv.className = 'location-info';
    infoDiv.style.cssText = `
      margin-top: 15px;
      font-size: 12px;
      color: #bbbbbb;
      text-align: center;
      font-family: JetBrains Mono, monospace;
    `;

    infoDiv.innerHTML = `<div>► geographic visualization</div>`;
    this.container.appendChild(infoDiv);
  }

  animate() {
    if (!this.container) return;

    const globeElement = this.container.querySelector('.terminal-globe');
    if (globeElement && this.globeFrames) {
      // Rotate through ASCII frames every 1.5 seconds
      const frameIndex = Math.floor(Date.now() / 1500) % this.globeFrames.length;
      globeElement.textContent = this.globeFrames[frameIndex];
    }

    // Continue animation
    setTimeout(() => this.animate(), 100);
  }
}

// Initialize terminal globe when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  const globeContainer = document.getElementById('interactive-globe');
  if (globeContainer) {
    // Remove any existing content
    globeContainer.innerHTML = '';

    // Initialize terminal globe
    new TerminalGlobe('interactive-globe');
  }
});

// CSS enhancement for globe container
const style = document.createElement('style');
style.textContent = `
  .globe-container {
    background-color: #000000;
    border: 1px dotted #bbbbbb;
    padding: 20px;
    border-radius: 4px;
  }

  .terminal-globe {
    user-select: none;
    cursor: pointer;
  }

  .terminal-globe:hover {
    color: #00ff00;
  }

  .location-info {
    animation: fadeIn 0.5s ease-in;
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
`;
document.head.appendChild(style);