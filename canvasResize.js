<!-- HTML -->
//<canvas id="my-canvas"></canvas>

<!-- JavaScript -->
<script>
  // Get the canvas element
  const canvas = document.getElementById('my-canvas');
  // Get the canvas context
  const ctx = canvas.getContext('2d');

  // Handle resize events
  window.addEventListener('resize', () => {
    // Set the canvas to full screen
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    // Redraw the canvas
    draw();
  });

  // Draw something on the canvas
  function draw() {
    // Clear the canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // Set the fill style to red
    ctx.fillStyle = 'red';
    // Draw a rectangle
    ctx.fillRect(100, 100, 200, 200);
  }
</script>
