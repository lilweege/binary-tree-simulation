import java.util.Collection;

final int fontSize = 32;
final int charW = fontSize / 2;
final int charH = fontSize;
final int panelWidth = 240;

Integer insertVal = 0;
Integer removeVal = 0;
BST<Integer> tree;
HashMap<BST.Node, Boid> boids;
Button[] buttons;

void setup () {
  textFont(createFont("FSEX300.TTF", fontSize));
  size(1040, 650);
  int padding = 20;
  buttons = new Button[9];
  buttons[0] = new Button(width - panelWidth + padding,         padding,              200,                 70, "reset");
  buttons[1] = new Button(width - panelWidth + padding,         70 + 2 * padding,     200,                 70, "generate");
  buttons[2] = new Button(width - panelWidth + padding,         2 * 70 + 3 * padding, 200,                 70, "traverse");
  buttons[3] = new Button(width - panelWidth + padding,         3 * 70 + 4 * padding, 200,                 70, "insert: 0");
  buttons[4] = new Button(width - panelWidth + padding,         4 * 70 + 5 * padding, (200 - padding) / 2, 70, "/\\");
  buttons[5] = new Button(width - panelWidth / 2 + padding / 2, 4 * 70 + 5 * padding, (200 - padding) / 2, 70, "\\/");
  buttons[6] = new Button(width - panelWidth + padding,         5 * 70 + 6 * padding, 200,                 70, "remove: 0");
  buttons[7] = new Button(width - panelWidth + padding,         6 * 70 + 7 * padding, (200 - padding) / 2, 70, "/\\");
  buttons[8] = new Button(width - panelWidth / 2 + padding / 2, 6 * 70 + 7 * padding, (200 - padding) / 2, 70, "\\/");

  tree = new BST();
  boids = new HashMap<BST.Node, Boid>();
}

float dist_squared(float x1, float y1, float x2, float y2) {
  return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
}

void generate() {
  final int n = 25;
  Integer[] nums = new Integer[n];
  for (int i = 0; i < n; i++) {
    nums[i] = i;
  }
  for (int i = n - 1; i >= 0; i--) {
    int j = floor(random(i));
    Integer temp = nums[i];
    nums[i] = nums[j];
    nums[j] = temp;
  }
  
  reset();
  for (Integer num : nums) {
    insertNode(num);
  }
}

void reset() {
  // lowe the garbage collector
  tree = new BST();
  boids.clear();
  selectedEdge = -1;
}

void insertNode(Integer val) {
  BST.Node node = tree.insert(val);
  if (node != null) {
    Boid boid = new Boid(node, (width - panelWidth) / 2, height / 2);
    boids.put(node, boid);
  }
}

void removeNode(Integer val) {
  BST.Node node = tree.remove(val);
  if (node != null) {
    boids.remove(node);
  }
}

void traverse() {
  //println(tree.path());
  if (++selectedEdge == tree.size()) {
    selectedEdge = -1;
  }
}

void changeInsertVal(int change) {
  insertVal += change;
  buttons[3].text = "insert: " + insertVal;
  selectedEdge = -1;
}

void changeRemoveVal(int change) {
  removeVal += change;
  buttons[6].text = "remove: " + removeVal;
  selectedEdge = -1;
}

void mouseReleased(MouseEvent event) {
  for (int i = 0; i < buttons.length; i++) {
    if (buttons[i].intersecting()) {
      switch (i) {
      case 0: reset(); break;
      case 1: generate(); break;
      case 2: traverse(); break;
      case 3: insertNode(insertVal); break;
      case 4: changeInsertVal(1); break;
      case 5: changeInsertVal(-1); break;
      case 6: removeNode(removeVal); break;
      case 7: changeRemoveVal(1); break;
      case 8: changeRemoveVal(-1); break;
      default: break;
      }
      return;
    }
  }
}


int selectedEdge = -1;
void draw() {
  background(127, 127, 127);


  int i = 0;
  for (BST.Edge e : tree.path()) {
    Boid b1 = boids.get(e.parent);
    Boid b2 = boids.get(e.child);
    PVector p1 = b1.position;
    PVector p2 = b2.position;
    if (i == selectedEdge)
      stroke(0, 255, 0);
    else if (i < selectedEdge)
      stroke(255, 0, 0);
    else
      stroke(0);
    strokeWeight(1);
    float d_sq = dist_squared(p1.x, p1.y, p2.x, p2.y);
    //println(d_sq);
    strokeWeight(min(5, 50000/d_sq));
    line(p1.x, p1.y, p2.x, p2.y);
    i++;
  }

  for (Boid boid : boids.values()) {
    boid.flock(boids);
  }
  
  for (Boid boid : boids.values()) {
    boid.update();
    boid.show();
  }
  
  
  fill(100);
  noStroke();
  rect(width - panelWidth, 0, panelWidth, height);
  for (Button button : buttons) {
    button.show();
  }
}
