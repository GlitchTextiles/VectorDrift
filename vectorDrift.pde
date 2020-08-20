//vectorDrift - working sketch
//written in Processing
//By Phillip David Stearns
//Part of aYearInCode(); 356 project for 2015 - http://ayearincode.tumblr.com
//Uses code written by Daniel Shiffman for the flocking example in Processing
//Description: A utility which reproduces artifacts created by the glitch art technique datamoshing.
//Current implementation uses Block class to describe input source and output destinations for pixel data in the main window.
//Input and output displacement is controlled using PVectors, Input is currently set to static. Output is controlled by the flocking algorithm.


PImage src, buffer, preBuffer;
PGraphics helpOverlay;
Flock flock;

String outputPath;
int frameIndex=0;

boolean run = true;
boolean save = false;
boolean loaded = false;
boolean showFlock = true;

int block_size=0;
int gridSpacing_x=0;
int gridSpacing_y=0;
int mode = 1;

void setup() {
  size(10, 10);
  block_size=128;
  calcGridSpacing();
  frameRate(30);
  generateHelp(helpOverlay);
  open_file();
}

PGraphics generateHelp(PGraphics overlay){
  return overlay;
}

void draw() {
  if (src !=null && loaded) {
    if (run) {
      flock.run();
      image(buffer, 0, 0);
      preBuffer=buffer.copy();
      displacePixels(flock);
      if (save) {
        saveFrame(outputPath+nf(frameIndex, 4)+".PNG");
        frameIndex++;
      }
      if (!showFlock) {
        PGraphics flockRender = createGraphics(width, height);
        flock.display(flockRender);
        image(flockRender, 0, 0);
      }
    }
  }
}

void calcGridSpacing() {
  gridSpacing_x=block_size;
  gridSpacing_y=block_size;
}

void initializeFlock(int _block_size) {
  block_size = _block_size;
  calcGridSpacing();
  rotational_noise = .1;
  cohesion_coef = block_size*7;
  separate_coef = block_size*3;
  align_coef = block_size*1;
  makeGrid();
}

void makeGrid() {
  flock = new Flock();
  for (int x = 0; x < int (width/gridSpacing_x)+1; x++) {
    for (int y = 0; y < int (height/gridSpacing_y)+1; y++) {
      //flock.addBlock(new Block(gridSpacing_x * x, gridSpacing_y * y, block_size));
      flock.addBlock(new Block(gridSpacing_x * x, gridSpacing_y * y, int(random(block_size, block_size*2)), int(random(block_size, block_size*2))));
    }
  }
}


void displacePixels(Flock _input) {

  PVector copy = new PVector(0, 0);
  PVector paste = new PVector(0, 0);

  buffer.loadPixels();

  //for every block in the flock
  for (Block b : _input.blocks) {

    copy.set(b.origin);
    paste.set(PVector.sub(copy, b.velocity));

    for (int _y = 0; _y < b.size_x; _y++) {
      for (int _x = 0; _x < b.size_y; _x++) {
        int capture_x = int(width + copy.x + _x)%(width);
        int capture_y = int(height + copy.y + _y)%(height);
        int displacement_x = int(width + paste.x +_x)%(width);
        int displacement_y = int(height + paste.y +_y)%(height);

        //buffer.pixels[displacement_x+(width*displacement_y)]= preBuffer.pixels[capture_x + (capture_y * width)];
        buffer.pixels[capture_x+(width*capture_y)] = preBuffer.pixels[displacement_x + (displacement_y * width)];
      }
    }
  }
  buffer.updatePixels();
}
