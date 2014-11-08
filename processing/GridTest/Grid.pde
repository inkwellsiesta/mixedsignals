class Grid {
   
  private class Cell {
    PVector pos;
    float w,h;
    
    color c; // color
    float pn; // perlin noise
    
    Cell(int i, int j, 
         float _w, float _h) {
      pos = new PVector(i*_w, j*_h);
      w = _w;
      h = _h;
    }
    
    void setColor(color _c) {
      c = _c;
    }
    
  };
  
  private class Marker {
    PVector vel; // velocity
  };
  
  int w = width;
  int h = height;
  
  int ncols = 200;
  int nrows = 300;
  
  float w_cell = (float)w/(float)ncols;
  float h_cell = (float)h/(float)nrows;
  
  Cell[][] cells = new Cell[ncols][nrows];
  Marker[][] markers = new Marker[ncols-1][nrows-1];
  
  Grid() {
    // set perlin noise and color of cells
    for (int row = 0; row < nrows; ++row) {
      for (int col = 0; col < ncols; ++col) {
        Cell cell = new Cell(col, row,
                                  (float)w/ncols, (float)h/nrows);
         cell.pn = noise((float)col/ncols*10, (float)row/nrows*10);
         cell.c = color((cell.pos.x/w*128 + 175)%256, 200, 200);                                  
        cells[col][row] = cell;
      }
    }
    // set velocity of markers
    for (int row = 0; row < nrows-1; ++row) {
      for (int col = 0; col < ncols-1; ++col) {
        Marker marker = new Marker();
        marker.vel = new PVector((cells[col][row+1].pn - cells[col][row].pn)/w_cell, 
                           (cells[col][row].pn - cells[col+1][row].pn)/h_cell);
        marker.vel.mult(3000);
        markers[col][row] = marker;
      }
     }
  }
  
  public void update(float velocity_multiplier) {
    for (int row = 0; row < nrows-1; ++row) {
      for (int col = 0; col < ncols-1; ++col) {
        markers[col][row].vel.mult(velocity_multiplier);
      }
    }
    float dt = 1/frameRate;
    color new_colors[][] = new color[ncols][nrows];
    PVector new_vels[][] = new PVector[ncols][nrows];
    for (int row = 0; row < nrows; ++row) {
      for (int col = 0; col < ncols; ++col) {
        Cell cell = cells[col][row];
        PVector cell_vel;
        if (row == 0) {    // interpolation to find cell values from markers
          if (col == 0) {  // my goodness this is ugly
            cell_vel = markers[col][row].vel;
          }
          else if (col == ncols-1) {
            cell_vel = markers[col-1][row].vel;
          }
          else {
            cell_vel = PVector.mult(PVector.add(markers[col-1][row].vel, markers[col][row].vel), .5);
          } // end col if statement (first row)
        }
        else if (row == nrows-1) {
          if (col == 0) {
            cell_vel = markers[col][row-1].vel;
          }
          else if (col == ncols-1) {
            cell_vel = markers[col-1][row-1].vel;
          }
          else {
            cell_vel = PVector.mult(PVector.add(markers[col-1][row-1].vel, markers[col][row-1].vel), .5);
          } // end col if statement (last row)
        } 
        else { 
          if (col == 0) {
            cell_vel = PVector.mult(PVector.add(markers[col][row-1].vel, markers[col][row].vel), .5);
          }
          else if (col == ncols-1) {
            cell_vel = PVector.mult(PVector.add(markers[col-1][row-1].vel, markers[col-1][row].vel), .5);
          }
          else {
            PVector upper_vel = PVector.mult(PVector.add(markers[col-1][row].vel, markers[col][row].vel), .5);
            PVector lower_vel = PVector.mult(PVector.add(markers[col-1][row-1].vel, markers[col][row-1].vel), .5);
            cell_vel = PVector.mult(PVector.add(upper_vel, lower_vel), .5);
          } // end col if statement (middle rows)
        } // end row if statment
        
        PVector cellpos_old = PVector.sub(cell.pos, PVector.mult(cell_vel, dt));
        int col_old = round(cellpos_old.x/cell.w);                                    
        float col_t = cellpos_old.x/cell.w - col_old; // TODO: use this for interpolation
        col_old = min(col_old, ncols-1);
        col_old = max(col_old, 0);
        int row_old = round(cellpos_old.y/cell.h);
        float row_t = cellpos_old.y/cell.h - row_old; // TODO: use this for interpolation
        row_old = min(row_old, nrows-1);
        row_old = max(row_old, 0);
        new_colors[col][row] = cells[col_old][row_old].c;
        if (col_old == ncols - 1) {
          if (row_old == nrows - 1) {
            new_vels[col][row] = markers[col_old-1][row_old-1].vel;
          }
          else {
            new_vels[col][row] = markers[col_old-1][row_old].vel;
          }
        }
        else {
           if (row_old == nrows - 1) {
            new_vels[col][row] = markers[col_old][row_old-1].vel;
          }
          else {
            new_vels[col][row] = markers[col_old][row_old].vel;
          }
        }
      } 
    }
    for (int row = 0; row < nrows; ++row) {
      for (int col = 0; col < ncols; ++col) {
        cells[col][row].c = new_colors[col][row];
        if (row < nrows-1 && col < ncols-1) {
          PVector upper_vel = PVector.mult(PVector.add(new_vels[col][row+1], new_vels[col+1][row+1]), .5);
          PVector lower_vel = PVector.mult(PVector.add(new_vels[col][row], new_vels[col+1][row]), .5);
          markers[col][row].vel = PVector.mult(PVector.add(upper_vel, lower_vel), .5);
        }
      }
    }
  }
  
  
 
   public void draw() {
     noStroke();
     for (int row = 0; row < nrows; ++row) {
       for (int col = 0; col < ncols; ++col) {
         Cell cell = cells[col][row];
         fill(cell.c);
         rect(cell.pos.x, cell.pos.y, cell.w, cell.h);
       }
     }
   }
  
}
