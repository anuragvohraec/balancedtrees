import "package:balancedtrees/bplustree/bplustree.dart";
import "package:balancedtrees/avltree/avltree.dart";

void debugHelper<K>(BPlusNode<K> source, BPlusNode<K> target, K keyWorkedUpon, String operation) {
  if (source.node.my_id == 753235 || target.node.my_id == 753235) {
    print(
        """${target.node.my_id == 753235 ? 'Target[${target.node.my_id}] ${target.node.isLeaf ? "is Leaf" : ""}' : 'Source[${source.node.my_id}] ${source.node.isLeaf ? "is Leaf" : ""}'} [$operation] Key[$keyWorkedUpon],  ${target.node.my_id == 753235 ? (target.node.parentCell == null && target.node is LeftMostNode<K> ? "is LMC" : "") : (source.node.parentCell == null && source.node is LeftMostNode<K>? "is LMC" : "")}
        ${target.node.my_id == 753235 ? target: source}"""
    );
  }
}

///Prints BPLus tree beautifully: DO NOT CHANGE THIS, create one for your own if needed
printBPlusTree<K>({BPlusTree<K> bptree, String message = "NO_MESSAGE"}) {
  StringBuffer sb = StringBuffer();
  sb.write(message);
  sb.write("\n");
  var startNode = bptree.root;
  do {
    BPlusNode<K> level_seed = startNode;
    int cells = 0;
    int nodes = 0;
    do {
      sb.write("[$level_seed] ");
      cells = cells + level_seed.node.internalCellTree.size;
      nodes = nodes + 1;
      level_seed = level_seed.node?.rightSibling;
    } while (level_seed != null);
    startNode = startNode.node?.leftMostChild;
    int total = cells + nodes;
    sb.write(" <$total> \n");
  } while (startNode != null);
  sb.write("_________________________________________\n");

  print(sb.toString());
}

///Pretty print binary tree:  DO NOT CHANGE THIS, create one for your own if needed: ex: print(preorderTraversalPrettyTreeView(nodeWithCellDeleted.internalCellTree, prefix:"",postfix:"|", showStats: true ))
String preorderTraversalPrettyTreeView<K>(AVLTree<K> tree,
    {String prefix = "|----", String postfix = "\n", bool showStats = false}) {
  var result = "";

  var sb = StringBuffer();

  AVLTreeNode<K> current = tree.root;
  var stack = <AVLTreeNode<K>>[current];
// sb.write(TAB*level);sb.write(current.key.toString());sb.write(NEWLINE);
  int n = 0;
  var space_stack = <int>[n];

  while (stack.isNotEmpty) {
    while (current != null) {
      stack.add(current);
      space_stack.add(n);
      sb.write(prefix * n);
      sb.write(current.key.toString());
      sb.write(postfix);
      current = current.left;
      n++;
    }
    current = stack.removeLast().right;
    n = space_stack.removeLast() + 1;
  }
  if (showStats) {
    var c = tree.size; //claimed size
    var a = AVLTreeAlgos.reCalculateSize(startNode: tree.root); //actual size
    var stats = "Stats: C: $c, A: $a\n";
    result = stats;
  }

  return result + sb.toString();
}

String getTreeInfoFromIterator<K>(AVLTreeIterator<K> itr) {
  int s = 0;
  var l = <K>[];
  while (itr.hasSomeMoreItems()) {
    l.add(itr.next().key);
    s++;
  }
  return "NoOfItertion: $s, ${l.join('|')}";
}
