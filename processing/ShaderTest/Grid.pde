class Grid {
  int ncols;
  int nrows;
  int dheight;
  int dwidth;
  PImage forceField;
  
  Grid(int nc, int nr) {
    ncols = nc;
    nrows = nr;
    dheight = height/nrows;
    dwidth = width/ncols;
    forceField = new PImage(width, height);
  }
  
  
  PShape createGrid() {
    PShape sh = createShape();
    sh.setFill(color(255,0,0));
    sh.beginShape(TRIANGLE_STRIP);
    int j = 0;
    for (int i = height; i > 0; i-= dheight) {
      for (j = max(0, min(width, j)); j <= width && j >= 0; j+= dwidth) {
        sh.vertex(j,i);
        sh.vertex(j,i-dheight);
      }
      dwidth*=-1; // toggle the direction that the rows are built
    }
    
    sh.texture(forceField);
    sh.endShape();
    return sh;
  
  }
}
