/* Name : Darius Vanagevcius Student Number: 20103104 Programme Name: Information Technology Level 7
Description of the animation achieved: simple platformer game (use arrow keys to move and jump around)
Known bugs/problems: blocks above the ground move if you move against them
*/


import javax.swing.*; //imports dialog options

float globalX=0;  //position x of world
float globalY=0;  //positon y of world
float characterY=0; // poistion Y of characet

float yNew=0;
float yOld=0;
float yChanged=0;

float Xresult=0;
float Xstart=5*0.3;
float Xramp=5*0.015; // basic number required for movemnet speed ramp up

float Ystart=5*0.3;
float Yramp=5*0.015; // basic number required for jump speed ramp up

boolean jump=false;
boolean move=false;
boolean moveTriggered=false;
boolean moveHappened=false;
float moveT=frameRate*.33;

boolean leftPressed=false;
boolean rightPressed=false;
boolean upPressed=false; // later checks if buttons are pressed
float keyPressedNum=0;

float characterYvelocity=0;

float jumpTime=frameRate*15;

float keyOld;
float keyNew;

boolean groundTouch=false;

PImage smallCloud; //creats container for iimporting an image
PImage bigCloud;

float [] cloudYlocation1 = new float[25];
float [] cloudYlocation2 = new float[25];

float [] cloudXlocation1 = new float[25];
float [] cloudXlocation2 = new float[25]; //creats arrays with 25 variables

float modifierMove=0;
float modifierJump=0;
float modifierGravity=1;
float modifierExtraClouds=0; // creats modifier values

Boolean initalSetup1=false;
Boolean initalSetup2=false;
Boolean initalSetup3=false;
Boolean initalSetup4=false;

void setup() {
  size(800,800);
  background(78,217,222);
  frameRate=30;
  smallCloud = loadImage("cloudSmall.png"); //import cloud pictures/textures
  bigCloud = loadImage("cloudBig.png");
  
  int i1=0;
  int i2=0;
  int i3=0;
  int i4=0;
  // all while loops randomize cloud poistions
  do {
    cloudYlocation1[i1]=50+random(0,1)*400;
    i1++;
  } while(i1<25);
  
  do {
    cloudYlocation2[i2]=10+random(0,1)*300;
    i2++;
  } while(i2<25);
  
  do {
    cloudXlocation1[i3]=50+random(0,1)*1000;
    i3++;
  } while(i3<25);
  
  do {
    cloudXlocation2[i4]=10+random(0,1)*1000;
    i4++;
  } while(i4<25);
}

void draw() {
  //      asks user for custom variabls and checks to not run same prompt again
  while (initalSetup1==false) {
  modifierMove=modifierMove();
  initalSetup1=true;
  }
  
  while (initalSetup2==false) {
  modifierJump=modifierJump();
  initalSetup2=true;
  }
  
  while (initalSetup3==false) {
  modifierGravity=modifierGravity();
  initalSetup3=true;
  }
  
  while (initalSetup4==false) {
  modifierExtraClouds=modifierExtraClouds();
  initalSetup4=true;
  }
  
  keyWorkaround(); //workaround to be able to use more than one key at a time works kinda bad but at least it works
  
  yOld=yNew;
  yNew=characterY;
  yChanged=yNew-yOld; // get's diffrance between y value
  
characterMoveRight(modifierMove); //allows stickman to move right
characterMoveLeft(modifierMove); // allows stickman to move left
  
  if(keyPressed==false) { // if all keys gets released then stickman goes to first animation
    moveTriggered=false;
    Xresult=0;
  }
  
  characterJumpLimit(modifierGravity); // limits stickman's jump ability
  characterJumpUp(modifierJump); // allow stickman to jump when pressing forward arrow key
  
  background(78,217,222); // clear window
  cloudPositionRender(); // renders clouds with varying speeds
  stickMan(); // draw stickman + animations
  
  theBlock(500,0); // draw obsitcales + collison
  theBlock(600,50);
  theBlock(700,100);
  theBlock(750,150);
  theBlock(800,150);
  theBlock(850,150);
  theBlock(900,150);
  
  worldSquareSetup(globalX,0); // draw ground + collision
  // EXPERMIMENTAL STUFF HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

}

float modifierMove() {
  float i=Float.parseFloat(JOptionPane.showInputDialog(null,"Enter postitive or negative number for move speed (0 is default)",
  "Move Speed Modifier",
  JOptionPane.PLAIN_MESSAGE));
  return i;
}

float modifierJump() {
  float i=Float.parseFloat(JOptionPane.showInputDialog(null,"Enter postitive or negative number for jump speed (0 is default)",
  "Jump Speed Modifier",
  JOptionPane.PLAIN_MESSAGE));
  return i;
}

float modifierGravity() {
  float i=Float.parseFloat(JOptionPane.showInputDialog(null,"Enter postitive number for gravity multipler (0 is default)",
  "Gravity Multipler Modifier",
  JOptionPane.PLAIN_MESSAGE));
  return i;
}

float modifierExtraClouds() {
  float i=Float.parseFloat(JOptionPane.showInputDialog(null,"Enter postitive number for how many extra clouds should be rendered (0 is default and 20 is max)",
  "Gravity Multipler Modifier",
  JOptionPane.PLAIN_MESSAGE));
  return i;
}

void keyWorkaround() {
  if(keyPressed==true) {
    if(keyCode==UP) {
      upPressed=true;
    }
    if(keyCode==LEFT) {
      leftPressed=true;
    }
    if(keyCode==RIGHT) {
      rightPressed=true;
    }
    
    if(keyPressedNum<0) {
      keyPressedNum=0;
      
    upPressed=false;
    leftPressed=false;
    rightPressed=false;
    }
    
  } else {
    upPressed=false;
    leftPressed=false;
    rightPressed=false;
  }
}

void theBlock(float x,float y) {
  if(globalX>325-x && globalX<340-x && characterY<49+y) { //right check
    globalX=325-x;
  }
  if(globalX<425-x && globalX>405-x && characterY<49+y) { //left check
    globalX=425-x;
  }
  
  if(globalX>325-x && globalX<425-x && characterY<50+y) { //top check
    characterY=50+y;
    groundTouch=true;
    characterJumpLimit(modifierGravity);
  } else {groundTouch=false;}
  for(float i=0; i<800; i=i+50) { //renders blocks under block
    square(globalX+x,600-globalY+-abs(y)+i,50);
  }
}

void cloudPositionRender() {
  for(int i=0;i<2+modifierExtraClouds;i++) {
    cloudXlocation1[i]=cloudXlocation1[i]+random(.2,2);
    cloudXlocation2[i]=cloudXlocation2[i]+random(.2,2);
  }
  
  for(int i=0;i<2+modifierExtraClouds;i++) {
    if(cloudXlocation1[i]>width+100) {
    cloudXlocation1[i]=-100;
    }
    if(cloudXlocation2[i]>width+100) {
    cloudXlocation2[i]=-100;
    }
   }
  
  for(int i=0;i<2+modifierExtraClouds;i++) {
    image(smallCloud,cloudXlocation1[i],cloudYlocation1[i]);
    image(bigCloud,cloudXlocation2[i],cloudYlocation2[i]);
  }
}

void characterJumpLimit(float grav) {
  if(characterY>0 && jump==false && groundTouch==false) {
    characterYvelocity=characterYvelocity+9.8/frameRate*grav;
    characterY=characterY-characterYvelocity;
  }
  if( (jump==false && characterY<0) || groundTouch==true) {
    jumpTime=frameRate*15;
    characterYvelocity=0;
  }
}

void characterMoveLeft(float move) {
  if(leftPressed==true || (keyPressed==true && keyCode==LEFT) ) { // move left
    moveTriggered=true;
    if(Xresult==0) {
      Xresult=Xstart;
    }
    if(Xresult<5) {
      Xresult=Xresult+Xramp+move;
    }
    globalX=globalX+Xresult;
  }
}

void characterMoveRight(float move) {
  if(rightPressed==true ||  (keyPressed==true  && keyCode==RIGHT) ) { // move right
    moveTriggered=true;
    if(Xresult==0) {
      Xresult=Xstart;
    }
    if(Xresult<5) {
      Xresult=Xresult+Xramp+move;
    }
    globalX=globalX-Xresult;
  }
}

void characterJumpUp(float jjump) {
  if( (keyPressed==true && keyCode==UP || upPressed==true)  && jumpTime>0) {  // jumo up
    jumpTime=jumpTime-frameRate;
    characterY=characterY+7.5+jjump;
    jump=true;
    characterYvelocity=0;
  } else {
    jump=false;
  }
}

void worldSquareSetup(float x, float y) { //renders sqaures in the world
  for(float i=0;i<20;i++) {
    float iTemp=i*50;
    square(-100+x+iTemp,750+y,50);
    square(-100+x+iTemp,700+y,50);
    square(-100+x+iTemp,650+y,50);
  }
  
}

void stickMan() { // rencers stickman plus various poses depending on characters state
  if(moveT>0 && moveTriggered==true && moveHappened==false) {
    move=true;
    moveT--;
    
  } else {
    moveHappened=true;
    move=false;
  }
  
  if(moveT<frameRate*.33 && moveHappened==true && moveTriggered) {
    moveT++;
  } else {
    moveHappened=false;
  }
  
  if(yChanged<=0) {
  if(move==true) { // moving  stickManPose1{width/2,height/3+height/2.5-characterY   ,width/2,height/3+height/2.3-characterY}
  line(width/2,height/3+height/2.5-characterY  ,width/2,height/3+height/2.3-characterY); // torso
  line(width/2,height/3+height/2.3-characterY  ,width/2.05,height/2+height/3.28-characterY); // left leg
  line(width/2,height/3+height/2.3-characterY  ,width/1.95,height/2+height/3.2-characterY); // right leg
  line(width/2.05,height/3+height/2.3-characterY  ,width/2,height/3+height/2.46-characterY); // left arm
  line(width/1.9,height/3+height/2.35-characterY  ,width/2,height/3+height/2.46-characterY); // right arm
  circle(width/2,height/3+height/2.6-characterY  ,25); // head
  } else {  // stationary
  line(width/2,height/3+height/2.5-characterY  ,width/2,height/3+height/2.3-characterY); // torso
  line(width/2,height/3+height/2.3-characterY  ,width/2.1,height/2+height/3.2-characterY); // left leg
  line(width/2,height/3+height/2.3-characterY  ,width/1.9,height/2+height/3.2-characterY); // right leg
  line(width/2.1,height/3+height/2.3-characterY  ,width/2,height/3+height/2.46-characterY); // left arm
  line(width/1.9,height/3+height/2.3-characterY  ,width/2,height/3+height/2.46-characterY); // right arm
  circle(width/2,height/3+height/2.6-characterY  ,25); // head
  }
  } else { // jumping or falling
  line(width/2,height/3+height/2.5-characterY  ,width/2,height/3+height/2.3-characterY); // torso
  line(width/2,height/3+height/2.3-characterY  ,width/2.08,height/2+height/3.1-characterY); // left leg
  line(width/2,height/3+height/2.3-characterY  ,width/1.91,height/2+height/3.25-characterY); // right leg
  line(width/2.15,height/3+height/2.5-characterY  ,width/2,height/3+height/2.46-characterY); // left arm
  line(width/1.88,height/3+height/2.45-characterY  ,width/2,height/3+height/2.46-characterY); // right arm
  circle(width/2,height/3+height/2.6-characterY  ,25); // head
  }
}


void keyReleased() { // if a key is released then keyPressedNum gets set to a negative number, needed for my workaround to pressming more than one key
  keyPressedNum--;
}
