Quadtree quadtree;

void setup() {
  size(400, 400);

  Square boundary = new Square(200, 200, 200, 200);
  quadtree = new Quadtree(boundary, 4);

  for (int i = 0; i < 750; i++) {
    Point p = new Point(random(width), random(height));
    quadtree.addPoint(p);
  }
}

void draw() {
  background(245);
  quadtree.show();
}

class Point {
  float x, y;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Square {
  int x, y, w, h, leftBoundary, rightBoundary, topBoundary, botBoundary;

  Square(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.leftBoundary = this.x - this.w;
    this.rightBoundary = this.x + this.w;
    this.topBoundary = this.y - this.h;
    this.botBoundary = this.y + this.h;
  }

  boolean has(Point p) {
    // troll parameter checking lmao
    return (p.x >= leftBoundary && p.x <= rightBoundary && p.y >= topBoundary && p.y <= botBoundary);
  }
}

class Quadtree {
  Square boundary;
  int n;
  ArrayList<Point> points = new ArrayList<Point>();
  boolean divided = false;
  Quadtree ne, se, sw, nw;
  
  Quadtree(Square boundary, int n) {
    this.boundary = boundary;
    this.n = n;
  }
  
  //creating squares within squares
  void divide() {
    int x = this.boundary.x;
    int y = this.boundary.y;
    int w = this.boundary.w;
    int h = this.boundary.h;
    Square ne = new Square(x + w / 2, y - h / 2, w / 2, h / 2);
    Square se = new Square(x + w / 2, y + h / 2, w / 2, h / 2);
    Square sw = new Square(x - w / 2, y + h / 2, w / 2, h / 2);
    Square nw = new Square(x - w / 2, y - h / 2, w / 2, h / 2);
    this.ne = new Quadtree(ne, this.n);
    this.se = new Quadtree(se, this.n);
    this.sw = new Quadtree(sw, this.n);
    this.nw = new Quadtree(nw, this.n);
  }
  
  // recursive function to form the squares
  boolean addPoint(Point p) {
    // special case if it doesn't have a point
    if (!this.boundary.has(p)) {
      return false;
    }

    if (n > points.size()) {
      points.add(p);
      return true;
    } else {
      if (!this.divided) {
        this.divided = true;
        this.divide(); // divide
      }
      if (this.ne.addPoint(p)) {
        return true;
      } else if (se.addPoint(p)) {
        return true;
      } else if (sw.addPoint(p)) {
        return true;
      } else if (nw.addPoint(p)) {
        return true;
      }
    }
    return false;
  }

  void show() {
    stroke(0, 0, 225);
    noFill();
    strokeWeight(0.5);
    rectMode(CENTER);
    rect(this.boundary.x, this.boundary.y, this.boundary.w * 2, this.boundary.h * 2);
    for (Point p : this.points) {
      stroke(0);
      strokeWeight(1);
      circle(p.x, p.y, 3);
    }

    if (divided) {
      this.ne.show();
      this.nw.show();
      this.se.show();
      this.sw.show();
    }
  }
}
