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
final int GAME_START = 1;//
final int GAME_RUN = 2;//
final int GAME_WIN = 3;//
final int GAME_LOSE = 4;//
int gameState;

// slot state for each slot
final int SLOT_OFF = 0;
final int SLOT_SAFE = 1;
final int SLOT_BOMB = 2;
final int SLOT_FLAG = 3;
final int SLOT_FLAG_BOMB = 4;
final int SLOT_DEAD = 5;

PImage bomb, flag, cross ,bg;

void setup(){
  size (640,480);
  textFont(createFont("font/Square_One.ttf", 20));
  bomb=loadImage("data/bomb.png");
  flag=loadImage("data/flag.png");
  cross=loadImage("data/cross.png");
  bg=loadImage("data/bg.png");
  
  nSlot = 4;//4*4 size
  totalSlots = nSlot*nSlot;
  // 初始化二維陣列
  slot = new int[nSlot][nSlot];
  
  sideLength = SLOT_SIZE * nSlot;
  ix = (width - sideLength)/2; // initial x
  iy = (height - sideLength)/2; // initial y
  
  gameState = GAME_START;
}

void draw(){//graphic
  switch (gameState){
    case GAME_START:
          background(180);
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
          //---------------- put you code here ----
         //clickCount
         // -----------------------------------
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

int countNeighborBombs(int col,int row){
  // -------------- Requirement B ---------
   /*int nx=(mouseX-ix)/SLOT_SIZE;
   int ny=(mouseY-iy)/SLOT_SIZE;
   if (nx>=4){
      nx=3;
      }
   if (ny>=4){
      ny=3;
      }  
  for(int nx-1,nx+1,){
  for(ny-1,ny+1,){
  if 
  }
  }*/
  return 0;
}

void setBombs(){
  // initial slot
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
      slot[col][row] = SLOT_OFF;
  }
  }
  // -------------- put your code here ---------
  // randomly set bombs
     for(int A =0; A<bombCount;A++){
    int x = int(random(4));
    int y = int(random(4));
    if (slot[x][y]== SLOT_OFF){
     slot[x][y]=SLOT_BOMB;
    } else if(slot[x][y]== SLOT_BOMB){
      A = A--;
    }
  }

  // ---------------------------------------
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

// select num of bombs
void mouseClicked(){
  if ( gameState == GAME_START &&
       mouseY > width/3 && mouseY < width/3+50){
       // select 1~9
       //int num = int(mouseX / (float)width*9) + 1;
       int num = (int)map(mouseX, 0, width, 0, 9) + 1;
       // println (num);
       bombCount = num;
       
       // start the game
       clickCount = 0;
       flagCount = 0;
       setBombs();
       drawEmptySlots();
       gameState = GAME_RUN;
  }
}

void mousePressed(){
  if ( gameState == GAME_RUN &&
       mouseX >= ix && mouseX <= ix+sideLength && 
       mouseY >= iy && mouseY <= iy+sideLength){
    
    // --------------- put you code here -------
       
       int mx=(mouseX-ix)/SLOT_SIZE;
       int my=(mouseY-iy)/SLOT_SIZE;
       if (mx>=4){
         mx=3;
       }
        if (my>=4){
         my=3;
       }  
       //if mouseX Y=bomb show pictures
       if (slot[mx][my]==SLOT_BOMB){//press "2" lose 
       showSlot(mx,my,SLOT_DEAD);
       gameState = GAME_LOSE;//switch "lose state"
       }
       else
       {
         clickCount++;
         showSlot(mx,my,SLOT_SAFE);
         System.out.println("slot[mx][my]:"+slot[mx][my]);
         if(bombCount==totalSlots-clickCount)
         {gameState = GAME_WIN;}
       }
     
     
     
       
       
    // -------------------------
    
  }
  
}

// press enter to start
void keyPressed(){
  if(key==ENTER && (gameState == GAME_WIN || 
                    gameState == GAME_LOSE)){
     gameState = GAME_START;
  }
}


