void keyPressed() {

  switch(key) {
  case ' ':
    run = !run;
    break;
  case'q':
    mode = 0;
    break;
  case'w':
    mode = 1;
    break;
  case'e':
    mode = 2;
    break;
  case'r':
    mode = 3;
    break;
  case 't': //reset
    if (src!=null) buffer=src.copy();
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

  case 'S':
    save_sequence();
  case 's':
    save_file();
    break;
  case 'o':
    open_file();
    break;
  case 'x':
    save = false;
    frameIndex=0;
  }
}
