import "package:balancedtrees/bplustree/bplustree.dart";
import "package:flutter_test/flutter_test.dart";
import "package:balancedtrees/avltree/avltree.dart";


void testMinAndMaxForEachLeafNode<K>(BPlusTree<K> bptree){
  BPlusNode<K> startNode = bptree.leftMostLeafNode;

  while(startNode!=null){
    var actual = [startNode.node.internalCellTree.min.key.key,startNode.node.internalCellTree.max.key.key];
    var expected = [AVLTreeAlgos.findMin(startNode.node.internalCellTree, recalculate: true).key.key, AVLTreeAlgos.findMax(startNode.node.internalCellTree, recalculate: true).key.key];
    expect(actual, expected);
    startNode = startNode.node.rightSibling;
  }
}
///Performs test for a tree whether its level has expected output.
///root is level 0
treeAllLevelTester({String message="NO_MESSAGE", BPlusTree<String> bptree,List<List<String>> level_list}){
  var levelStartNode = bptree.root;
  var i=0;
  while(levelStartNode!=null){
    var level = level_list[i];
    _singleLevelTester(levelStartNode: levelStartNode, levelExpectedItemsList: level, levelIndex : i );
    levelStartNode= levelStartNode.node.leftMostChild;
    i++;
  }
}


///Single levle tester
_singleLevelTester({BPlusNode<String> levelStartNode, List<String> levelExpectedItemsList, int levelIndex}){
  int c= 0;
  //check size at each level matches
  var t1=  levelStartNode;
  var t1_size=0;
  while(t1!=null){
    var t2= t1.node.internalCellTree.size;
    if(t2==0 && t1.node.leftMostChild!=null){
      t2=1;
    }
    t1_size+=t2;
    t1 = t1.node.rightSibling;
  }
  expect(t1_size, levelExpectedItemsList.length, reason: "Size mismatch at level $levelIndex");

  while(levelStartNode!=null){
    var itr = AVLTreeIterator<BPlusCell<String>>(tree: levelStartNode.node.internalCellTree);
    while(itr.hasSomeMoreItems()){
      expect(itr.next().key.key, levelExpectedItemsList[c], reason: "Problem at level $levelIndex");
      c++;
    }
    levelStartNode= levelStartNode.node.rightSibling;
  }
}

///Single levle tester
int _singleLevelSize({BPlusNode<String> levelStartNode}){
  int c= 0;
  while(levelStartNode!=null){
    c+=levelStartNode.node.internalCellTree.size;
    levelStartNode= levelStartNode.node.rightSibling;
  }
  return c;
}

int getLeafLevelSize({BPlusTree<String> bptree}){
var levelStartNode = bptree.root;
while(levelStartNode!=null&& !levelStartNode.node.isLeaf){
levelStartNode= levelStartNode.node.leftMostChild;
}
return _singleLevelSize(levelStartNode: levelStartNode);
}


///Prints BPLus tree beautifully: DO NOT CHANGE THIS, create one for your own if needed
printBPlusTree<K>({BPlusTree<K> bptree, String message="NO_MESSAGE"}){
  StringBuffer sb = StringBuffer();
  sb.write(message);
  sb.write("\n");
  var startNode = bptree.root;
  do{
    BPlusNode<K> level_seed = startNode;
    int cells =0;
    int nodes =0;
    do{
      sb.write("[$level_seed] ");
      cells = cells+ level_seed.node.internalCellTree.size;
      nodes = nodes +1;
      level_seed = level_seed.node?.rightSibling;
    }while(level_seed!=null);
    startNode = startNode.node?.leftMostChild;
    int total = cells+nodes;
    sb.write(" <$total>");
    sb.write("\n");
  }while(startNode!=null);
  sb.write("_________________________________________\n");

  print(sb.toString());
}

//root's level is 0
internalTreeSize_atLevel_Tester(BPlusTree<String> bptree, {int level=-1}){
  var levelStartNode = bptree.root;
  int i=0;
  while(levelStartNode!=null&& !levelStartNode.node.isLeaf){
    if(i==level){
      break;
    }
    levelStartNode= levelStartNode.node.leftMostChild;
    i++;
  }
  var leftMostLeafNode = levelStartNode;
  while(leftMostLeafNode!=null){
    if(leftMostLeafNode.node.internalCellTree.size != AVLTreeAlgos.reCalculateSize(startNode: leftMostLeafNode.node.internalCellTree.root)){
      throw "TreeSize mismatch on level:${level} in node: ${leftMostLeafNode.node.my_id} \n $leftMostLeafNode";
    }
    leftMostLeafNode=leftMostLeafNode.node.rightSibling;
  }
}


///Pretty print binary tree:  DO NOT CHANGE THIS, create one for your own if needed: ex: print(preorderTraversalPrettyTreeView(nodeWithCellDeleted.internalCellTree, prefix:"",postfix:"|", showStats: true ))
String preorderTraversalPrettyTreeView<K>(AVLTree<K> tree,{String prefix="|----", String postfix ="\n", bool showStats=false}){
  var result="";

  var sb = StringBuffer();

  AVLTreeNode<K> current=tree.root;
  var stack =<AVLTreeNode<K>>[current];
// sb.write(TAB*level);sb.write(current.key.toString());sb.write(NEWLINE);
  int n = 0;
  var space_stack = <int>[n];

  while(stack.isNotEmpty){
    while(current!=null){
      stack.add(current);
      space_stack.add(n);
      sb.write(prefix*n);sb.write(current.key.toString());sb.write(postfix);
      current=current.left;
      n++;
    }
    current=stack.removeLast().right;
    n= space_stack.removeLast()+1;
  }
  if(showStats){
    var c = tree.size;//claimed size
    var a = AVLTreeAlgos.reCalculateSize(startNode: tree.root);//actual size
    var stats = "Stats: C: $c, A: $a\n";
    result=stats;
  }


  return result+sb.toString();
}

String getTreeInfoFromIterator <K>(AVLTreeIterator<K> itr){
  int s =0;
  var l = <K>[];
  while(itr.hasSomeMoreItems()){
    l.add(itr.next().key);
    s++;
  }
  return "NoOfItertion: $s, ${l.join('|')}";
}