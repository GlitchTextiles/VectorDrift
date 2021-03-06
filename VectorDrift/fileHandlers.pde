//////////////////////////////////////////////////////////////
// File handlers

void open_file() {
  loaded = false;
  selectInput("Select a file to process:", "inputSelection");
}

void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    load_image(input.getAbsolutePath());
  }
}

void load_image(String thePath) {
  println("loading: "+thePath+" ... ");
  src = loadImage(thePath);
  if (src != null) {
    surface.setLocation(displayWidth-src.width,0);
    surface.setSize(src.width, src.height);
    buffer = src.copy();
    initializeFlock(block_size);
    loaded = true;
  } else {
    println("Image failed to load.");
  }
}


public void save_file() {
    run=false;
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    save_still(output.getAbsolutePath());
  }
}

void save_still(String thePath) {
  buffer.save(thePath);
}

public void save_sequence() {
  selectFolder("Select a file to process:", "outputFolderSelection");
}

void outputFolderSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    outputPath = output.getAbsolutePath();
    seq = true;
  }
  frameIndex=0;
}
