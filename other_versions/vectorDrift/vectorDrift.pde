//vectorDrift - working sketch
//written in Processing
//By Phillip David Stearns
//Part of aYearInCode(); 356 project for 2015 - http://ayearincode.tumblr.com
//Uses code written by Daniel Shiffman for the flocking example in Processing
//Description: A utility which reproduces artifacts created by the glitch art technique datamoshing.
//Current implementation uses Block class to describe input source and output destinations for pixel data in the main window.
//Input and output displacement is controlled using PVectors, Input is currently set to static or random drift. Output is controlled by the flocking algorithm.
//At present, it's becoming clear that it would be nice to switch i/o vector controls between different modes (flocking and static or gravitational, etc),
//which may mean creating two array lists, one for inputs and another for outputs, then a method which grabs pixels from one, and maps to the other.
//will be paring down the Block class to make this a reality...
//WOOT!

PImage src, buffer;
Flock flock;

String outputPath;
int frameIndex;

boolean run = false;
boolean save = false;
boolean loaded = false;

public int block_size;
int mode = 0;
int modes = 10;
int source = 0;


void setup() {
  size(100, 100, P2D);
  surface.setResizable(true);
  block_size=32;
  frameIndex=0;
  frameRate(30);
  background(0);
}

void initializeFlock(int _block_size) {
  block_size = _block_size;

  rotational_noise = .1;
  cohesion_coef = block_size*10;
  separate_coef = block_size*5;
  align_coef = block_size*3;

  makeGrid();
}

void draw() {

  if (src !=null && loaded) {
    if (run) {
      flock.run();  
      displacePixels(flock);


      image(buffer, 0, 0);

      if (save) {
        saveFrame(outputPath+nf(frameIndex, 4)+".PNG");
        frameIndex++;
      }
    }
  }
}

void alphaOverlay() {
  pushMatrix();
  translate(width/2, height/2);
  rotate(PI*(float(frameCount)/1024));
  imageMode(CENTER);
  image(src, 0, 0);
  imageMode(CORNER);
  popMatrix();
}


void keyPressed() {

  switch(key) {
  case ' ':
    run = !run;
    if (run) println("PLAY");
    if (!run) println("STOP");
    break;
  case 'r': //reset
    if (src != null && loaded) {
      displaySrc();
      frameIndex=0;
    }
    break;
    case 'i':
    String copy_source = new String();
    source = (source+1)%3;
    if(source == 0){
      copy_source = "FRAME";
    } else if (source == 1){
      copy_source = "ORIGINAL";
    }else if (source == 2){
      copy_source = "BUFFER";
    }
    println("SOURCE: "+copy_source);
    break;
  case 'm':
    mode=(mode+1)%modes;
    println("MODE: " + mode);
    break;
  case',':
    mode=(modes+(mode-1))%modes;
    println("MODE: " + mode);
    break;
  case'.':
    mode=(mode+1)%modes;
    println("MODE: " + mode);
    break;
  case '1':
    initializeFlock(8);
    break;
  case '2':   
    initializeFlock(16);
    break;
  case '3':   
    initializeFlock(32);
    break;
  case '4':   
    initializeFlock(64);
    break;
  case '5':
    initializeFlock(128);
    break;
  case '6':   
    initializeFlock(256);
    break;
  case '7':   
    break;
  case '8':   
    break;

  case 'S':
    save_sequence();
    break;
  case 'o':
    open_file();
    break;
  case 'q':
    save = false;
    frameIndex=0;
    break;
  }
}

void displaySrc() {
  image(src, 0, 0);
  loadPixels();
}

void makeGrid() {
  flock = new Flock();
  for (int x = 0; x < int (width/block_size)+1; x++) {
    for (int y = 0; y < int (height/block_size)+1; y++) {
      flock.addBlock(new Block(block_size * x, block_size * y));
    }
  }
}



void displacePixels(Flock _input) {
  PVector copy = new PVector(0, 0);
  PVector paste = new PVector(0, 0);

  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    buffer.pixels[i]=pixels[i];
  }
  buffer.loadPixels();

  for (int i = _input.blocks.size() - 1; i >= 0; i-- ) {

    Block input_block = _input.blocks.get(i);
    switch(mode) {
    case 0:
      copy.set(input_block.origin);
      paste.set(PVector.add(input_block.origin, input_block.velocity));
      break;
    case 1:
      copy.set(PVector.add(input_block.origin, input_block.velocity));
      paste.set(input_block.origin);
      break;
    case 2:
      copy.set(input_block.origin);
      paste.set(PVector.sub(input_block.origin, input_block.velocity));
      break;
    case 3:
      copy.set(PVector.sub(input_block.origin, input_block.velocity));
      paste.set(input_block.origin);
      break;    
    case 4:
      copy.set(input_block.location);
      paste.set(PVector.add(input_block.location, input_block.velocity));
      break;
    case 5:
      copy.set(PVector.add(input_block.location, input_block.velocity));
      paste.set(input_block.location);
      break;
    case 6:
      copy.set(input_block.location);
      paste.set(PVector.sub(input_block.location, input_block.velocity));
      break;
    case 7:
      copy.set(PVector.sub(input_block.location, input_block.velocity));
      paste.set(input_block.location);
      break;
    case 8:
      copy.set(input_block.velocity);
      paste.set(input_block.origin);
      break;
    case 9:
      copy.set(input_block.origin);
      paste.set(input_block.location);
      break;
    }

    for (int _y = 0; _y < block_size; _y++) {
      for (int _x = 0; _x < block_size; _x++) {
        int capture_x = int(width + copy.x + _x)%(width);
        int capture_y = int(height + copy.y + _y)%(height);
        int displacement_x = int(width + paste.x +_x)%(width);
        int displacement_y = int(height + paste.y +_y)%(height);
        switch(source) {
        case 0 :
          buffer.pixels[displacement_x+(width*displacement_y)]=pixels[capture_x + (capture_y * width)];
          break;
        case 1:
          buffer.pixels[displacement_x+(width*displacement_y)]=src.pixels[capture_x + (capture_y * width)];
          break;
        case 2:
          buffer.updatePixels();
          buffer.pixels[displacement_x+(width*displacement_y)]=buffer.pixels[capture_x + (capture_y * width)];
          break;
        }
      }
    }
  }
  buffer.updatePixels();
  updatePixels();
}