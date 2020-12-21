
class ProcessingTree {
  PVector pos;
  float theta, angle=45;  
  color col=color(255);
  float size = 50;
  
  ProcessingTree(PVector position) {
    pos = position.get();
  }
  
  void display(){
  stroke(col);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  //float a = (mouseX / (float) width) * 90f;
  //float a = cos(2*PI*0.2*millis()/1000)*90f; 
  // Convert it to radians
  theta = radians(angle);
  // Start the tree from the bottom of the screen
  translate(pos.x,pos.y);
  // Draw a line 120 pixels
  line(0,0,0,-size);
  // Move to the end of that line
  translate(0,-size);
  // Start the recursive branching!
  branch(size);
}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}

}
