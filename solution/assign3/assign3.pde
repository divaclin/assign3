int[][] slot;
boolean[][] flagSlot; // use for flag
int bombCount; // 共有幾顆炸彈
int clickCount; // 共點了幾格
int flagCount; // 共插了幾支旗
int nSlot; // 分割 nSlot*nSlot格
int totalSlots; // 總格數
final int SLOT_SIZE = 100; //每格大小

int sideLength; // SLOT_SIZE * nSlot
int ix; // (width - sideLength)/2
int iy; // (height - sideLength)/2

// game state
final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_WIN = 3;
final int GAME_LOSE = 4;
int gameState;

// slot state for each slot
final int SLOT_OFF = 0;
final int SLOT_SAFE = 1;
final int SLOT_BOMB = 2;
final int SLOT_FLAG = 4;
final int SLOT_FLAG_BOMB = 5;
final int SLOT_DEAD = 6;

PImage bomb, flag, cross,bg;

void setup(){
  size (640,480);
  textFont(createFont("font/Square_One.ttf", 20));
  bomb=loadImage("data/bomb.png");
  flag=loadImage("data/flag.png");
  cross=loadImage("data/cross.png");
  bg=loadImage("data/bg.png");

  nSlot = 4;
  totalSlots = nSlot*nSlot;
  // 初始化二維陣列
  slot = new int[nSlot][nSlot];
  // for flag
  flagSlot = new boolean[nSlot][nSlot];
  
  sideLength = SLOT_SIZE * nSlot;
  ix = (width - sideLength)/2; // initial x
  iy = (height - sideLength)/2; // initial y
  
  gameState = GAME_START;
}

void draw(){
  switch (gameState){
    case GAME_START:
          background(222,119,15);
          image(bg,0,0,640,480);
          textSize(16);
          fill(0);
          text("Choose # of bombs to continue:",10,width/3-24);
          int spacing = width/9;
          for (int i=0; i<9; i++){
            fill(255);
            rect(i*spacing, width/3, spacing, 50);
            fill(0);
            text(i+1, i*spacing, width/3+24);
          }
          // check mouseClicked() to start the game
          break;
    case GAME_RUN:
          if (clickCount == totalSlots-bombCount){
            reavelAllSlots();
            gameState = GAME_WIN;
          }
          break;
    case GAME_WIN:
          textSize(18);
          fill(0);
          text("YOU WIN !!",width/3,30);
          break;
    case GAME_LOSE:
          textSize(18);
          fill(0);
          text("YOU LOSE !!",width/3,30);
          break;
  }
}

// requirement A
void reavelAllSlots(){
  background(180);
  image(bg,0,0,640,480);
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){

      if (slot[col][row] == SLOT_OFF){
        slot[col][row] = SLOT_SAFE;
      }
      showSlot(col, row, slot[col][row]);
      
      if (flagSlot[col][row]){
        if (slot[col][row] == SLOT_BOMB){
            showSlot(col, row, SLOT_FLAG_BOMB);
        }else{
            showSlot(col, row, SLOT_FLAG);
        }
        
      }
    }
  }  
}

void setBombs(){
  // initial slot
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
      slot[col][row] = SLOT_OFF;
    }
  }
  // randomly set bombs
  for (int i=0;i<bombCount;i++){
    int rnd = int(random(totalSlots));
    int col = int(rnd / nSlot);
    int row = rnd % nSlot;
    if ( slot[col][row] == SLOT_OFF){
      slot[col][row] = SLOT_BOMB;
    }else{
      i--;
    }
  }
}

void drawEmptySlots(){
  background(180);
  image(bg,0,0,640,480);
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
        showSlot(col, row, SLOT_OFF);
    }
  }
}
// requirement A
void resetFlag(){
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
        flagSlot[col][row] = false;
    }
  }
}

// -----------------------
void showSlot(int col, int row, int slotState){
  int x = ix + col*SLOT_SIZE;
  int y = iy + row*SLOT_SIZE;
  switch (slotState){
    case SLOT_OFF:
         fill(222,119,15);
         stroke(0);
         rect(x, y, SLOT_SIZE, SLOT_SIZE);
         break;
    case SLOT_BOMB:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE, SLOT_SIZE);
          break;
    case SLOT_SAFE:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          int count = countNeighborBombs(col,row);
          if (count != 0){
            fill(0);
            textSize(SLOT_SIZE*3/5);
            text( count, x+15, y+15+SLOT_SIZE*3/5);
          }
          break;
    case SLOT_FLAG:
          image(flag,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_FLAG_BOMB:
          image(cross,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_DEAD:
          fill(255,0,0);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
  }
}

int countNeighborBombs(int col, int row){
  int count = 0;
  for (int i=-1; i <= 1; i++){  // -1, 0, 1
    for (int j=-1; j<=1; j++){  // -1, 0, 1
      // limit: 0 .. nSlot to prevent overflow
      if (col+i >= 0 && col+i < nSlot &&
          row+j >= 0 && row+j < nSlot){
          if (slot[col+i][row+j] == SLOT_BOMB ||
              slot[col+i][row+j] == SLOT_DEAD) {
              count++;
          }
      }
    }
  }
  return count;
}

// select num of bombs
void mouseClicked(){
  if ( gameState == GAME_START &&
       mouseY > width/3 && mouseY < width/3+50){
       // select 1~9
       //int num = int(mouseX / (float)width*9) + 1;
       int num = int(map(mouseX, 0, width, 0, 9)) + 1;
       // println (num);
       bombCount = num;
       clickCount = 0;
       flagCount = 0;
       resetFlag();
       
       // randomly assign bombs
       setBombs();
       drawEmptySlots();
       gameState = GAME_RUN;
  }
}

// 
void mousePressed(){
  if ( gameState == GAME_RUN &&
       mouseX >= ix && mouseX <= ix+sideLength && 
       mouseY >= iy && mouseY <= iy+sideLength){
    int col = int(( int(mouseX) - ix ) / SLOT_SIZE);
    int row = int(( int(mouseY) - iy ) / SLOT_SIZE);
    
    if (mouseButton == LEFT && !flagSlot[col][row]) {
      switch (slot[col][row]){
        case SLOT_BOMB:
             slot[col][row] = SLOT_DEAD;
             reavelAllSlots();
             gameState = GAME_LOSE;
             break;
        case SLOT_OFF:
             // show # of neighbor bombs
             slot[col][row] = SLOT_SAFE;
             clickCount++;
             showSlot(col, row, SLOT_SAFE);
             break;
      }
    }else if (mouseButton == RIGHT && (slot[col][row] != SLOT_SAFE)){
               if (!flagSlot[col][row] && flagCount < bombCount ){
                   flagCount++;
                   flagSlot[col][row] = true;
                   showSlot(col,row, SLOT_FLAG);
               }else if (flagSlot[col][row]){
                   flagCount--;
                   flagSlot[col][row] = false;
                   showSlot(col,row, SLOT_OFF);
               }
    }
  }
}

// press enter to start
void keyPressed(){
  if(key==ENTER && (gameState == GAME_WIN || 
                    gameState == GAME_LOSE)){
     gameState = GAME_START;
  }
}
