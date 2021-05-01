// yoinked from my ICS4U repository
// I made this class back in grade 12, but
// have modified it slightly since then

import java.util.ArrayList;

class BST<T extends Comparable<T>> {
  private Node root;
  private ArrayList<Edge> path = new ArrayList<>();

  private int size = 0;
  private boolean updatedPath = true;


  class Node {
    T obj;
    Node left;
    Node right;

    public Node(T obj) {
      this.obj = obj;
      left = null;
      right = null;
    }

    public String toString() {
      return String.valueOf(this.obj);
    }
  }

  class Edge {
    Node parent;
    Node child;

    public Edge(Node from, Node to) {
      this.parent = from;
      this.child = to;
    }

    public String toString() {
      return "{" + String.valueOf(this.parent) + ", " + String.valueOf(this.child) + "}";
    }
  }

  public BST() {
    this.root = null;
  }

  public BST(T root) {
    this.root = new Node(root);
    updatedPath = false;
    size = 1;
  }

  public BST(T[] arr) {
    for (T obj : arr)
      insert(obj);
    updatedPath = false;
    size = arr.length;
  }

  //	public BST(Collection<? extends T> c) {
  //		for (T obj : c)
  //			insert(obj);
  //	}


  //	public T trace(T obj) {
  //		Node cur = root;
  //
  //		while (cur != null) {
  //			System.out.print(cur.obj + " ");
  //			int comp = cur.obj.compareTo(obj);
  //			if (comp == 0) {
  //				System.out.println();
  //				return cur.obj;
  //			}
  //			else if (comp > 0) {
  //				cur = cur.left;
  //			}
  //			else if (comp < 0) {
  //				cur = cur.right;
  //			}
  //			System.out.print("-> ");
  //		}
  //		System.out.print("null");
  //		System.out.println();
  //		return null;
  //	}

  //	public T search(T obj) {
  //		Node cur = root;
  //
  //		while (cur != null) {
  //			int comp = cur.obj.compareTo(obj);
  //			if (comp == 0) {
  //				System.out.println();
  //				return cur.obj;
  //			}
  //			else if (comp > 0) {
  //				cur = cur.left;
  //			}
  //			else if (comp < 0) {
  //				cur = cur.right;
  //			}
  //		}
  //		return null;
  //	}

  //	public boolean contains(T obj) {
  //		return search(obj) != null;
  //	}

  public Node insert(T obj) {
    if (root == null) {
      root = new Node(obj);
      updatedPath = false;
      ++size;
      return root;
    }

    Node cur = root;
    Node par = null;

    while (true) {
      par = cur;

      int comp = cur.obj.compareTo(obj);
      if (comp == 0)
        return null;

      boolean smaller = comp > 0;
      cur = smaller ? cur.left : cur.right;
      if (cur == null) {
        updatedPath = false;
        ++size;
        if (smaller)
          return par.left = new Node(obj);
        else
          return par.right = new Node(obj);
      }
    }
  }


  public Node remove(T obj) {
    if (root == null)
      return null;
    
    Node par = root;
    Node cur = root;

    boolean isLeftChild = false;

    while (cur.obj != obj) {

      par = cur;

      int comp = cur.obj.compareTo(obj);

      if (comp > 0) {
        isLeftChild = true;
        cur = cur.left;
      } else if (comp < 0) {
        isLeftChild = false;
        cur = cur.right;
      }

      // case node does not exist in tree
      if (cur == null) {
        return null;
      }
    }



    // node exists in tree
    
    // case node has no children
    if (cur.left == null && cur.right == null) {

      // simply remove node
      if (cur == root) {
        root = null;
      }
      if (isLeftChild) {
        par.left = null;
      } else {
        par.right = null;
      }
    }


    // case node has only one child
    else if ((cur.right == null) != (cur.left == null)) {

      if (cur.right == null) {
        if (cur == root) {
          root = cur.left;
        } else if (isLeftChild) {
          par.left = cur.left;
        } else {
          par.right = cur.left;
        }
      } else if (cur.left == null) {
        if (cur == root) {
          root = cur.right;
        } else if (isLeftChild) {
          par.left = cur.right;
        } else {
          par.right = cur.right;
        }
      }
    }


    // case node has both children
    else if (cur.left != null && cur.right != null) {
      Node successor = null;
      Node successorParent = null;
      Node temp = cur.right;
      while (temp != null) {
        successorParent = successor;
        successor = temp;
        temp = temp.left;
      }

      if (successor != cur.right) {
        successorParent.left = successor.right;
        successor.right = cur.right;
      }

      if (cur == root) {
        root = successor;
      } else if (isLeftChild) {
        par.left = successor;
      } else {
        par.right = successor;
      }
      successor.left = cur.left;
    }

    updatedPath = false;
    --size;
    return cur;
  }


  private void inorderTraversal() {
    if (updatedPath)
      return;

    // TODO: make this more efficient
    path.clear();
    path.ensureCapacity(size - 1);

    inorderTraversal(null, root);
    updatedPath = true;
  }

  private void inorderTraversal(Node par, Node root) {
    if (root != null) {
      inorderTraversal(root, root.left);
      if (par != null)
        path.add(new Edge(par, root));
      inorderTraversal(root, root.right);
    }
  }


  public ArrayList<Edge> path() {
    inorderTraversal();
    return path;
  }

  public int size() {
    return size;
  }
}
