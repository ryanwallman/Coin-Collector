public class Player extends AnimatedSprite
{
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  
  public Player(PImage img, float scale)
  {
    super(img, scale);
    lives = 3;
    direction = RIGHT_FACING;
    onPlatform = false;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("playerleft.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("player.png");
    jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("jumpleft.png");
    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("jump.png");
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("walk2left.png");
    moveLeft[1] = loadImage("walk1left.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("walk2.png");
    moveRight[1] = loadImage("walk1.png");
    currentImages = standRight;
  }
  
  public void updateAnimation()
  {
    onPlatform = isOnPlatforms(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }
  
  public void selectDirection()
  {
    if(change_x > 0)
    {
      direction = RIGHT_FACING;
    }
    else if(change_x < 0)
    {
       direction = LEFT_FACING;
    }
  }
  
  public void selectCurrentImages()
  {
    if(direction == RIGHT_FACING)
    {
      if(inPlace)
      {
        currentImages = standRight;
      }
      else if(!onPlatform)
      {
        currentImages = jumpRight;
      }
      else
      {
        currentImages = moveRight;
      }
    }
    else if(direction == LEFT_FACING)
    {
      if(inPlace)
      {
        currentImages = standLeft;
      }
      else if(!onPlatform)
      {
        currentImages = jumpLeft;
      }
      else
      {
        currentImages = moveLeft;
      }
    }
  }
}
