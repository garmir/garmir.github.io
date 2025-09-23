// Working Terminal Globe - Actually Functional (\u25d5\u203f\u25d5)
// Fixed using .claude framework patterns \uff3c(^o^)\uff0f

document.addEventListener('DOMContentLoaded', function() {
    const globeContainer = document.getElementById('interactive-globe');
    if (!globeContainer) {
        console.log('Globe container not found (\u25d5\u203f\u25d5)');
        return;
    }

    // Simple working ASCII globe \uff3c(^o^)\uff0f
    const globeFrames = [
        `    ╭─────────╮
   ╱           ╲
  ╱    (\u25d5\u203f\u25d5)    ╲
 │   scanning...   │
  ╲               ╱
   ╲_____________╱
     ╰─────────╯`,
        `    ╭─────────╮
   ╱           ╲
  ╱   network    ╲
 │   active! \uff3c(^o^)\uff0f  │
  ╲               ╱
   ╲_____________╱
     ╰─────────╯`
    ];

    let frameIndex = 0;

    // Create globe display
    globeContainer.innerHTML = `
        <div style="
            font-family: 'JetBrains Mono', monospace;
            font-size: 12px;
            line-height: 1.2;
            color: #bbbbbb;
            background: #000000;
            padding: 15px;
            border: 1px dotted #bbbbbb;
            white-space: pre;
            text-align: center;
            margin: 20px auto;
            cursor: pointer;
        " onclick="alert('Globe clicked! (\u25d5\u203f\u25d5)')">
            <div id="globe-display">${globeFrames[0]}</div>
            <div style="font-size: 10px; margin-top: 10px; color: #666;">
                click to interact (\u25d5\u203f\u25d5)
            </div>
        </div>
    `;

    // Animate the globe
    setInterval(function() {
        frameIndex = (frameIndex + 1) % globeFrames.length;
        const display = document.getElementById('globe-display');
        if (display) {
            display.textContent = globeFrames[frameIndex];
        }
    }, 2000);

    console.log('Globe initialized successfully! \uff3c(^o^)\uff0f');
});