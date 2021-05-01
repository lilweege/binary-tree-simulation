// 2D "Boid"
// yoinked from my dawgz the coding train
// https://thecodingtrain.com/CodingChallenges/124-flocking-boids.html

class Boid {
  BST.Node node;
  PVector position;
  PVector velocity;
  PVector acceleration;
  int radius = 50;
  int maxForce;
  int maxSpeed;
  
  Boid(BST.Node node, int ix, int iy) {
    this.node = node;
    this.position = new PVector(ix, iy);

    this.velocity = PVector.random2D();
    this.velocity.setMag(random(2, 4));
    this.acceleration = new PVector();
    this.maxForce = 1;
    this.maxSpeed = 4;
  }

  void show() {
    String text = String.valueOf(node.obj);
    int strW = text.length() * charW;
    int strH = charH; // assume one line

    fill(255);
    stroke(0);
    strokeWeight(4);
    circle(this.position.x, this.position.y, this.radius);
    
    textSize(fontSize);
    fill(0);
    text(text, this.position.x - strW / 2, this.position.y + strH / 4);
  }


  void avoidEdges() {
    // this can be improved
    
    // clamp
    if (this.position.x > width - panelWidth) {
      this.position.x = width - panelWidth;
    } else if (this.position.x < 0) {
      this.position.x = 0;
    }
    if (this.position.y > height) {
      this.position.y = height;
    } else if (this.position.y < 0) {
      this.position.y = 0;
    }
    
    // steer
    int steerDist = 50;
    PVector steerForce = new PVector();
    if (this.position.x < 0 + steerDist) {
      steerForce.x = this.position.x;
    }
    else if (this.position.x > width - panelWidth - steerDist) {
      steerForce.x = this.position.x - width - panelWidth;
    }
    if (this.position.y < 0 + steerDist) {
      steerForce.y = this.position.y;
    }
    else if (this.position.y > height - steerDist) {
      steerForce.y = this.position.y - height;
    }
    
    this.acceleration.add(steerForce);
  }

  // I can't be bothered to come up with a better method name
  void springChildren(HashMap<BST.Node, Boid> boids) {
    // Hookes Law: F = -xk
    // attract and repel self from child depending on distance
    // apply to both boids because node relationship is one-way
    int idealDist = 100;
    float k = .0000001; // arbitrary
    if (node.left != null) {
      Boid other = boids.get(node.left);
      float d_sq = max(0.0001, dist_squared(this.position.x, this.position.y, other.position.x, other.position.y));
      PVector diff = PVector.sub(this.position, other.position);
      float x = d_sq - idealDist * idealDist;
      diff.mult(x * k);
      other.acceleration.add(diff);
      diff.mult(-1);
      acceleration.add(diff);
    }
    if (node.right != null) {
      Boid other = boids.get(node.right);
      PVector diff = PVector.sub(this.position, other.position);
      float d_sq = max(0.0001, dist_squared(this.position.x, this.position.y, other.position.x, other.position.y));
      float x = d_sq - idealDist * idealDist;
      diff.mult(x * k);
      other.acceleration.add(diff);
      diff.mult(-1);
      acceleration.add(diff);
    }
  }

  PVector separation(Collection<Boid> boids) {
    int perceptionRadius = 100;
    PVector steering = new PVector();
    int total = 0;
    for (Boid other : boids) {
      float d_sq = max(0.0001, dist_squared(this.position.x, this.position.y, other.position.x, other.position.y));
      // max(.0001, ...) avoid div by zero
      // square dist to reduce computation
      if (other != this && d_sq < perceptionRadius * perceptionRadius) {
        PVector diff = PVector.sub(this.position, other.position);
        diff.div(d_sq);
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(this.maxSpeed);
      steering.sub(this.velocity);
      steering.limit(this.maxForce);
    }
    return steering;
  }


  void flock(HashMap<BST.Node, Boid> boids) {
    PVector separation = this.separation(boids.values());
    separation.mult(.5);
    this.acceleration.add(separation);
    this.springChildren(boids);
  }

  void update() {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxSpeed);
    this.acceleration.mult(0);
    this.avoidEdges();
  }
}
