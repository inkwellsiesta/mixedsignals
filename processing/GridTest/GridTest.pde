Grid grid; //= new Grid();
int i = 0;

void setup() {
  colorMode(HSB);
  grid = new Grid();
  size(grid.w, grid.h, P3D);
  frameRate(5);
  
}
  


void draw() {
  ++i;
  float velocity_multiplier = cos(i) + 1.24;
  println(velocity_multiplier);
  grid.update(velocity_multiplier);
  grid.draw();
  //saveFrame("frames/####.png");
}
