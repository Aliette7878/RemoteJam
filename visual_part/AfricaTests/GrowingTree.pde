// A GrowingTree is made of segments from the class Segment. 
// It grows or decreases randomly, parametered by a probability p.

int h = 15; // Length of branches
int lifespan = 20; // Lifespan in frames
int min_size = 80; // We don't destroy semgents below min_size


class GrowingTree {
  
  PVector pos; // Position
  float p; // Probability to build a segment, 1-p = probability to destroy a segment
  ArrayList<Segment> list_segment = new ArrayList<Segment>();
  float theta; // Must be PI/3 to go to the right, 2PI/3 to go to the left
  color col;

  GrowingTree(PVector position, float theta_direction, color color_tree) {
    pos = position.get();
    p = 0.60; // Initially, we want the tree to expand. p can decrease later if we want the tree to destroy many of it segments.
    theta = theta_direction;
    col = color_tree;
    Segment segment1 = new Segment(pos.x,pos.y,pos.x+h,pos.y+h, col);
    list_segment.add(segment1); // Root of the tree
  }
  
  
  // ----------- FUNCTIONS -----------
  
  void build_segment(){
    theta = theta*(2*int(random(1.99))-1); // Either +theta or -theta
    Segment parent_seg = list_segment.get(int(random(list_segment.size()-1))); // Pick a random parent
    Segment new_segment = new Segment(parent_seg.x1,parent_seg.y1,parent_seg.x1+h*cos(theta),parent_seg.y1+h*sin(theta), col);
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
   }
   
  void update_tree(Segment destroyed_child){ //Remove the destroyed child and the old segments
    // Update the lists of children of the other segments
    for(int l=list_segment.size()-1; l>=0; l--){
      Segment segment=list_segment.get(l);
      segment.children.remove(destroyed_child);
      if(segment.age>lifespan){list_segment.remove(segment);}
      } 
  }

  void evolve(){   // Build or destroy a segment
    float i = random(1);
    if ((i>p)&&(list_segment.size()>min_size)){ //  if the tree is not too small + random
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


class GrowingArray{
  
  ArrayList<GrowingTree> list_growingtree = new ArrayList<GrowingTree>();
  float angle,x, y; // Direction of expansion
  int  n, d;
  color col;

  GrowingArray(int inx, int iny,int nb_tree, int distance,float angle, color col_array) {
    d = distance;
    theta = angle;
    n = nb_tree;
    col = col_array;
    x = inx; // Root of the tree
    y = iny; // Initially, we want the tree to expand. p can decrease later if we want the tree to destroy many of it segments.
    for(int i=0; i<n; i++){
      list_growingtree.add(new GrowingTree(new PVector(x,y+i*d),angle, col_array));
    }
  }
  
  void display(){
    for(int i=0; i<n; i++){
      GrowingTree tree = list_growingtree.get(i);
      tree.display();  }
}
}
