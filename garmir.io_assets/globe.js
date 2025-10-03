// Interactive Globe Component for garmir.io
// Three.js-based rotating globe with terminal aesthetic

class InteractiveGlobe {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.scene = null;
    this.camera = null;
    this.renderer = null;
    this.globe = null;
    this.animationId = null;

    this.init();
  }

  init() {
    if (!this.container) return;

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
    this.camera.position.z = 3;

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

    // Start animation
    this.animate();

    // Handle resize
    window.addEventListener('resize', () => this.onWindowResize());
  }

  createGlobe() {
    // Globe geometry
    const geometry = new THREE.SphereGeometry(1, 32, 32);

    // Terminal-style wireframe material
    const material = new THREE.MeshBasicMaterial({
      color: 0xbbbbbb,
      wireframe: true,
      transparent: true,
      opacity: 0.8
    });

    this.globe = new THREE.Mesh(geometry, material);
    this.scene.add(this.globe);

    // Add points for data visualization
    this.addDataPoints();
  }

  addDataPoints() {
    const pointsGeometry = new THREE.BufferGeometry();
    const pointsMaterial = new THREE.PointsMaterial({
      color: 0xbbbbbb,
      size: 0.02,
      transparent: true,
      opacity: 0.6
    });

    // Generate random points on sphere surface
    const points = [];
    for (let i = 0; i < 100; i++) {
      const phi = Math.acos(2 * Math.random() - 1);
      const theta = 2 * Math.PI * Math.random();

      const x = Math.sin(phi) * Math.cos(theta);
      const y = Math.sin(phi) * Math.sin(theta);
      const z = Math.cos(phi);

      points.push(x, y, z);
    }

    pointsGeometry.setAttribute('position', new THREE.Float32Array(points), 3);
    const pointsMesh = new THREE.Points(pointsGeometry, pointsMaterial);
    this.scene.add(pointsMesh);
  }

  animate() {
    this.animationId = requestAnimationFrame(() => this.animate());

    if (this.globe) {
      // Rotate globe slowly
      this.globe.rotation.y += 0.005;
      this.globe.rotation.x += 0.002;
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

// Initialize globe when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
  if (document.getElementById('interactive-globe')) {
    // Load Three.js dynamically
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js';
    script.onload = function() {
      new InteractiveGlobe('interactive-globe');
    };
    document.head.appendChild(script);
  }
});

// Fallback for static globe
function initStaticGlobe() {
  const container = document.getElementById('interactive-globe');
  if (container && !container.querySelector('canvas')) {
    container.innerHTML = '<img src="garmir.io_assets/globe.gif" alt="Animated Globe" class="globe-img" />';
  }
}