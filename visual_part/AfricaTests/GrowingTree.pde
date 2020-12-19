// A GrowingTree is made of segments from the class Segment. 
// It grows or decreases randomly, parametered by a probability p.

int h = 10; // Length of branches

class GrowingTree {
  
  PVector pos; // Position
  float p; // Probability to build a segment, 1-p = probability to destroy a segment
  ArrayList<Segment> list_segment = new ArrayList<Segment>();
  float theta; // Must be PI/3 to go to the right, 2PI/3 to go to the left

  GrowingTree(PVector position, float theta_direction) {
    pos = position.get();
    Segment segment1 = new Segment(pos.x,pos.y,pos.x+h,pos.y+h);
    list_segment.add(segment1); // Root of the tree
    p = 0.90; // Initially, we want the tree to expand. p can decrease later if we want the tree to destroy many of it segments.
    theta = theta_direction;
  }
  
  
  // ----------- FUNCTIONS -----------
  
  void build_segment(){
    theta = theta*(2*int(random(1.99))-1); // Either +theta or -theta
    Segment parent_seg = list_segment.get(int(random(list_segment.size()-1))); // Pick a random parent
    Segment new_segment = new Segment(parent_seg.x1,parent_seg.y1,parent_seg.x1+h*cos(theta),parent_seg.y1+h*sin(theta));
    parent_seg.children.add(new_segment); // Label the segment as a parent segment
    list_segment.add(new_segment);
  }
  
  void destroy_random_segment(){
    int k=list_segment.size()-1;
    float c = 0;
    Segment segment = list_segment.get(0); // Get segment
    while((k>=0)&&(c==0)){
      segment=list_segment.get(k); // Get segment
      if (segment.children.size()==0){ // We can delete a segment only if is doesn't have children
        list_segment.remove(segment);
        c++; // Stop the loop
      }
      k--;
    }
    // Update the lists of children of the other segments
    for(int l=list_segment.size()-1; l>=0; l--){
      Segment segment_to_check=list_segment.get(l);
      segment_to_check.children.remove(segment);
      }    
   }

  void evolve(){   // Build or destroy a segment
    float i = random(1);
    if ((i>p)&&(list_segment.size()>20)){
      destroy_random_segment();
    }
    else{
      build_segment();
    }
  }
  
  void display(){ // Display every segment of the tree
    evolve();
    for(int i=this.list_segment.size()-1; i>=0; i--){
      Segment segment=list_segment.get(i);
      segment.display();
    }
  }
  
}
