// Enhanced Interactive Globe with Visitor IP Geolocation
// Shows visitor's location on rotating 3D globe with terminal aesthetic

class GeoLocationGlobe {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.scene = null;
    this.camera = null;
    this.renderer = null;
    this.globe = null;
    this.locationMarker = null;
    this.animationId = null;
    this.userLocation = null;

    this.init();
  }

  async init() {
    if (!this.container) return;

    // Get visitor's location first
    await this.getVisitorLocation();

    // Scene setup
    this.scene = new THREE.Scene();
    this.scene.background = new THREE.Color(0x000000);

    // Camera setup
    this.camera = new THREE.PerspectiveCamera(
      75,
      this.container.offsetWidth / this.container.offsetHeight,
      0.1,
      1000
    );
    this.camera.position.z = 2.5;

    // Renderer setup
    this.renderer = new THREE.WebGLRenderer({
      alpha: true,
      antialias: true
    });
    this.renderer.setSize(this.container.offsetWidth, this.container.offsetHeight);
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    this.container.appendChild(this.renderer.domElement);

    // Create globe
    this.createGlobe();

    // Add visitor location if available
    if (this.userLocation) {
      this.addLocationMarker();
      this.displayLocationInfo();
    }

    // Start animation
    this.animate();

    // Handle resize
    window.addEventListener('resize', () => this.onWindowResize());
  }

  async getVisitorLocation() {
    try {
      // Use multiple free IP geolocation services for reliability
      const services = [
        'https://ipapi.co/json/',
        'https://ip-api.com/json/',
        'https://freegeoip.app/json/'
      ];

      for (const service of services) {
        try {
          const response = await fetch(service);
          const data = await response.json();

          if (data.latitude && data.longitude) {
            this.userLocation = {
              lat: parseFloat(data.latitude),
              lon: parseFloat(data.longitude),
              city: data.city || data.region_name || 'Unknown',
              country: data.country || data.country_name || 'Unknown',
              ip: data.ip || 'Unknown'
            };
            console.log('Visitor location detected:', this.userLocation);
            break;
          }
        } catch (error) {
          console.log(`Service ${service} failed, trying next...`);
          continue;
        }
      }
    } catch (error) {
      console.log('Geolocation detection failed, showing globe without location');
    }
  }

  createGlobe() {
    // Globe geometry
    const geometry = new THREE.SphereGeometry(1, 32, 32);

    // Terminal-style wireframe material
    const material = new THREE.MeshBasicMaterial({
      color: 0xbbbbbb,
      wireframe: true,
      transparent: true,
      opacity: 0.6
    });

    this.globe = new THREE.Mesh(geometry, material);
    this.scene.add(this.globe);

    // Add continental outlines for geographic reference
    this.addContinentalMarkers();
  }

  addContinentalMarkers() {
    // Add points for major cities/regions as reference
    const majorCities = [
      { lat: 40.7128, lon: -74.0060 }, // NYC
      { lat: 51.5074, lon: -0.1278 },  // London
      { lat: 35.6762, lon: 139.6503 }, // Tokyo
      { lat: -33.8688, lon: 151.2093 }, // Sydney
      { lat: 55.7558, lon: 37.6173 },  // Moscow
      { lat: 19.4326, lon: -99.1332 }  // Mexico City
    ];

    majorCities.forEach(city => {
      const pos = this.latLonToVector3(city.lat, city.lon);
      const geometry = new THREE.SphereGeometry(0.02, 8, 8);
      const material = new THREE.MeshBasicMaterial({
        color: 0x666666,
        transparent: true,
        opacity: 0.4
      });
      const marker = new THREE.Mesh(geometry, material);
      marker.position.copy(pos);
      this.scene.add(marker);
    });
  }

  addLocationMarker() {
    if (!this.userLocation) return;

    const pos = this.latLonToVector3(this.userLocation.lat, this.userLocation.lon);

    // Create pulsing marker for visitor location
    const geometry = new THREE.SphereGeometry(0.05, 16, 16);
    const material = new THREE.MeshBasicMaterial({
      color: 0x00ff00,
      transparent: true,
      opacity: 0.8
    });

    this.locationMarker = new THREE.Mesh(geometry, material);
    this.locationMarker.position.copy(pos);
    this.scene.add(this.locationMarker);

    // Add connection line from center to location
    const lineGeometry = new THREE.BufferGeometry();
    lineGeometry.setFromPoints([
      new THREE.Vector3(0, 0, 0),
      pos
    ]);
    const lineMaterial = new THREE.LineBasicMaterial({
      color: 0x00ff00,
      transparent: true,
      opacity: 0.3
    });
    const line = new THREE.Line(lineGeometry, lineMaterial);
    this.scene.add(line);
  }

  latLonToVector3(lat, lon) {
    // Convert latitude/longitude to 3D coordinates on sphere
    const phi = (90 - lat) * (Math.PI / 180);
    const theta = (lon + 180) * (Math.PI / 180);

    const x = Math.sin(phi) * Math.cos(theta);
    const y = Math.cos(phi);
    const z = Math.sin(phi) * Math.sin(theta);

    return new THREE.Vector3(x, y, z);
  }

  displayLocationInfo() {
    if (!this.userLocation) return;

    // Create info display below globe
    const infoDiv = document.createElement('div');
    infoDiv.className = 'location-info';
    infoDiv.style.cssText = `
      margin-top: 10px;
      font-size: 12px;
      color: #bbbbbb;
      text-align: center;
      font-family: JetBrains Mono, monospace;
    `;
    infoDiv.innerHTML = `
      <div>visitor: ${this.userLocation.city}, ${this.userLocation.country}</div>
      <div>coordinates: ${this.userLocation.lat.toFixed(2)}, ${this.userLocation.lon.toFixed(2)}</div>
    `;
    this.container.appendChild(infoDiv);
  }

  animate() {
    this.animationId = requestAnimationFrame(() => this.animate());

    if (this.globe) {
      // Rotate globe slowly
      this.globe.rotation.y += 0.005;
    }

    // Pulse the location marker
    if (this.locationMarker) {
      const time = Date.now() * 0.002;
      this.locationMarker.material.opacity = 0.5 + 0.3 * Math.sin(time);
    }

    this.renderer.render(this.scene, this.camera);
  }

  onWindowResize() {
    if (!this.container) return;

    this.camera.aspect = this.container.offsetWidth / this.container.offsetHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(this.container.offsetWidth, this.container.offsetHeight);
  }

  destroy() {
    if (this.animationId) {
      cancelAnimationFrame(this.animationId);
    }
    if (this.renderer) {
      this.container.removeChild(this.renderer.domElement);
    }
  }
}

// Initialize enhanced globe when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  if (document.getElementById('interactive-globe')) {
    // Load Three.js dynamically
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js';
    script.onload = function() {
      new GeoLocationGlobe('interactive-globe');
    };
    script.onerror = function() {
      // Fallback to static globe if Three.js fails to load
      initStaticGlobe();
    };
    document.head.appendChild(script);
  }
});

// Enhanced fallback for static globe with location info
function initStaticGlobe() {
  const container = document.getElementById('interactive-globe');
  if (container && !container.querySelector('canvas')) {
    container.innerHTML = `
      <img src="garmir.io_assets/globe.gif" alt="Geographic Globe Visualization" class="globe-img" />
      <div style="margin-top: 10px; font-size: 12px; color: #bbbbbb; text-align: center;">
        interactive globe loading...
      </div>
    `;

    // Try to show basic location info even with static fallback
    fetch('https://ipapi.co/json/')
      .then(response => response.json())
      .then(data => {
        if (data.city && data.country) {
          container.querySelector('div').innerHTML = `visitor: ${data.city}, ${data.country}`;
        }
      })
      .catch(() => {
        container.querySelector('div').innerHTML = 'geographic visualization';
      });
  }
}