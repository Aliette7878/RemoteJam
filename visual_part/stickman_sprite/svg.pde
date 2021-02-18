class BodyPart {
  PShape svg; // Image
  int w, h; // Dimensions
  color col = color(255, 10, 10);

  BodyPart(String file_name) {
    svg = loadShape(file_name);
    svg.scale(1);  // TODO: erase this line
    w = int(svg.width); 
    h = int(svg.height);
  }

  void DrawBodyPart(PVector position, float angle, float scale) {
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    svg.disableStyle();
    fill(col);
    shape(svg, -scale*w/2, -scale*h);
    popMatrix();
  }
}
