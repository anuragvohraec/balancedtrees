import "package:balancedtrees/avltree/avltree.dart";

int id=0;//TODO Remove this;

typedef ChangeNodeFunction<K>  = bool Function(BPlusNode<K> startNode, Compare<K> compare);

//cell in a BPlusTree
class BPlusCell<K>{
  K key;
  dynamic _value;
  //carries only rightmost childNode's link
  BPlusNode<K> rightChildNode;

  //node in which this cell resides;
  BPlusNode<K> homeNode;

  BPlusCell({this.key});

  V getValue<V>(){
    return (_value as V);
  }

  setValue<V>(V newValue){
    _value= newValue;
  }

  @override
  String toString() {
    return key.toString();
  }
}

//Uniform Wrapper around node
class BPlusNode<K>{
  Node<K> node;

  BPlusNode({this.node});

  @override
  String toString() {
    // TODO: implement toString
    return node.toString();
  }
}

///BPlusTree's node, which contains cells
///
/// <a href="https://imgbb.com/"><img src="https://i.ibb.co/mcvWX2p/image.png" alt="BPlusNode" border="0"></a>
///
class Node<K>{

  BPlusNode<K> leftMostChild;

  BPlusNode<K> rightSibling;
  ///required for merging and redistributing while deletion operation
  BPlusNode<K> leftSibling;

  ///required for merging and redistributing while deletion operation
  ///if its null than it must be pointed by the parent Node leftMostNode pointer or must be root [if parentNode is null as well]
  BPlusCell<K> parentCell;

  AVLTree<BPlusCell<K>>  internalCellTree;
  bool isLeaf;

  Compare<K> compare;

  int my_id;//TODO remove this only for testing


  ///BPlusTree's node, which contains cells
  Node({this.isLeaf=false, this.compare}){
    internalCellTree = AVLTree<BPlusCell<K>>(compare: (BPlusCell<K> c1, BPlusCell<K> c2){
      return compare(c1.key, c2.key);
    });
    id++;//TODO remove this only for testing
    my_id=id;//TODO remove this only for testing
  }

  Node.fromLeftNode(BPlusNode<K> leftNodeCont, K keyWorkedUpon){
    LeftMostNode<K> leftNode = leftNodeCont.node;
    my_id = leftNode.my_id;

    isLeaf =leftNode.isLeaf;
    compare = leftNode.compare;

    //change internelCellTree
    internalCellTree = leftNode.internalCellTree;
    var itr = AVLTreeIterator<BPlusCell<K>>(tree: leftNode.internalCellTree);
    while(itr.hasSomeMoreItems()){
      itr.next().key.homeNode.node=this;
    }
    //acquire its parentNode
    leftNode.parentCell?.rightChildNode?.node=this;

    //changeSiblings
    leftSibling = leftNode.leftSibling;
    leftNode?.leftSibling?.node?.rightSibling?.node=this;

    rightSibling = leftNode.rightSibling;
    leftNode?.rightSibling?.node?.leftSibling?.node=this;

    //set LeftMostChild
    leftMostChild=leftNode.leftMostChild;
    if(leftMostChild!=null){
      (leftMostChild.node as LeftMostNode<K>).parentNode.node = this;
    }

    //set up node of the container
    leftNodeCont.node = this;
  }

  @override
  String toString() {
    if(internalCellTree==null){
      return "-";
    }else{
      var list = List<BPlusCell<K>>();
      AVLTreeAlgos.inorderTraversalSync(startNode: internalCellTree.root,list: list);
      return list.join("|");//"""${list.join("|")} :${internalCellTree.root}""";//
    }
  }
}

///As leftMostChild do not have a parentCell, so this node is required for that.
///Extends BPlusNode,its special node for leftMostBPlusNode, it has a parentNode ref too
class LeftMostNode<K> extends Node<K>{
  BPlusNode<K> parentNode;

  LeftMostNode({bool isLeaf, Compare<K> compare, this.parentNode}):super(isLeaf: isLeaf, compare: compare){
    this.parentCell=null;
  }

  LeftMostNode.fromNonLeftNode(BPlusNode<K> nonLeftNodeCont, K keyWorkedUpon){
    Node<K> nonLeftNode = nonLeftNodeCont.node;
    my_id = nonLeftNode.my_id;

    isLeaf =nonLeftNode.isLeaf;
    compare = nonLeftNode.compare;
    parentNode = _Util.getParentOfNode(nonLeftNode);

    //change internelCellTree
    internalCellTree = nonLeftNode.internalCellTree;
    var itr = AVLTreeIterator<BPlusCell<K>>(tree: nonLeftNode.internalCellTree);
    while(itr.hasSomeMoreItems()){
      itr.next().key.homeNode.node=nonLeftNode;
    }
    /*//acquire its parentNode
    nonLeftNode.parentCell?.homeNode.leftMostChild = this;//ORIGNAL>>//nonLeftNode.parentCell?.rightChildNode=this;//
*/
    //changeSiblings
    leftSibling = nonLeftNode.leftSibling;
    nonLeftNode?.leftSibling?.node?.rightSibling?.node=this;

    rightSibling = nonLeftNode.rightSibling;
    nonLeftNode?.rightSibling?.node?.leftSibling?.node=this;

    //set LeftMostChild
    leftMostChild=nonLeftNode.leftMostChild;
    if(leftMostChild!=null){
      (leftMostChild.node as LeftMostNode<K>).parentNode.node = this;
    }


    //setup node of the container
    nonLeftNodeCont.node = this;
  }
}

///B Plus data structure
class BPlusTree<K>{
  ///Number of nodes
  int size;

  ///This can be captured during first element creation and can be used for faster leaf node retreival
  BPlusNode<K> leftMostLeafNode;

  BPlusNode<K> get rightMostLeafNode{
    var current = root;
    while(!current.node.isLeaf){
      current =  current.node.internalCellTree.max.key.rightChildNode;
    }
    return current;
  }

  ///root element of this B Plus tree
  BPlusNode<K> root;

  ///**maxNoOfElInANode** represents maximum number of internal cells B plus tree's node can have
  int capacityOfNode;

  Compare<K> compare;

  BPlusTree({this.capacityOfNode, this.compare}){
    if(capacityOfNode<4){
      throw "Cannot a create a BPLusTree with capacityOfNode less than 4";
    }
    size=0;
    leftMostLeafNode = BPlusNode<K>(node: LeftMostNode(compare: compare, isLeaf: true));
    root = leftMostLeafNode;
  }
}

//Iterator for BPLus Tree
class BPlusTreeLeafIterator<K>{
  BPlusTree<K> bptree;
  BPlusNode<K> current;
  AVLTreeIterator<BPlusCell<K>> currentInternalTreeIterator;

  int counter;

  BPlusTreeLeafIterator({this.bptree}){
    counter= bptree.size;
    current = bptree.root.node.leftMostChild;
    while(current!=null && !current.node.isLeaf){
      current = current.node.leftMostChild;
    }
    currentInternalTreeIterator = AVLTreeIterator<BPlusCell<K>>(tree: current.node.internalCellTree);
  }

  bool hasSomeMoreItems(){
    return counter!=0;
  }

  BPlusCell<K> next(){
    if(counter!=0 && current!=null){
      if(!currentInternalTreeIterator.hasSomeMoreItems()){
        current = current.node.rightSibling;
        if(current!=null){
          currentInternalTreeIterator = AVLTreeIterator<BPlusCell<K>>(tree: current.node.internalCellTree);
        }
      }
      if(current!=null){
        counter--;
        return currentInternalTreeIterator.next().key;
      }

    }else{
      return null;
    }
  }

}



///Algorithms to deal with BPlusNode
class BPlusNodeAlgos{

  ///Ads a new cell in the internal AVL tree of the supplied node.
  ///BPlusNode consturctor has the logic to initialize the internal AVL Tree
  static BPlusCell<K> add<K>({K newKey, BPlusNode<K> node, Compare<K> compare}){
    AVLTreeNode<BPlusCell<K>> t1 = AVLTreeAlgos.insert<BPlusCell<K>>(newKey: BPlusCell<K>(key: newKey), tree: node.node.internalCellTree);
    t1.key.homeNode = node; //setting homenode of the new cell created
    return t1.key;
  }

  static BPlusCell<K> remove<K>({K keyToBeDeleted, BPlusNode<K> node}){
    return AVLTreeAlgos.delete<BPlusCell<K>>(keyToBeDeleted: BPlusCell(key: keyToBeDeleted), tree: node.node.internalCellTree)?.key;
  }

  static BPlusCell<K> searchGTE<K>({K searchKey, BPlusNode<K> node}){
    return AVLTreeAlgos.searchGTE(searchKey: searchKey, tree: node.node.internalCellTree)?.key;
  }

  static BPlusCell<K> searchLTE<K>({K searchKey, BPlusNode<K> node}){
    return AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: searchKey, tree: node.node.internalCellTree)?.key;
  }

  static int getSize<K>({BPlusNode<K> node}){
    return AVLTreeAlgos.reCalculateSize(startNode: node.node.internalCellTree.root);
  }
}


class BPlusTreeAlgos{

  //returns the height of the tree: root is at height 0
  static int getHeight<K>(BPlusTree<K> bptree){
    int i=0;
    var cn = bptree.root.node.leftMostChild;
    while(cn!=null){
      i++;
      cn=cn.node.leftMostChild;
    }
    return i;
  }

  static Stream<BPlusCell<K>> searchForRange<K>(BPlusTree<K> bptree, K startKey, K endKey) async*{
    BPlusNode<K>  startNode = startKey==null? bptree.leftMostLeafNode :searchForLeafNode(searchKey: startKey, bptree: bptree);
    BPlusNode<K> endNode = endKey==null? bptree.rightMostLeafNode: searchForLeafNode(searchKey: endKey, bptree: bptree);
    BPlusNode<K> currentNode = startNode;
    if(startNode!=endNode){
      while(currentNode!=endNode){
        var sk = startKey==null?null:BPlusCell(key: startKey);
        var ek = endKey==null? null: BPlusCell(key: endKey);
        var st1 = AVLTreeAlgos.inorderRangeTraversal(tree: currentNode.node.internalCellTree, startKey: sk, endKey: ek);
        await for (var n1 in st1){
          yield n1.key;
        }
        currentNode = currentNode.node.rightSibling;
      }
    }
    if(currentNode==endNode){
      var sk = startKey==null?null:BPlusCell(key: startKey);
      var ek = endKey==null? null: BPlusCell(key: endKey);
      var st1 = AVLTreeAlgos.inorderRangeTraversal(tree: currentNode.node.internalCellTree, startKey: sk, endKey: ek);
      await for (var n1 in st1){
        yield n1.key;
      }
    }
  }

  ///Searches for a range of values,supports pagination.
  ///
  /// [offset will decide from where to start the search and [limit] will limit the result to this many items only
  static Stream<BPlusCell<K>> searchForRangeWithPagination<K>(BPlusTree<K> bptree, K startKey, K endKey, [int offset=0, int limit=-1]) async*{
    BPlusNode<K>  startNode = startKey==null? bptree.leftMostLeafNode :searchForLeafNode(searchKey: startKey, bptree: bptree);
    BPlusNode<K> endNode = endKey==null? bptree.rightMostLeafNode: searchForLeafNode(searchKey: endKey, bptree: bptree);
    BPlusNode<K> currentNode = startNode;

    int skip=0;
    int count=0;

    if(startNode!=endNode){
      while(currentNode!=endNode){
        var sk = startKey==null?null:BPlusCell(key: startKey);
        var ek = endKey==null? null: BPlusCell(key: endKey);
        var st1 = AVLTreeAlgos.inorderRangeTraversal(tree: currentNode.node.internalCellTree, startKey: sk, endKey: ek);
        await for (var n1 in st1){
          if(skip>=offset){
            if(count==limit){
              break;
            }
            count++;
            yield n1.key;
          }else{
            skip++;
          }
        }
        currentNode = currentNode.node.rightSibling;
      }
    }
    if(currentNode==endNode){
      var sk = startKey==null?null:BPlusCell(key: startKey);
      var ek = endKey==null? null: BPlusCell(key: endKey);
      var st1 = AVLTreeAlgos.inorderRangeTraversal(tree: currentNode.node.internalCellTree, startKey: sk, endKey: ek);
      await for (var n1 in st1){
        if(skip>=offset) {
          if (count == limit) {
            break;
          }
          count++;
          yield n1.key;
        }else{
          skip++;
        }
      }
    }
  }

  ///searches for key and returns it cell from leaf node.
  ///if the searchKey is smaller than smallest than it returns null
  ///if its greater than largest than it returns largest value
  ///else it return just lesser than or equals to value
  static BPlusCell<K> searchForKey<K> ({BPlusTree<K> bptree, K searchKey}){
    BPlusNode<K> bpNode = bptree.root;
    var bpsearchKey =BPlusCell<K>(key: searchKey);
    BPlusCell<K> foundCell;
    while(bpNode!=null){
      foundCell = AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: bpsearchKey, tree: bpNode.node.internalCellTree)?.key;
      if(bpNode.node.isLeaf){
        break;
      }
      if(foundCell==null){
        bpNode=bpNode.node.leftMostChild;
      }else{
        bpNode=foundCell.rightChildNode;
      }
    }

    //bpnode is guaranteed leaf
    return foundCell;
  }

  ///searches for the leaf node where the value is being stored: uses searchJustLesserThanOrEqual
  static BPlusNode<K> searchForLeafNode<K> ({BPlusTree<K> bptree, K searchKey}){
   BPlusNode<K> bpNode= bptree.root;

    var bpsearchKey =BPlusCell<K>(key: searchKey);
    while(!bpNode.node.isLeaf){
      var foundCell = AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: bpsearchKey, tree: bpNode.node.internalCellTree);
      if(foundCell==null){
        bpNode=bpNode.node.leftMostChild;
      }else{
        bpNode=foundCell.key.rightChildNode;
      }
    }

    //bpnode is guaranteed leaf
    return bpNode;
  }

  ///
  /// <a href="https://imgbb.com/"><img src="https://i.ibb.co/djnTKD8/image.png" alt="image" border="0"></a>
  ///
  static BPlusCell<K> insert<K,V>({BPlusTree<K> bptree,K keyToBeInserted, V valueToBeInserted}){

    BPlusNode<K> currentNode = searchForLeafNode<K>(bptree: bptree, searchKey: keyToBeInserted);
    Splited<K> splitted;

    //insert for the first time
    var newCellCreatedInLeaf = BPlusNodeAlgos.add<K>(node: currentNode, compare: bptree.compare, newKey: keyToBeInserted);
    newCellCreatedInLeaf.setValue(valueToBeInserted);

    bptree.size= bptree.size+1;

    var queue = <BPlusNode<K>>[];

    int half_capacity = bptree.capacityOfNode~/2;

    //split and cascade
    while(currentNode!=null){
      if(currentNode.node.internalCellTree.size>bptree.capacityOfNode){
        //split
        splitted = _SplitManager.split<K>(currentNode, bptree.capacityOfNode, bptree.compare, keyToBeInserted);

        if(splitted.newLeftNode.node.internalCellTree.size<half_capacity){
          queue.add(splitted.newLeftNode);
        }else if(splitted.newRightNode.node.internalCellTree.size<half_capacity){
          queue.add(splitted.newRightNode);
        }

        currentNode = splitted.parentNode;

        //create the rootKey after split into parent
        var newCellInParent = BPlusNodeAlgos.add<K>(newKey: splitted.rootKey, node: splitted.parentNode, compare: bptree.compare);
        newCellInParent.rightChildNode = splitted.newRightNode;
        splitted.newRightNode.node.parentCell=newCellInParent;
      }else{
        break;
      }

    }

    //if new root is formed
    if(splitted?.split_case == SPLIT_CASE.NODE_IS_ROOT){
      bptree.root = splitted.parentNode;
    }

    while(queue.isNotEmpty){
      var t1=queue.removeAt(0);
      if(t1.node.internalCellTree==null){
        continue;
      }
      _readjustAsPerBPlusTreeNorms(t1, bptree, keyToBeInserted);
    }

  }

  ///
  /// first delete replace and cascade min value
  /// then evaluate merge or delete
  ///
  /// <a href="https://imgbb.com/"><img src="https://i.ibb.co/TTrgT1w/image.png" alt="image" border="0"></a>
  ///
  static BPlusCell<K> delete<K>({BPlusTree<K> bptree,K keyToBeDeleted}){
    //search for the key
    //BPlusCell<K> found = searchForKey<K>(searchKey: keyToBeDeleted, bptree: bptree);
    BPlusNode<K> currentNode = searchForLeafNode(bptree: bptree, searchKey: keyToBeDeleted);

    var minValBefore = AVLTreeAlgos.findMin<BPlusCell<K>>(currentNode.node.internalCellTree)?.key.key;

    BPlusCell<K>  removed_key = BPlusNodeAlgos.remove(keyToBeDeleted: keyToBeDeleted, node: currentNode);


    if(removed_key!=null){
        bptree.size = bptree.size-1;

        //cascading should happen only when min key is deleted
        if(currentNode.node.internalCellTree.size>0 && bptree.compare(keyToBeDeleted, minValBefore)==0){

          var parentNode = _Util.getParentOfNode(currentNode.node);
          //TODO: this min value can be optimized too, by getting root of the current node, will have too look it in future
          var minValAfter = AVLTreeAlgos.findMin<BPlusCell<K>>(currentNode.node.internalCellTree);
          //casecade and replace the min value
          _Util.cascade_change_upwards(parentNode, bptree.compare, (BPlusNode<K> node, Compare<K> compare){
              var bc =  AVLTreeAlgos.searchJustLesserThanOrEqual<BPlusCell<K>>(searchKey: BPlusCell<K>(key: minValBefore), tree: node.node.internalCellTree);
              if(bc!=null && compare(minValBefore, bc.key.key)==0){
                bc.key.key = minValAfter.key.key;
              }

              return true;
          });
        }

        _readjustAsPerBPlusTreeNorms(currentNode, bptree, keyToBeDeleted);
    }
  }

  static void _readjustAsPerBPlusTreeNorms<K>(BPlusNode<K> currentNode, BPlusTree<K> bptree, K keyBeingWorkedUpon) {
    while(currentNode!=null){
      var RSB = currentNode.node.rightSibling;
      var LSB = currentNode.node.leftSibling;

      CASE_AFTER_OPERATION case_is = _determine_merge_or_distriburtion_req(currentNode, bptree.capacityOfNode, keyBeingWorkedUpon);

      BPlusNode<K> parentNode;

      switch(case_is){
        case CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP:
          //parentNode = _Util.getParentOfNode(currentNode);
          break;
        case CASE_AFTER_OPERATION.MERGE_WITH_RSB:
          parentNode = _Util.getParentOfNode(RSB.node);
          _MergeManager.merge<K>(RSB, currentNode, bptree.compare, keyBeingWorkedUpon);
          break;
        case CASE_AFTER_OPERATION.MERGE_WITH_LSB:
          parentNode = _Util.getParentOfNode(currentNode.node);
          _MergeManager.merge<K>(currentNode, LSB, bptree.compare, keyBeingWorkedUpon);
          break;
        case CASE_AFTER_OPERATION.DISTRIBUTE_WITH_RSB:
          parentNode = _Util.getParentOfNode(RSB.node);
          _DistributionManager.distribute<K>(RSB, currentNode, bptree.compare, bptree.capacityOfNode, keyBeingWorkedUpon);
          break;
        case CASE_AFTER_OPERATION.OBLIVIATE_IF_APPLICABLE:
          parentNode = _Util.getParentOfNode(currentNode.node);
          BPlusNodeAlgos.remove(node: parentNode, keyToBeDeleted: keyBeingWorkedUpon);
          currentNode.node.leftSibling?.node?.rightSibling = null;
          break;
        case CASE_AFTER_OPERATION.NODE_EMPTY_CASCADE_UP:
          parentNode = _Util.getParentOfNode(currentNode.node);
          break;
      }

      currentNode = parentNode;

      //deletion and cascading is already done before
      if(case_is == CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP||case_is == CASE_AFTER_OPERATION.OBLIVIATE_IF_APPLICABLE){
        break;
      }
    }

    if(bptree.root.node.internalCellTree.size ==0 && bptree.root.node.leftMostChild!=null){
      bptree.root = bptree.root.node.leftMostChild;
      bptree.root.node.parentCell = null;
      (bptree.root.node as LeftMostNode<K>).parentNode=null;
    }
  }



  /// If after deletion:
  ///
  /// * Node is empty , cascade changes upwords
  ///
  /// * If greater or equal to half capacity do no action at all
  ///
  /// * If siblings atmost is half capacity then merge
  ///
  /// * If merge not possible, then redistribute
  ///
  /// * Right node is given preference over left node
  ///
  static CASE_AFTER_OPERATION _determine_merge_or_distriburtion_req<K>(BPlusNode<K> node, int capacityOfNode,K keyBeingWorkedUpon){
    /*if(node.internalCellTree.size==0){
      return CASE_AFTER_DELETION.NODE_EMPTY_CASCADE_UP;
    }
*/
    var half_capacity =  capacityOfNode~/2;

    if(node.node.internalCellTree.size >= half_capacity){
      return CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP;
    }else{
      var RSB = node.node.rightSibling;
      var LSB = node.node.leftSibling;

      if(RSB==null && LSB == null){ //this means node is root
        return CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP;
      }

      int rsb_size = RSB?.node?.internalCellTree?.size??0;
      int lsb_size = LSB?.node?.internalCellTree?.size??0;

      int rsb_denom = half_capacity-rsb_size;
      int lsb_denom = half_capacity-lsb_size;

      if(rsb_size>0 && 0<=rsb_denom ){ //if RSB is less then or equals to half capacity
        return CASE_AFTER_OPERATION.MERGE_WITH_RSB;
      }

      if(lsb_size>0 && 0<=lsb_denom){//if LSB is less then or equals to half capacity
        return CASE_AFTER_OPERATION.MERGE_WITH_LSB;
      }

      if(rsb_size!=0){
        return CASE_AFTER_OPERATION.DISTRIBUTE_WITH_RSB;
      }else{
        var minValue = _Util.findMinSupportedValue(node);
        if(minValue==null){
          return CASE_AFTER_OPERATION.OBLIVIATE_IF_APPLICABLE;
        }else{
          return CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP;
        }
        /*if(node.node.internalCellTree.size>0){
          return CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP;
        }else{
          var minValue = _Util.findMinSupportedValue(node);
          if(minValue==null){
            return CASE_AFTER_OPERATION.OBLIVIATE_IF_APPLICABLE;
          }else{
            return CASE_AFTER_OPERATION.NO_ACTION_REQ_CASCADE_UP;
          }
        }*/
      }
    }

  }
}

///
/// RSB = right sibling
///
/// LSB = left sibling
///
enum CASE_AFTER_OPERATION{NO_ACTION_REQ_CASCADE_UP,MERGE_WITH_RSB,MERGE_WITH_LSB, OBLIVIATE_IF_APPLICABLE, DISTRIBUTE_WITH_RSB, NODE_EMPTY_CASCADE_UP}


///
/// ST Stands for Smaller than and GT stands for greater than
enum Node_order{TARGET_ST_SOURCE, TARGET_GT_SOURCE}

class _DistributionManager{
  ///
  ///Source is always RSB
  ///
  ///distribution happens between siblings, one will be source and another target.Source will be more than half filled and target will be less than half filled.
  ///Target
  ///Items from source are copied to target unitl source become at least half full.
  ///No cascading to parent is done, it should be carried out by caller
  ///
  ///<a href="https://imgbb.com/"><img src="https://i.ibb.co/LgQj2YB/image.png" alt="image" border="0"></a>
  ///
  static distribute<K>(BPlusNode<K> source, BPlusNode<K> target, Compare<K> compare, int capacityOfNode, K keyWorkedUpon){
    var minCellBefore = _Util.findMinSupportedValue(source);

    //1. if its not a leaf level then do push source's min [SM] to target, otherwise Source[which is leaf] already has the minimum value
    if(!source.node.isLeaf){
      BPlusCell<K> sm = BPlusCell<K>(key: minCellBefore.key);
      sm.setValue(minCellBefore.getValue());

      var slmc =source.node.leftMostChild;
      Node.fromLeftNode(slmc, keyWorkedUpon);

      sm.rightChildNode = source.node.leftMostChild;
      sm.rightChildNode.node.parentCell = sm;

      AVLTreeAlgos.insert(newKey: sm, tree: target.node.internalCellTree);
      sm.homeNode = target;
    }

    //2. copy half cells from source to target
    var itr1 = AVLTreeIterator<BPlusCell<K>>(tree: source.node.internalCellTree);

    int newSizeSource = source.node.internalCellTree.size;

    //2.1 a queue has to be created , as deletion/insertion along with iteration do not works and gives conflicts
    var queue = <BPlusCell<K>>[];

    int halfCapacity = capacityOfNode~/2;
    int threshold = halfCapacity+1-(source.node.isLeaf?1:0);
    while(newSizeSource > threshold){//that one substracted will become the LMC
      queue.add(itr1.next().key);
      newSizeSource--;
    }

    var candidateForNewLMC = itr1.next().key;

    //2.2 pull from source and put in target
    for(BPlusCell<K> cell in queue){
      BPlusCell<K> item = AVLTreeAlgos.delete<BPlusCell<K>>(keyToBeDeleted: cell, tree: source.node.internalCellTree).key;
      AVLTreeAlgos.insert<BPlusCell<K>>(newKey: item, tree: target.node.internalCellTree);
      item.homeNode= target;
    }

    //3. replace SM with SM2
    var sm2 = source.node.isLeaf? source.node.internalCellTree.min.key:_Util.findMinSupportedValue(candidateForNewLMC.rightChildNode);


    //3.1 create new LMC
    if(candidateForNewLMC.rightChildNode!=null){//that is non leaf node
      _Util.makeNewLMCFromNode(candidateForNewLMC.rightChildNode, keyWorkedUpon);
    }
    //3.2 replace sm2
    var sourceParentNode = _Util.getParentOfNode(source.node);
    _Util.replaceNewMinByCascading(sourceParentNode, compare, minCellBefore, sm2);

    //TODO: uncomment and edit below line if debugging
    //debugHelper(source, target, keyWorkedUpon, "DISTR");
  }

}

//LMC means left most child
enum MERGE_CASE{SOURCE_IS_LMC, TARGET_IS_LMC, TARGET_SOURCE_ARE_NOT_LMC, SOURCE_PARENT_IS_ALMOST_EMPTY}

class _MergeManager{

  ///
  /// Source is always RSB
  ///
  ///Merge happens between siblings, one will be source and another target.
  ///Either of source or target can be atmost half filled.
  ///And one of them is necessarily be less than half filled.
  ///This change shall be propogated to parent, sibling and child nodes as well.
  ///Target is the one with smaller items than compared to source.So Target is alwasy left sibling of source.
  ///
  /// **Deletes the parent cells after merge happens**, deletes source parent cell, the effect of it must be cascaded by the caller
  ///
  /// <a href="https://ibb.co/NKh0nsB"><img src="https://i.ibb.co/4pybg7r/image.png" alt="image" border="0"></a>
  ///
  static BPlusNode<K> merge<K>(BPlusNode<K> source, BPlusNode<K> target, Compare<K> compare, K keyWorkedUpon){
    var minCellBefore = _Util.findMinSupportedValue(source);

    if(minCellBefore!=null){
      //1. if its not a leaf level then do push source's min [SM] to target, otherwise Source[which is leaf] already has the minimum value
      if(!source.node.isLeaf){
        BPlusCell<K> sm = BPlusCell<K>(key: minCellBefore.key);
        sm.setValue(minCellBefore.getValue());

        var slmc =source.node.leftMostChild;
        Node.fromLeftNode(slmc, keyWorkedUpon);

        sm.rightChildNode = slmc;
        sm.rightChildNode.node.parentCell = sm;

        AVLTreeAlgos.insert(newKey: sm, tree: target.node.internalCellTree);
        sm.homeNode = target;
      }

      //2. copy all cells from source to target
      var itr1 = AVLTreeIterator<BPlusCell<K>>(tree: source.node.internalCellTree);
      while(itr1.hasSomeMoreItems()){
        var t = itr1.next();
        AVLTreeAlgos.insert(newKey: t.key, tree: target.node.internalCellTree);
        t.key.homeNode = target; //set homenode as new merged node
      }

      source.node.internalCellTree =null;
    }


    //3. establish sibling relations: source is always RSB
    target.node.rightSibling = source.node.rightSibling;
    source.node?.rightSibling?.node?.leftSibling = target;

    var sourceParentNode = _Util.getParentOfNode(source.node);
    //4. delete source parentCell
    if(source.node.parentCell!=null){
      AVLTreeAlgos.delete(keyToBeDeleted: source.node.parentCell, tree: sourceParentNode.node.internalCellTree);
    }

    //5. if source is left most node, then will need to replace even sm by cascading
    if(source.node is LeftMostNode<K>){
      if(source.node.rightSibling!=null){
        var sRSB = source.node.rightSibling;
        var smRSB = _Util.findMinSupportedValue(sRSB);
        _Util.makeNewLMCFromNode(sRSB, keyWorkedUpon);
        _Util.replaceNewMinByCascading(sourceParentNode, compare, minCellBefore, smRSB);
      }else{
        //do obliviate: becuase of following reason
        //RSB is null and S is LMC => node is empty and after merger it must be collapsed and cascade effect must be sent up too
        _Util.cascade_change_upwards(source, compare, (BPlusNode<K> node, Compare<K> compare){
          var bc =  node.node.internalCellTree==null?null:AVLTreeAlgos.searchJustLesserThanOrEqual<BPlusCell<K>>(searchKey: minCellBefore, tree: node.node.internalCellTree);
          if(bc!=null && compare(minCellBefore.key, bc.key.key)==0){
            BPlusNodeAlgos.remove(keyToBeDeleted: bc.key.key, node: node);
            return false;
          }else{
            if(node.node.leftSibling !=null){
              node.node.leftMostChild=null;
            }
          }
          return true;
        });
      }
    }

    //TODO: uncomment and edit below line if debugging
    //debugHelper(source, target, keyWorkedUpon, "MERGE");
  }

}

class Splited<K>{
  BPlusNode<K> newLeftNode;
  BPlusNode<K> newRightNode;
  BPlusNode<K> parentNode;
  //is Null if right node has the root;
  K rootKey;

  SPLIT_CASE split_case;

  Splited({this.rootKey, this.newRightNode, this.newLeftNode, this.parentNode});
}

///LMC stands for : LEFT\_MOST\_CHILD
enum SPLIT_CASE{ NODE_IS_LMC, NODE_IS_NOT_LMC, PARENT_NODE_FULL_NODE_IS_LMC, PARENT_NODE_FULL_NODE_IS_NOT_LMC, NODE_IS_ROOT}

class _SplitManager{


  /// Splits node into left and right node, updated the key in parent node, but cascading that effect of insertion is not done.
  /// After split. parent size must be again calculated and casaded splitting if required.
  ///
  ///<a href="https://ibb.co/XZmPX1X"><img src="https://i.ibb.co/99R0n6n/image.png" alt="split" border="0"></a>
  ///
  static Splited<K> split<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
      var split_case = _whats_the_split_case(nodeToSplit, capacityOfNode);

      switch(split_case){

        case SPLIT_CASE.NODE_IS_LMC:
          return _handle_case_NODE_IS_LMC(nodeToSplit, capacityOfNode, compare,keyWorkedUpon);
        case SPLIT_CASE.NODE_IS_NOT_LMC:
          return _handle_case_NODE_IS_NOT_LMC(nodeToSplit, capacityOfNode, compare, keyWorkedUpon);
        case SPLIT_CASE.PARENT_NODE_FULL_NODE_IS_LMC:
          return _handle_case_PARENT_NODE_FULL_NODE_IS_LMC(nodeToSplit, capacityOfNode, compare, keyWorkedUpon);
        case SPLIT_CASE.PARENT_NODE_FULL_NODE_IS_NOT_LMC:
          return _handle_case_PARENT_NODE_FULL_NODE_IS_NOT_LMC(nodeToSplit, capacityOfNode, compare, keyWorkedUpon);
        case SPLIT_CASE.NODE_IS_ROOT:
          var t = _handle_case_NODE_IS_ROOT(nodeToSplit, capacityOfNode, compare, keyWorkedUpon);
          t.split_case = SPLIT_CASE.NODE_IS_ROOT;
          return t;
      }
  }

  static SPLIT_CASE _whats_the_split_case<K>(BPlusNode<K> nodeToSplit, int capacityOfNode){
    var parentNode = _Util.getParentOfNode(nodeToSplit.node);

    if(nodeToSplit.node.parentCell==null && parentNode!=null){
      if(parentNode!=null && parentNode.node.internalCellTree.size == capacityOfNode-1){
        return SPLIT_CASE.PARENT_NODE_FULL_NODE_IS_LMC;
      }else{
        return SPLIT_CASE.NODE_IS_LMC;
      }
    }else if(nodeToSplit.node.parentCell!=null && parentNode!=null){
      if(parentNode!=null && parentNode.node.internalCellTree.size == capacityOfNode-1){
        return SPLIT_CASE.PARENT_NODE_FULL_NODE_IS_NOT_LMC;
      }else{
        return SPLIT_CASE.NODE_IS_NOT_LMC;
      }
    }else if(nodeToSplit.node.parentCell==null && parentNode==null){
      return SPLIT_CASE.NODE_IS_ROOT;
    }else{
      throw "ERR: Unknown case during split of $nodeToSplit";
    }
  }

  ///
  /// <a href="https://ibb.co/GW9sbNZ"><img src="https://i.ibb.co/7nQg6L3/image.png" alt="image" border="0"></a>
  ///
  // ignore: non_constant_identifier_names
  static Splited<K> _handle_case_NODE_IS_LMC<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
    return _generic_split(nodeToSplit, compare,keyWorkedUpon);
  }

  ///
  /// <a href="https://ibb.co/whpbbXy"><img src="https://i.ibb.co/HTGMMs7/image.png" alt="image" border="0"></a>
  ///
  // ignore: non_constant_identifier_names
  static Splited<K> _handle_case_NODE_IS_NOT_LMC<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
    return _generic_split(nodeToSplit, compare,keyWorkedUpon);
  }


  ///
  /// Root node start with as LeftMostNode
  ///
  /// <a href="https://ibb.co/GW9sbNZ"><img src="https://i.ibb.co/7nQg6L3/image.png" alt="image" border="0"></a>
  ///
  // ignore: non_constant_identifier_names
  static Splited<K> _handle_case_NODE_IS_ROOT<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
    return _generic_split(nodeToSplit, compare,keyWorkedUpon);
  }

  ///
  /// <a href="https://ibb.co/jH518sd"><img src="https://i.ibb.co/yVRbN7D/image.png" alt="image" border="0"></a>
  ///
  // ignore: non_constant_identifier_names
  static Splited<K> _handle_case_PARENT_NODE_FULL_NODE_IS_LMC<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
    return _generic_split(nodeToSplit, compare,keyWorkedUpon);
  }

  ///
  /// <a href="https://ibb.co/0ZkYsJD"><img src="https://i.ibb.co/ZK3c2TL/image.png" alt="image" border="0"></a>
  ///
  // ignore: non_constant_identifier_names
  static Splited<K> _handle_case_PARENT_NODE_FULL_NODE_IS_NOT_LMC<K>(BPlusNode<K> nodeToSplit,  int capacityOfNode, Compare<K> compare,K keyWorkedUpon){
    return _generic_split(nodeToSplit, compare, keyWorkedUpon);
  }

  ///splits the node into newLeftNode, newRightNode and pushed the root to parentNode;
  static Splited<K> _generic_split<K>(BPlusNode<K> nodeToSplit, Compare<K> compare, K keyWorkedUpon){

    var prev_min = nodeToSplit.node.internalCellTree.min;
    var prev_max = nodeToSplit.node.internalCellTree.max;

    //initialization: Start
    var comp = (BPlusCell<K> k1, BPlusCell<K> k2){
      return compare(k1.key, k2.key);
    };

    var rootKey = nodeToSplit.node.internalCellTree.root.key.key;
    var rightSibling = nodeToSplit.node.rightSibling;

    var leftCut = _Util.cut_treeNode_from_Tree(nodeToSplit.node.internalCellTree.root.left, comp);
    //initialization: End

    //creating newRightNode
    var newRightNode = BPlusNode<K>(node: Node<K>(compare: compare, isLeaf: nodeToSplit.node.isLeaf));
    if(nodeToSplit.node.isLeaf){
      newRightNode.node.internalCellTree.root = leftCut.oldParent;

      //set max and min for new right node internal cell tree
      newRightNode.node.internalCellTree.min = leftCut.oldParent;
      newRightNode.node.internalCellTree.max = prev_max;
    }else{
      var rightCut = _Util.cut_treeNode_from_Tree(nodeToSplit.node.internalCellTree.root.right, comp);
      newRightNode.node.internalCellTree.root = rightCut.newTreeRootNode;

      //set max and min for new right node internal cell tree
      newRightNode.node.internalCellTree.min = AVLTreeAlgos.findMin(newRightNode.node.internalCellTree);
      newRightNode.node.internalCellTree.max = prev_max;
    }
    newRightNode.node.internalCellTree.size  = AVLTreeAlgos.reCalculateSize(startNode: newRightNode.node.internalCellTree.root);

    //setting up leftMostChild for new right node
    if(!nodeToSplit.node.isLeaf){
      var rightChildNodeOfRoot = nodeToSplit.node.internalCellTree.root.key.rightChildNode;

      var lmbc = LeftMostNode.fromNonLeftNode(rightChildNodeOfRoot, keyWorkedUpon);
      newRightNode.node.leftMostChild = rightChildNodeOfRoot;
      (lmbc as LeftMostNode<K>).parentNode = newRightNode;
    }

    //left node preserves all parent child relation
    var newLeftNode = nodeToSplit;
    nodeToSplit.node.internalCellTree.root = leftCut.newTreeRootNode;
    newLeftNode.node.internalCellTree.size = AVLTreeAlgos.reCalculateSize(startNode: newLeftNode.node.internalCellTree.root);

    //set max and min for new left node internal cell tree
    newLeftNode.node.internalCellTree.min = prev_min;
    newLeftNode.node.internalCellTree.max = AVLTreeAlgos.findMax(newLeftNode.node.internalCellTree, recalculate: true);

    //change cell's homeNode is newRightNode
    //Set parents of cells right child nodes parent attribute as newRightNode
    var iteratorForChildNodes = AVLTreeIterator<BPlusCell>(tree: newRightNode.node.internalCellTree);
    while(iteratorForChildNodes.hasSomeMoreItems()){
      var cell  = iteratorForChildNodes.next().key;
      cell.homeNode=newRightNode;
    }

    //setting up sibling relationship
    newLeftNode.node.rightSibling =  newRightNode;
    newRightNode.node.leftSibling = newLeftNode;
    newRightNode.node.rightSibling = rightSibling;
    rightSibling?.node?.leftSibling = newRightNode;

    //balance right tree
    AVLTreeAlgos.checkAndBalanceTree(newRightNode.node.internalCellTree.root, newRightNode.node.internalCellTree);

    //setting up parentCell Relation
    //pushing rootKey to parent
    BPlusNode<K> parentNode = _Util.getParentOfNode<K>(nodeToSplit.node);
    if(parentNode!=null){
      AVLTreeAlgos.findMax(parentNode.node.internalCellTree);
      AVLTreeAlgos.findMin(parentNode.node.internalCellTree);
    }

    //if parent node is null : in case of root split, new right node is set outside after split as a part of bug fix
    if(parentNode==null){
      parentNode = BPlusNode<K>(node:  LeftMostNode<K>(isLeaf: false, compare: compare));
      parentNode.node.leftMostChild = newLeftNode;
      if(newLeftNode.node is LeftMostNode<K>){
        (newLeftNode.node as LeftMostNode<K>).parentNode = parentNode;
      }else{
        newLeftNode.node.parentCell.homeNode = parentNode;
      }
    }

    return Splited<K>(
      parentNode: parentNode,
      rootKey: rootKey,
      newLeftNode: newLeftNode,
      newRightNode: newRightNode );
  }
}



class _Util{

  static void cascadeMinimumValueViaRSB1<K>(BPlusNode<K> startNode, BPlusNode<K> startNodeParentNode, Compare<K> compare, BPlusCell<K> minCellBefore,K keyWorkedUpon) {
    if(startNode.node is LeftMostNode<K> && startNode.node.rightSibling!=null){
      var smRSB = findMinSupportedValue(startNode.node.rightSibling);
      var sRSB = startNode.node.rightSibling;

      AVLTreeAlgos.delete(keyToBeDeleted: sRSB.node.parentCell, tree: startNodeParentNode.node.internalCellTree);

      //make sRSB as new LMC
      LeftMostNode.fromNonLeftNode(sRSB, keyWorkedUpon);
      sRSB.node.parentCell = null;
      (sRSB.node as LeftMostNode<K>).parentNode = startNodeParentNode;

      cascade_change_upwards(startNodeParentNode, compare, (BPlusNode<K> node, Compare<K> compare){
        var bc =  AVLTreeAlgos.searchJustLesserThanOrEqual<BPlusCell<K>>(searchKey: minCellBefore, tree: node.node.internalCellTree);
        if(bc!=null && compare(minCellBefore.key, bc.key.key)==0){
          bc.key.key = smRSB.key;
          return false;
        }else{
          return true;
        }
      });
    }
  }


  ///
  /// fromNode is a Non left node : Node<K>
  ///
  static void makeNewLMCFromNode<K>(BPlusNode<K> fromNode, K keyWorkedUpon) {

    var fromNodeParentNode= getParentOfNode(fromNode.node);

    AVLTreeAlgos.delete(keyToBeDeleted: fromNode.node.parentCell, tree: fromNodeParentNode.node.internalCellTree);

    //make as new LMC
    LeftMostNode.fromNonLeftNode(fromNode, keyWorkedUpon);
    fromNode.node.parentCell = null;
    (fromNode.node as LeftMostNode<K>).parentNode = fromNodeParentNode;

    fromNodeParentNode.node.leftMostChild = fromNode;

  }

  ///
  /// replace min key before and after wards
  ///
  static void replaceNewMinByCascading<K>(BPlusNode<K> startNode, Compare<K> compare, BPlusCell<K> minCellBefore,BPlusCell<K> minCellAfter){
    cascade_change_upwards(startNode, compare, (BPlusNode<K> node, Compare<K> compare){
      var bc =  AVLTreeAlgos.searchJustLesserThanOrEqual<BPlusCell<K>>(searchKey: minCellBefore, tree: node.node.internalCellTree);
      if(bc!=null && compare(minCellBefore.key, bc.key.key)==0){
        bc.key.key = minCellAfter.key;
        return false;
      }else{
        return true;
      }
    });
  }


  static BPlusCell<K> findMinSupportedValue<K>(BPlusNode<K> startNode){
    while(startNode!=null&&!startNode.node.isLeaf){
      startNode = startNode.node.leftMostChild;
    }
    return startNode?.node?.internalCellTree?.min?.key;//internal cell of source tree is reduced to null during merging
  }

  static Node_order whats_the_node_order<K>(BPlusNode<K> source, BPlusNode<K> target, Compare<K> compare, K keyWorkedUpon){
    var maxS = AVLTreeAlgos.findMax<BPlusCell<K>>(source.node.internalCellTree);
    var maxT = AVLTreeAlgos.findMax<BPlusCell<K>>(target.node.internalCellTree);

    int r = compare(maxT.key.key,maxS.key.key);

    if(r>0){
      return Node_order.TARGET_GT_SOURCE;
    }else if(r<0){
      return Node_order.TARGET_ST_SOURCE;
    }else{
      throw "ERR: Unknown case of distribution , for key: $keyWorkedUpon,  source[${source.node.my_id}]: [$source], target[${target.node.my_id}]: [$target]";
    }
  }

  //returns the parent node
  static BPlusNode<K> getParentOfNode<K>(Node<K> node) {
    BPlusNode<K> parentNode;
    if(node is LeftMostNode<K>){
      parentNode = (node as LeftMostNode<K>).parentNode;
    }else{
      parentNode = node.parentCell?.homeNode;
    }
    return parentNode;
  }

  //applies change to current node node and cascade it to its parent recursively
  static cascade_change_upwards<K>(BPlusNode<K> startNode,Compare<K> compare, ChangeNodeFunction<K> change){
      bool continue_flag = true;
      while(startNode!=null&&continue_flag){
        continue_flag=change(startNode, compare);
        startNode = getParentOfNode(startNode.node);
      }
  }

  ///cuts treenode from its parent: eample usage cut_treeNode_from_Tree(root.left, compare) //creates the left subtree
  static TreeNodeCutSection<K> cut_treeNode_from_Tree<K>(AVLTreeNode<K> treeNodeToBeCut, Compare<K> compare){
    var parent = treeNodeToBeCut.parent;
    var node_is = AVLTreeAlgos.checkWhichChildItIsOfItsParent(treeNodeToBeCut, compare);

    if(node_is == Is.LEFT_CHILD){
      parent.left= null;
    }else if(node_is == Is.RIGHT_CHILD){
      parent.right=null;
    }else{
      treeNodeToBeCut.left=null;
      treeNodeToBeCut.right=null;
    }

    treeNodeToBeCut.parent=null;

    return TreeNodeCutSection(parent,treeNodeToBeCut);
  }
}

class TreeNodeCutSection<K>{
  AVLTreeNode<K> oldParent;
  AVLTreeNode<K> newTreeRootNode;

  TreeNodeCutSection(this.oldParent, this.newTreeRootNode);

  @override
  String toString() {
    return "[$oldParent] $newTreeRootNode";
  }
}

