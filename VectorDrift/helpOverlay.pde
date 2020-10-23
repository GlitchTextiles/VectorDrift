PGraphics generateHelp() {

  PGraphics overlay = createGraphics(width, height);

  int margin_top = 50;
  int margin_bottom = 50;
  int margin_left = 50;
  int margin_right = 50;
  float line_spacing = 1.0;
  int text_size = 12;
  int indent = 0;

  PFont mono = createFont("Andale Mono.ttf", text_size);

  String[] help = {
    "=========================================================================", 
    "____   ____             __              ________        .__  _____  __   ", 
    "\\   \\ /   /____   _____/  |_  __________\\______ \\_______|__|/ ____\\/  |_ ", 
    " \\   Y   // __ \\_/ ___\\   __\\/  _ \\_  __ \\    |  \\_  __ \\  \\   __\\\\   __\\", 
    "  \\     /\\  ___/\\  \\___|  | (  <_> )  | \\/    `   \\  | \\/  ||  |   |  |  ", 
    "   \\___/  \\___  >\\___  >__|  \\____/|__| /_______  /__|  |__||__|   |__|  ", 
    "              \\/     \\/                         \\/                       ", 
    "", 
    "=========================================================================", 
    "", 
    "A really cludgy way to simulate dataMoshing...", 
    "Written by Phillip David Stearns in 2015 for aYearInCode", 
    "Revised in 2020 for GlitchTextiles' GlitchTools project.", 
    "Flocking based on Daniel Shiffman's example on Processing.org", 
    "", 
    "KeyBindings:", 
    "------------", 
    "", 
    "h        toggle this help overlay", 
    "o        open file dialog", 
    "SPACE    start and stop animation", 
    "q,w      switch copy order", 
    "y,u,i    change copy/paste sources:", 
    "         origin/velocity, location/velocity, last/current location", 
    "t        reset the image", 
    "1-6      size of the tiles", 
    "s        save current frame", 
    "S        save following frames as a sequence", 
    "x        stop saving the sequence"
  };

  int x = 0, y = 0;

  overlay.noSmooth();
  overlay.beginDraw();
  overlay.noStroke();
  overlay.fill(0, 192);
  overlay.rect(margin_left/2, margin_top/2, 520, 360);
  overlay.textSize(text_size);
  overlay.textFont(mono);
  overlay.fill(255);
  for (int i = 0; i < help.length; ++i) {
    if (i ==   0) {
      x = indent + margin_left;
    } else {
      x = margin_left;
    }
    y = margin_top + int(text_size*line_spacing*i);
    overlay.text(help[i], x, y);
  }
  overlay.endDraw();
  return overlay;
}
