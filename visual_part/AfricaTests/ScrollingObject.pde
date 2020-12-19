
class ScrollingObject {
  PImage img;
  int dir; // 1 if going to the left, 0 if going to the right
  int inx;
  int iny;

  // Create a "bloop" creature
  ScrollingObject(PImage image, int direction, int initialx, int initialy) {
    img = image.get();
    dir = direction;
    inx=initialx;
    iny=initialy;
  }
  
  void scroll() {
    int x = int(frameCount) % img.width; 
    for (int i = -x ; i < width ; i += img.width) {
      int j=i;
      if (dir==0){j=-i;};
      copy(img, inx, 0, img.width, height, inx+j, iny, img.width, height); // Copies the image from (0,0) to (i,0)
      }
    }
    
}
