final static float MOVE_SPEED = 10;
final static float COIN_SCALE = 0.4;
final static float TANK_SCALE = 0.5;
final static float GRAVITY = 0.8;
final static float SPRITE_SCALE = 0.8;
final static float SPRITE_SIZE = 50; 
final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;
final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;
final static float WIDTH = SPRITE_SIZE * 16;
final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

//declaring enemy
Enemy enemy;
 
//declaring Sprite arraylists
ArrayList<Sprite> coins; 
ArrayList<Sprite> platforms;

//variable to keep track of what round the player is on
int round = 0;

//declaring score variable
int score;
boolean isGameOver;

//declaring view variables for scrolling
float view_x;
float view_y;

//declaring images for in game
Player player;
PImage grass, yellowCrate, blueCrate, wall, p, e, parrot;
PImage gold;

void setup()
{
  //creates image tab
  size(1000, 500);
  imageMode(CENTER);
 
  //initialize player sprite 
  p = loadImage("player.png");
  player = new Player(p, 0.5);
  player.center_x = 100;
  player.center_y = 200;
  view_x = 0;
  view_y = 0;
  
  //e = loadImage("parrot.png");
  //enemy = new Enemy(e, 0.5, 0.5, 0.5);
  //enemy.center_x = 100;
  //enemy.center_y = 200;
  //view_x = 0;
  //view_y = 0;
 
  // initialize score/game
  score = 0;
  isGameOver = false;
  
  // initialize the lists of coins and platforms
  coins = new ArrayList<Sprite>();
  platforms = new ArrayList<Sprite>();
  
  //declaring extra sprites
  grass = loadImage("grass.png");
  yellowCrate = loadImage("yellowTile.png");
  blueCrate = loadImage("blueTile.png");
  wall = loadImage("wall.png");
  gold = loadImage("coin_01.png");
  parrot = loadImage("parrot.png");
  
  //creates Platforms
  playRound(++round);
}

void draw()
 {
  //paints background as white
  background(255);
  
  //allows for scrolling
  scroll();
  
  //display objects
  displayAll();
  
  //update objects
  if(!isGameOver)
  {
    updateAll();
    collectCoins();
    checkDeath(); 
  }
}
 
void displayAll()
{  //updates/creates platforms
  for(Sprite s: platforms)
  {
    s.display();
  }

  //prints all coins that haven't been picked up
  
  
  //updates positions
  player.display();
  
  
  //prints players score
  textSize(32);
  fill(0, 0, 255);
  text("Coins:" + score, view_x + 50, view_y + 50);
  text("Lives:" + player.lives, view_x + 50, view_y + 100);
  text("Round:" + round, view_x + 200, view_y + 50);
  
  if(isGameOver)
  {
    fill(0, 0, 255);
    text("GAME OVER!", view_x + width/2 - 100, view_y + height/2);
    if(player.lives <= 0)
    {
      text("You lose!", view_x + width/2 - 100, view_y + 50);
    }
    else
    {
      text("You win!", view_x + width/2 - 100, view_y + 50);
    }
    text("Press SPACE to go to the next round!", view_x + width/2 - 100, view_y + 100);
  }
}

void updateAll()
{
  player.updateAnimation();
  
  //resolves any collisions between sprites
  resolvePlatformCollisions(player, platforms);
  
  //enemy.update();
  //enemy.updateAnimation();
  
  for(Sprite p: coins)
  {
    p.display();
    ((AnimatedSprite)p).updateAnimation();
    p.update();
  }
  
  collectCoins();
  checkDeath();
}

void checkDeath()
{
  boolean collideEnemy = checkCollision(player, enemy);
  boolean fallOffCliff = player.getBottom() > 1050;
  if(collideEnemy || fallOffCliff)
  {
    player.lives--;
    if(player.lives == 0)
    {
      isGameOver = true;
    }
    else
    {
      player.center_x = 100;
      player.center_y = 200;
    }
    
  }
}

void collectCoins()
{
  //checks for any collisions with coins, and removes them if so
  ArrayList<Sprite> collision_list = checkCollisionList(player, coins);
  if(collision_list.size() > 0)
  {
    for(Sprite coin: collision_list)
    {
      coins.remove(coin);
      score++;
    }
  }
  if(coins.size() == 0)
  {
    isGameOver = true;
  }
}

public void scroll()
{
  //scrolls right if player moves close to out of frame right
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(player.getRight() > right_boundary)
  {
    view_x += player.getRight() - right_boundary;
  }
  
  //scrolls left if player moves close to out of frame left
  float left_boundary = view_x + LEFT_MARGIN;
  if(player.getLeft() < left_boundary)
  {
    view_x -= left_boundary - player.getLeft();
  }
  
  
  //scrolls down if player moves close to out of frame bottom
  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if(player.getBottom() > bottom_boundary)
  {
    view_y += player.getBottom() - bottom_boundary;
  }
  
  //scrolls up if player moves close to out of frame top
  float top_boundary = view_y + VERTICAL_MARGIN;
  if(player.getTop() < top_boundary)
  {
    view_y -= top_boundary - player.getTop();
  }
  
  translate(-view_x, -view_y);
}

public void createPlatforms(String filename)
{
  String [] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++)
  {
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++)
    {
      if(values[col].equals("1"))
      {
        Sprite s = new Sprite("yellowTile.png", SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2"))
      {
        Sprite s = new Sprite("grass.png", SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3"))
      {
        Sprite s = new Sprite("wall.png", SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4"))
      {
        Coin s = new Coin(gold, SPRITE_SCALE/1.2);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(s);
      }
      else if(values[col].equals("5"))
      {
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        enemy = new Enemy(parrot, 0.16, bLeft, bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
      }
    }
  }
  
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls)
{
  s.change_y += GRAVITY;
  
  
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0)
  {
    Sprite collided = col_list.get(0);
    if(s.change_y > 0)
    {
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0)
    {
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0)
  {
    Sprite collided = col_list.get(0);
    if(s.change_x > 0)
    {
      s.setRight(collided.getLeft());
    }
    else if(s.change_y < 0)
    {
      s.setLeft(collided.getRight());
    }
    s.change_x = 0;
  }
}


// returns whether the two Sprites s1 and s2 collide.
public boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

/**
   This method accepts a Sprite s and an ArrayList of Sprites and returns
   the collision list(ArrayList) which consists of the Sprites that collide with the given Sprite. 
   MUST CALL THE METHOD checkCollision ABOVE!
*/ 
public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list)
{
  // fill in code here
  // see: https://youtu.be/RMmo3SktDJo
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list)
  {
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls)
{
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -=5;
  return col_list.size() > 0;
}

public void playRound(int r) {
  if(r == 1) 
    createPlatforms("extendedmap.csv");
  else if (r == 2)
    createPlatforms("extendedmap1.csv");
  else 
    createPlatforms("extendedmap1.csv");
}

  
void keyPressed(){
  if(keyCode == RIGHT)
    player.change_x = MOVE_SPEED;
  else if(keyCode == LEFT)
    player.change_x = -MOVE_SPEED;
  else if(keyCode == UP)
    player.change_y = -MOVE_SPEED;
  else if(keyCode == DOWN)
    player.change_y = MOVE_SPEED;
  else if(isGameOver && key == ' ')
    setup();
}

void keyReleased(){
  if(keyCode == RIGHT)
    player.change_x = 0;
  else if(keyCode == LEFT)
    player.change_x = 0;
  else if(keyCode == UP)
    player.change_y = 0;
  else if(keyCode == DOWN)
    player.change_y = 0;
    
}
