class BodyPart {
  PShape svg; // Image
  int w, h; // Dimensions
  color col = color(255, 10, 10);
  float posX, posY;

  BodyPart(String file_name) {
    svg = loadShape(file_name);
    float scale = 0.15;
    svg.scale(scale);  // TODO: erase this line
    w = int(svg.width*scale); 
    h = int(svg.height*scale*0.98);
  }

  void SetOriginalPosition(PVector originalPosition) {
    posX = originalPosition.x;
    posY = originalPosition.y;
  }

  void DrawBodyPart(float shiftX, float shiftY, float angle) {
    pushMatrix();
    translate(posX+shiftX, posY+shiftY);
    if (angle != 0) {
      rotate(angle);
    }
    svg.disableStyle();
    fill(col);
    // each image is centered horizontally, but not vertically! its y coordinate will be the anchor of the top of the picture.
    shape(svg, -w/2, 0);
    popMatrix();
  }
}
