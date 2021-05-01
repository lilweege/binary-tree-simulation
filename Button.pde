
class Button {
  int x, y, w, h;
  String text;
  Button(int x, int y, int w, int h, String text) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
  }
  
  void show() {
    color buttonCol = color(255, 255, 255);
    boolean hovering = this.intersecting();
    if (hovering) {
      if (mousePressed)
        buttonCol = color(0, 255, 0);
      else
        buttonCol = color(200, 200, 200);
    }
    
    stroke(0);
    strokeWeight(4);
    fill(buttonCol);
    rect(this.x, this.y, this.w, this.h, 20);
    
    int strW = this.text.length() * charW;
    int strH = charH; // assume one line
    fill(0);
    textSize(fontSize);
    text(this.text, this.x + (this.w - strW) / 2, this.y + (this.h - strH) / 2, this.w, this.h);
  }
  
  boolean intersecting() {
    return this.intersecting(mouseX, mouseY);
  }
  
  boolean intersecting(int px, int py) {
    int rx = this.x,
        ry = this.y,
        rw = this.w,
        rh = this.h;
    return (rx <= px && px <= rx + rw) && (ry <= py && py <= ry + rh);
  }
}
