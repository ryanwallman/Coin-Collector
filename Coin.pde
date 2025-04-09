public class Coin extends AnimatedSprite
{
  public Coin(PImage img, float scale)
  {
    super(img, scale);
    standNeutral = new PImage[8];
    
    standNeutral[0] = loadImage("coin_01.png");
    standNeutral[1] = loadImage("coin_02.png");
    standNeutral[2] = loadImage("coin_03.png");
    standNeutral[3] = loadImage("coin_04.png");
    standNeutral[4] = loadImage("coin_05.png");
    standNeutral[5] = loadImage("coin_06.png");
    standNeutral[6] = loadImage("coin_07.png");
    standNeutral[7] = loadImage("coin_08.png");
    
    currentImages = standNeutral;
  }
  public void advanceToNextImage()
  {
    index++;
    if(index == currentImages.length)
    {
      index = 0;
    }
    image = currentImages[index];
  }
}
