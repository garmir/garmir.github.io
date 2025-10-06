// Mobile menu toggle for garmir.io
// Handles drawer open/close with keyboard accessibility

(function() {
  'use strict';
  
  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
  
  function init() {
    const drawer = document.querySelector('.drawer');
    const drawerMobile = document.querySelector('.drawer-mobile');
    
    if (!drawer || !drawerMobile) return;
    
    // Create hamburger menu button
    const menuButton = createMenuButton();
    drawerMobile.prepend(menuButton);
    
    // Add event listeners
    menuButton.addEventListener('click', toggleMenu);
    document.addEventListener('keydown', handleKeyboard);
    
    // Close menu when clicking outside
    document.addEventListener('click', function(e) {
      if (drawer.classList.contains('open') && 
          !drawer.contains(e.target) && 
          !menuButton.contains(e.target)) {
        closeMenu();
      }
    });
  }
  
  function createMenuButton() {
    const button = document.createElement('button');
    button.className = 'menu-toggle';
    button.setAttribute('aria-label', 'Toggle navigation menu');
    button.setAttribute('aria-expanded', 'false');
    button.setAttribute('aria-controls', 'main-navigation');
    button.innerHTML = `
      <span class="menu-icon" aria-hidden="true">
        <span></span>
        <span></span>
        <span></span>
      </span>
    `;
    return button;
  }
  
  function toggleMenu() {
    const drawer = document.querySelector('.drawer');
    const button = document.querySelector('.menu-toggle');
    const isOpen = drawer.classList.toggle('open');
    
    button.setAttribute('aria-expanded', isOpen);
    button.classList.toggle('active', isOpen);
    
    // Prevent body scroll when menu is open
    document.body.style.overflow = isOpen ? 'hidden' : '';
    
    // Focus first link when opening
    if (isOpen) {
      const firstLink = drawer.querySelector('.drawer-link');
      if (firstLink) firstLink.focus();
    }
  }
  
  function closeMenu() {
    const drawer = document.querySelector('.drawer');
    const button = document.querySelector('.menu-toggle');
    
    drawer.classList.remove('open');
    button.setAttribute('aria-expanded', 'false');
    button.classList.remove('active');
    document.body.style.overflow = '';
  }
  
  function handleKeyboard(e) {
    const drawer = document.querySelector('.drawer');
    
    // Close menu on Escape
    if (e.key === 'Escape' && drawer.classList.contains('open')) {
      closeMenu();
      document.querySelector('.menu-toggle').focus();
    }
  }
})();
