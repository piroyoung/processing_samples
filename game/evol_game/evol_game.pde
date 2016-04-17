
int X = 1200;
int Y = 800;
int SIZE = 10;
int SPEED = 2;
BallGrid bg = new BallGrid(X, Y, SIZE);

void setup() {
  size(1200, 800);
  frameRate(10);
  for(int i = 0; i < X/SIZE; i++){
    for(int j = 0; j < Y/SIZE; j++){
      if(random(0,1) < 0.50) {
        bg.balls[i][j].state = true;
      }
    }
  }
}
void draw() {
  clear();
  bg.render();
  bg.next();
  //saveFrame("frames/######.tif");
}


class Ball {
  int size;
  int origSize = SIZE;
  int strength = SPEED;
  Boolean state;
  
  Ball(int size, Boolean state) {
    this.size = size;
    this.state = state;
  }
  
  public Boolean isTrue(){
    return this.state;
  }
  
  public int watchAround(Ball[] neighbors){
    int sum = 0;
    for(int i = 0; i < neighbors.length; i++){
      if(neighbors[i].state != this.state){
        sum += 1;
      }
    }
    return sum;
  }
  
  public void adaptToAround(Ball[] balls) {
    //if(this.watchAround(balls) >= balls.length/2 ){
    if(this.watchAround(balls) > balls.length/2){
      this.state = !this.state;
    }
  }
  
  public Ball getNextState(Ball[] balls) {
    if(this.watchAround(balls) > balls.length/2) {
      if(this.size - this.strength <= 0) {
        return new Ball(this.origSize, !this.state);
      } else {
        return new Ball(this.size - this.strength, this.state);
      }
      //return new Ball(this.size, !this.state);
    } else {
      return new Ball(this.origSize, this.state);
    }
  }
  
  public Ball clone() {
    return new Ball(this.size, this.state);
  }
}

class BallGrid {
  Ball balls[][];
  int screenX, screenY, ballSize;
  
  BallGrid(int screenX, int screenY, int ballSize){
   this.screenX = screenX;
   this.screenY = screenY;
   this.ballSize = ballSize;
   this.balls = new Ball[this.screenX/this.ballSize][this.screenY/this.ballSize];
   
   for(int i = 0; i < this.screenX/this.ballSize; i++ ){
     for(int j = 0; j < this.screenY/this.ballSize; j++){
       this.balls[i][j] = new Ball(ballSize, false);
     }
   }
       
  }
  
  void next(){
    //Edges have a Fixed Status 
    Ball[][] next = this.balls.clone();
    for(int i = 1; i < this.screenX/this.ballSize - 1; i++ ){
     for(int j = 1; j < this.screenY/this.ballSize - 1; j++){
       Ball neighbors[] = {
         balls[i-1][j],
         balls[i+1][j],
         balls[i][j-1],
         balls[i][j+1],
         balls[i+1][j-1],
         balls[i-1][j+1],
         balls[i-1][j-1],
         balls[i+1][j+1],
       };
       
       //this.balls[i][j].adaptToAround(neighbors);
       next[i][j] = this.balls[i][j].getNextState(neighbors);
     }
    } 
    this.balls = next.clone();
  }
  void render() {
   for(int i = 0; i < this.screenX/this.ballSize; i++ ){
     for(int j = 0; j < this.screenY/this.ballSize; j++){
       if(this.balls[i][j].state == true) {
         fill(128); 
       } else {
         fill(255);
       }
       ellipse((float)this.ballSize*i, (float)this.ballSize*j, (float)this.balls[i][j].size, (float)this.balls[i][j].size);
     }
   } 
  }
}