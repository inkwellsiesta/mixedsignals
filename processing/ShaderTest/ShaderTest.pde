PShader shad;
int ncols, nrows, dheight, dwidth;
Grid grid;
PShape gridShape;

void setup() {
  size(701, 401, P2D);
  noStroke();
  fill(0);
  shad = loadShader("frag.glsl", "vert.glsl");
  shad.set("resolution", float(width), float(height));
  nrows = 70;
  ncols = 40;
  grid = new Grid(ncols, nrows);
  
  gridShape = grid.createGrid();

}

void draw() {
  println(frameRate);
  float x = mousePressed ? map(mouseX, 0, width, 0, 1) : -1.f;
  float y = mousePressed ? map(mouseY, 0, height, 1, 0) : -1.f;
  shad.set("mouse", x, y);
  
  shape(gridShape);
  shader(shad);
}

void mousePressed() {
  shad.set("rColor", random(1));
  shad.set("gColor", random(1));
  shad.set("bColor", random(1));
}


