//vectorDrift - working sketch
//written in Processing
//By Phillip David Stearns
//Part of aYearInCode(); 356 project for 2015 - http://ayearincode.tumblr.com
//Uses code written by Daniel Shiffman for the flocking example in Processing
//Description: A utility which reproduces artifacts created by the glitch art technique datamoshing.
//Current implementation uses Block class to describe input source and output destinations for pixel data in the main window.
//Input and output displacement is controlled using PVectors, Input is currently set to static. Output is controlled by the flocking algorithm.


PImage src, buffer;
PGraphics helpOverlay, flockOverlay;

Flock flock;

String outputPath;
int frameIndex=0;

//control flags
boolean run = false;
boolean seq = false;
boolean loaded = false;
boolean showFlock = false;
boolean help = true;
boolean square = true; // toggles between square tiles or randomized tiles

int block_size=0;
int mode = 0;
int order = 0;

void setup() {
  size(600, 400);
  block_size=128;
  frameRate(30);
  helpOverlay = generateHelp();
}

void draw() {
  if ( (src != null || loaded) && run) {
    flock.run();
    image(buffer, 0, 0);
    displacePixels(flock);
    if (seq) {
      saveFrame(outputPath+nf(frameIndex, 4)+".PNG");
      frameIndex++;
    }
  } else {
    if (buffer != null) {
      image(buffer, 0, 0);
    } else {
      background(0);
    }
  }
  if (showFlock) renderFlock(flock);
  if (help) image(helpOverlay, 0, 0);
}

void renderFlock(Flock _flock) {
  flockOverlay = createGraphics(width, height);
  _flock.display(flockOverlay);
  image(flockOverlay, 0, 0);
}

void initializeFlock(int _block_size) {
  block_size = _block_size;
  rotational_noise = .1;
  cohesion_coef = block_size*7;
  separate_coef = block_size*3;
  align_coef = block_size*1;
  makeGrid();
}

void makeGrid() {
  flock = new Flock();
  for (int x = 0; x < int (width/block_size)+1; x++) {
    for (int y = 0; y < int (height/block_size)+1; y++) {
      if (square) {
        flock.addBlock(new Block(block_size * x, block_size * y, block_size));
      } else {
        flock.addBlock(new Block(block_size * x, block_size * y, int(random(block_size, block_size*2)), int(random(block_size, block_size*2))));
      }
    }
  }
}


void displacePixels(Flock _input) {
  PImage preBuffer=buffer.copy();
  PVector copy = new PVector(), paste = new PVector();

  buffer.loadPixels();

  //for every block in the flock
  for (Block b : _input.blocks) {
    
    // copy/paste sources
    // b.origin
    // b.location
    // b.last_location
    // PVector.sub(b.origin, b.velocity)
    // PVector.sub(b.location, b.velocity)
    // PVector.sub(b.velocity, b.origin)
    // PVector.sub(b.velocity, b.location)
    // PVector.add(b.origin, b.velocity)
    // PVector.add(b.location, b.velocity)
    // PVector.add(b.velocity, b.origin)
    // PVector.add(b.velocity, b.location)
    // PVector.sub(b.last_location, b.location)
    // PVector.sub(b.location, b.last_location)
    // PVector.add(b.last_location, b.location)
    // PVector.add(b.location, b.last_location)
    // PVector.sub(b.location, b.acceleration)
    // PVector.sub(b.last_location, b.acceleration)
    // PVector.sub(b.origin, b.acceleration)
    
    switch(mode) {
    case 0:
      copy = b.origin;
      paste = PVector.sub(b.origin, b.velocity);
      break;
    case 1:
      copy = b.location;
      paste = PVector.sub(b.location, b.velocity);
      break;
    case 2:
      copy = b.last_location;
      paste = b.location;
      break;
    }

    for (int _y = 0; _y < b.size_x; _y++) {
      for (int _x = 0; _x < b.size_y; _x++) {

        int capture_x = int(width + copy.x + _x)%(width);
        int capture_y = int(height + copy.y + _y)%(height);
        int displacement_x = int(width + paste.x +_x)%(width);
        int displacement_y = int(height + paste.y +_y)%(height);

        switch(order) {
        case 0:
          buffer.pixels[displacement_x+(width*displacement_y)] = preBuffer.pixels[capture_x + (capture_y * width)];
          break;
        case 1:
          buffer.pixels[capture_x+(width*capture_y)] = preBuffer.pixels[displacement_x + (displacement_y * width)];
          break;
        }
      }
    }
  }

  buffer.updatePixels();
}
