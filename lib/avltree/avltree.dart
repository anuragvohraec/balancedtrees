import "package:meta/meta.dart";
import "package:balancedtrees/comparators/comparators.dart";

//Why not used collections present in dart:collections ? in the SplayTreeMap provided, traversal is not possible and startKey and endkey query is not possible to get a range of values
typedef Compare<K> = int Function(K k1, K k2);

enum Is {LEFT_CHILD,RIGHT_CHILD, ROOT}

enum Assertively{LESSER_THAN,EQUALS_TO, GREATER_THAN, IS_NULL}

enum Has{NO_CHILD,ONLY_LEFT_CHILD,ONLY_RIGHT_CHILD,BOTH_LEFT_AND_RIGHT_CHILD}

enum BalanceStatus{RIGHT_SUBTREE_IS_BIGGER, AVL_BALANCED, LEFT_SUBTREE_IS_BIGGER}

///Node for a AVL tree
class AVLTreeNode<K>{
  AVLTreeNode<K> parent;
  AVLTreeNode<K> right;
  AVLTreeNode<K> left;
  K key;

  AVLTreeNode({this.key});

  int get height{
    int r = genUnitSortHelper(leftSubtreeHeight, rightSubtreeHeight);
   return r>0?leftSubtreeHeight: rightSubtreeHeight;
  }

  int get leftSubtreeHeight{
    return left!=null ? left.height + 1 : 0;
  }

  int get rightSubtreeHeight{
    return right!=null ?right.height + 1 : 0;
  }

  ///leftSubtreeHeight - rightSubtreeHeight => if > 0 that means leftSubtree is bigger
  int get balanceFactor {
    return leftSubtreeHeight - rightSubtreeHeight;
  }


  @override
  String toString() {
    return key.toString();
  }
}

///AVL tree class
class AVLTree<K>{
  AVLTreeNode<K> root;
  Compare<K> compare;

  AVLTreeNode<K> min;
  AVLTreeNode<K> max;

  int size;

  AVLTree({this.compare, this.size=0});

}

enum Direction {GO_LEFT,GO_RIGHT,GO_UP}

class AVLTreeIterator<K>{
  AVLTree<K> tree;

  List<AVLTreeNode<K>> stack;
  int counter;
  AVLTreeNode<K> current;

  final bool isForwardIterator;


  AVLTreeIterator({this.tree, this.isForwardIterator=true}){
    counter = tree.size;
    current=tree.root;
    stack=[current];
  }

  bool hasSomeMoreItems(){
    return counter!=0;
  }

  AVLTreeNode<K> next() {
    if(isForwardIterator){
      var t1;
      if(stack.isNotEmpty){
        while(current!=null){
          stack.add(current);
          current=current.left;
        }
        t1= stack.removeLast();
        counter--;
        current=t1.right;
      }
      return t1;
    }else{
      throw 'ERR: This is not a forward iterator and hence it do not supports next(), it supports only previous()';
    }

  }

  AVLTreeNode<K> previous() {
    if(!isForwardIterator){
      var t1;
      if(stack.isNotEmpty){
        while(current!=null){
          stack.add(current);
          current=current.right;
        }
        t1= stack.removeLast();
        counter--;
        current=t1.left;
      }
      return t1;
    }else{
      throw 'ERR: This is not a backward iterator and hence it do not supports previous(), it supports only next()';
    }

  }

}

///Algorithms needed by the AVL tree
class AVLTreeAlgos{


  //recalculates the size of tree
  static int reCalculateSize<K>({@required AVLTreeNode<K> startNode}){
    int i =0;
    if(startNode!=null){
      i=i+reCalculateSize(startNode: startNode.left);
      i=i+1;
      i= i+reCalculateSize(startNode: startNode.right);
    }
    return i;
  }
  ///provides inorder traversal(: when items required in comparison sorted order
  static inorderTraversalSync<K>({@required AVLTreeNode<K> startNode, List<K> list}){
    if(startNode!=null){
      inorderTraversalSync(startNode: startNode.left,list: list);//go for least;
      list.add (startNode.key);//go for middle
      inorderTraversalSync(startNode: startNode.right,list: list);//go for biggest
    }
  }

  static List<K> preorderTraversalSync<K>({@required AVLTreeNode<K> startNode}){
    var kl = <K>[];
    _preorderTraversalSync(startNode: startNode, list: kl);
    return kl;
  }

  static _preorderTraversalSync<K>({@required AVLTreeNode<K> startNode, List<K> list}){
    if(startNode!=null){
      list.add (startNode.key);//go for middle
      _preorderTraversalSync(startNode: startNode.left,list: list);//go for least;
      _preorderTraversalSync(startNode: startNode.right,list: list);//go for biggest
    }
  }


  ///provides inorder traversal(: when items required in comparison sorted order
  static Stream<AVLTreeNode<K>> inorderTraversal<K>({@required AVLTreeNode<K> startNode}) async*{
    if(startNode!=null){
      yield* inorderTraversal(startNode: startNode.left);//go for least
      yield startNode;//go for middle
      yield* inorderTraversal(startNode: startNode.right);//go for biggest
    }
  }

  ///provides inorder traversal(: when items required in comparison sorted order
  static Stream<AVLTreeNode<K>> inorderRangeTraversal<K>({K startKey, K endKey, AVLTree<K> tree}) async*{
    await for(var i in inorderTraversal(startNode: tree.root)){
      if(tree.compare(i.key,startKey)>0){
        yield i;
      }
      if(tree.compare(i.key,endKey)>=0){
        break;
      }
    }
  }

  ///provides inorder traversal: used when operation from root is required (copy the tree)
  static Stream<AVLTreeNode<K>> preorderTraversal<K>({@required AVLTreeNode<K> startNode}) async*{
    if(startNode!=null) {
      yield startNode; //root
      yield* preorderTraversal(startNode: startNode?.left); //left
      yield* preorderTraversal(startNode: startNode?.right); //right
    }
  }

  ///provides inorder traversal: used when operation from leaf is required (deletion from leaf)
  static Stream<AVLTreeNode<K>> postorderTraversal<K>({@required AVLTreeNode<K> startNode}) async*{
    if(startNode!=null) {
      yield* postorderTraversal(startNode: startNode?.left);
      yield* postorderTraversal(startNode: startNode?.right);
      yield startNode;
    }
  }

  ///returns null if the tree supplied is null, else returns the minimum value in the tree
  static AVLTreeNode<K> findMin<K>(@required AVLTree<K> tree,{bool recalculate=false}){
    if(tree==null){
      return null;
    }
    if(tree.root == null){
      tree.max = null;
      tree.min = null;
      return null;
    }


    if(tree.min==null||recalculate){
      tree.min=_findMin(tree.root);
    }
    return tree.min;
  }

  static AVLTreeNode<K> _findMin<K>(@required AVLTreeNode<K> currentNode){
    if(currentNode.left==null){
      return currentNode;
    }else{
      return _findMin(currentNode.left);
    }
  }

  static AVLTreeNode<K> findMax<K>(@required AVLTree<K> tree,{bool recalculate=false}){
    if(tree==null){
      return null;
    }
    if(tree.root == null){
      tree.max = null;
      tree.min = null;
      return null;
    }


    if(tree.max==null || recalculate){
      tree.max=_findMax(tree.root);
    }
    return tree.max;
  }

  static AVLTreeNode<K> _findMax<K>(@required AVLTreeNode<K> currentNode){
    if(currentNode.right==null){
      return currentNode;
    }else{
      return _findMax(currentNode.right);
    }
  }

  ///finds a node equals or "just" greater than the current node,
  ///equality has to be checked once more, aftre it sends results
  ///does a linear search : O(log n)
  static linearSearch<K>({@required K keyToBeSearched,@required AVLTree<K> tree}) async{
    if(tree.root==null){
      return null;
    }else{
      var travCell=null;
      await for(var n in inorderTraversal(startNode: tree.root)){
        travCell = n;
        if(tree.compare(travCell.key,keyToBeSearched)>=0){
          break;
        }
      }
      return travCell;
    }
  }

  ///finds a node equals or "just" lesser than the current node,
  ///equality has to be checked once more, after it sends results.
  ///**returns right most element** if search key is bigger than biggest,
  ///**returns null** if search key is smaller than the least.
  static AVLTreeNode<K> searchJustLesserThanOrEqual<K>({@required K searchKey,@required AVLTree<K> tree}){
    return _searchJLTorE(currentNode: tree.root, searchKey: searchKey, compare: tree.compare);
  }



  ///back end supporting function for search operation: searchJustLesserThanOrEqual
  ///
  /// * **jltNode** just lesser than node
  static AVLTreeNode<K> _searchJLTorE<K>({@required AVLTreeNode<K> currentNode, @required K searchKey, @required Compare<K> compare, AVLTreeNode<K> jltNode}){
    AVLTreeNode<K>  t1;

    if(currentNode==null||searchKey==null){
      t1= null; //not found at all
    }else{
      //compare current key with search key
      var r = compare(currentNode.key, searchKey);
      //if r<0, currentNode is smaller than searchKey
      //if r>0, then currentNode is greater than searchKey

      if(r==0){ //currentKey and searchKey are same
        return currentNode; //exact match
      }else if(r<0) {
        //current key is lesser than search key
        if(jltNode== null || compare(jltNode.key,currentNode.key)>0){
          jltNode = currentNode;
        }

        if(jltNode!=null && compare(jltNode.key,currentNode.key)<0){
          jltNode=currentNode;
        }

        //if current key is less than searchKey, select the right node and search it in their
        t1= _searchJLTorE(currentNode: currentNode.right,searchKey: searchKey, jltNode: jltNode, compare: compare);
      }else {//currentNode is greater than searchKey

        if(jltNode== null || compare(jltNode.key,currentNode.key)<0){
          jltNode = currentNode;
        }

        //if current key is greater than searchKey, select left node and search it in their
        t1= _searchJLTorE(currentNode: currentNode.left,searchKey: searchKey, jltNode: jltNode, compare: compare);
      }
    }
    if(t1==null&& jltNode!=null){
      //if jgtnode is greater than search key, then only return jgtNode
      // [see TESTCASE9 in avtree_test.dart , which was failing due to it]
      //else return null , as there is no just greater than node in the tree
      return compare(jltNode.key,searchKey)<0?jltNode:null;
    }
    return t1;
  }


  ///finds a node equals or "just" greater than the current node,
  ///equality has to be checked once more, aftre it sends results
  static AVLTreeNode<K> searchGTE<K>({@required K searchKey,@required AVLTree<K> tree}){
    var r = _recursive_search(currentNode: tree.root, searchKey: searchKey, compare: tree.compare);
    return r;
  }

  ///Compare current nodes key with a search key and gives whther it is greater than equals to or lesser than search key
  static Assertively _compareNodeKeyWithSearchKey<K>(K nodeKey, K searchKey, Compare<K> compare ){
      if(nodeKey==null){
        return Assertively.IS_NULL;
      }

      int r = compare(nodeKey,searchKey);
      if(r==0){
        return Assertively.EQUALS_TO;
      }else if(r<0){
        return Assertively.LESSER_THAN;
      }else{
        return Assertively.GREATER_THAN;
      }
  }

  ///back end supporting function for search operation
  ///
  /// * **jgtNode** just greater than node
  static AVLTreeNode<K> _recursive_search<K>({@required AVLTreeNode<K> currentNode, @required K searchKey, @required Compare<K> compare, AVLTreeNode<K> jgtNode}){
    AVLTreeNode<K>  t1;

    var currentNode_Is______Searchkey = _compareNodeKeyWithSearchKey(currentNode?.key, searchKey, compare);
    //compare current key with search key

    if(currentNode_Is______Searchkey == Assertively.IS_NULL){
      return null;
      /*



       */
    }else if(currentNode_Is______Searchkey==Assertively.EQUALS_TO){ //currentKey and searchKey are same
      return currentNode; //exact match
      /*



       */
    }else if(currentNode_Is______Searchkey==Assertively.LESSER_THAN) {
      //current key is lesser than search key
      if(jgtNode== null || compare(jgtNode.key,currentNode.key)<0){
        jgtNode = currentNode;
      }
      //if current key is less than searchKey, select the right node and search it in their
      t1= _recursive_search(currentNode: currentNode.right,searchKey: searchKey, jgtNode: jgtNode, compare: compare);
      /*



       */
    }else if(currentNode_Is______Searchkey==Assertively.GREATER_THAN) {//current key is greater than search key

      var jgtNode_is_____currentNode = _compareNodeKeyWithSearchKey(jgtNode?.key, currentNode.key, compare);

      if(jgtNode_is_____currentNode== Assertively.IS_NULL || jgtNode_is_____currentNode==Assertively.GREATER_THAN){//TODO:delete this lines:  jgtNode== null || compare(jgtNode.key,currentNode.key)>0){
        jgtNode = currentNode;
      }

      if(jgtNode!=null && jgtNode_is_____currentNode==Assertively.LESSER_THAN){
        jgtNode=currentNode;
      }
      //if current key is greater than searchKey, select left node and search it in their
      t1= _recursive_search(currentNode: currentNode.left,searchKey: searchKey, jgtNode: jgtNode, compare: compare);
      /*



       */
    }else{
      throw "ERR: during recursive_search, current node: ${currentNode?.key}, this condition should never ever have come. There is bug in code for recursive_search";
    }

    if(t1==null){
      //if jgtnode is greater than search key, then only return jgtNode
      // [see TESTCASE9 in avtree_test.dart , which was failing due to it]
      //else return null , as there is no just greater than node in the tree
      return compare(jgtNode.key,searchKey)>=0?jgtNode:null;
    }
    return t1;
  }

  ///inserts a new node, returns the refernce to the new Node inserted
  static AVLTreeNode<K> insert<K>({@required K newKey,@required AVLTree<K> tree}){
    AVLTreeNode<K> t1=insertWithoutBalance(newKey: newKey, tree: tree);
    checkAndBalanceTree(t1, tree);
    return t1;
  }

  ///inserts a new node, returns the refernce to the new Node inserted, avoid AVL balance 
  static AVLTreeNode<K> insertWithoutBalance<K>({@required K newKey,@required AVLTree<K> tree}){
    AVLTreeNode<K> t1;
    if(tree.root==null){//filling the root
      t1 =AVLTreeNode(key: newKey);
      tree.root=t1;
      tree.max = t1;
      tree.min = t1;
    }else{
      t1=_insertNode(currentNode: tree.root, newKey: newKey, compare: tree.compare);
      _setMinAndMaxAfterInsertion(tree, t1);
    }
    tree.size++;
    return t1;
  }

  static _setMinAndMaxAfterInsertion<K>(@required AVLTree<K> tree, AVLTreeNode<K> newValueInserted){
    Compare<K> compare = tree.compare;
    if(compare(newValueInserted.key,tree.min.key)<0){
      tree.min = newValueInserted;
    }

    if(compare(newValueInserted.key, tree.max.key)>0){
      tree.max = newValueInserted;
    }
  }

  ///back end supporting function for insertion, returns new node
  static AVLTreeNode<K> _insertNode<K>({@required AVLTreeNode<K> currentNode,@required K newKey, @required Compare<K> compare}){
    AVLTreeNode<K> r;
    if(compare(newKey,currentNode.key)<0){//=> its lesser than current node.
      if(currentNode.left==null){
        var newNode = AVLTreeNode(key: newKey);
        currentNode.left=newNode; //add the node
        newNode.parent=currentNode; //set its parent
        r= newNode;
      }else{
        r= _insertNode(currentNode: currentNode.left,newKey: newKey, compare: compare);
      }
    }else{
      if(currentNode.right==null){
        var newNode = AVLTreeNode(key: newKey);
        currentNode.right=newNode; //add the node
        newNode.parent=currentNode; //set its parent
        r= newNode;
      }else{
        r= _insertNode(currentNode: currentNode.right,newKey: newKey, compare: compare);
      }
    }
    return r;
  }

  ///deletes the node from the tree if its present
  static AVLTreeNode<K> delete <K>({@required K keyToBeDeleted, @required AVLTree<K> tree}){
    var found = searchGTE(searchKey: keyToBeDeleted, tree: tree);
    var t1= found;

    var foundKey_is____keyToBeDeleted = _compareNodeKeyWithSearchKey(found?.key, keyToBeDeleted, tree.compare);

    //if key is found and is equals to the deletion key then delete it
    if(foundKey_is____keyToBeDeleted==Assertively.EQUALS_TO){
      _setMinAndMaxAfterDeletion(tree, t1);
      if(tree.size!=0){
        if(tree.size==1){
          tree.root=null;
          tree.size=0;
        }else{
          var node_which_replaced_deleted_node = _deleteNode(nodeToRemove: found, compare: tree.compare);
          tree.size--;
          //FIXME: parent can be null in case of root;
          checkAndBalanceTree(node_which_replaced_deleted_node, tree);
        }
      }
      return AVLTreeNode(key: keyToBeDeleted);
    }

    return null;
  }

  static _setMinAndMaxAfterDeletion<K>(@required AVLTree<K> tree, AVLTreeNode<K> keyDeleted){
    Compare<K> compare = tree.compare;
    if(compare(keyDeleted.key, tree.min.key)==0){
      if(keyDeleted.right!=null){
        tree.min = _findMin(keyDeleted.right);
      }else{
        tree.min = keyDeleted.parent;
      }
    }

    if(compare(keyDeleted.key, tree.max.key)==0){
      if(keyDeleted.left!=null){
        tree.max = _findMax(keyDeleted.left);
      }else{
        tree.max = keyDeleted.parent;
      }
    }
  }

  static Has _checkChildStatus<K>(AVLTreeNode<K> node){
    if(node.left == null && node.right ==null){
      return Has.NO_CHILD;
    }else if (node.left ==null && node.right != null){
      return Has.ONLY_RIGHT_CHILD;
    }else if (node.left !=null && node.right == null){
      return Has.ONLY_LEFT_CHILD;
    }else{
      return Has.BOTH_LEFT_AND_RIGHT_CHILD;
    }
  }

  ///back end supporting function for deletion
  static AVLTreeNode<K> _deleteNode<K>({@required AVLTreeNode<K> nodeToRemove, @required Compare<K> compare}){

    var parent = nodeToRemove.parent;

    var nodeToRemove_is = checkWhichChildItIsOfItsParent(nodeToRemove, compare);//FIXME: Fails for root node

    var nodeToRemove_has = _checkChildStatus(nodeToRemove);

    var start_node_for_balance=parent;

    switch(nodeToRemove_has){
      case Has.NO_CHILD: {
        if(nodeToRemove_is == Is.RIGHT_CHILD){//right child
          parent?.right =null;
        }else if(nodeToRemove_is == Is.LEFT_CHILD){
          parent?.left=null;
        }
        break;
      }

      case Has.ONLY_RIGHT_CHILD: {
        //if the node to remove has only right child
        if(nodeToRemove_is == Is.RIGHT_CHILD){//right child
          parent?.right = nodeToRemove.right;
          nodeToRemove.right.parent=parent;
        }else if(nodeToRemove_is == Is.LEFT_CHILD){
          parent?.left = nodeToRemove.right;
          nodeToRemove.right.parent=parent;
        }else if(nodeToRemove_is == Is.ROOT){
          var rc_nodeToRemove = nodeToRemove.right;
          nodeToRemove.key= rc_nodeToRemove.key;
          nodeToRemove.left= rc_nodeToRemove.left;rc_nodeToRemove?.left?.parent=nodeToRemove;
          nodeToRemove.right= rc_nodeToRemove.right; rc_nodeToRemove?.right?.parent=nodeToRemove;

          start_node_for_balance=nodeToRemove;
        }
        break;
      }

      case Has.ONLY_LEFT_CHILD:{
        //if the node to remove has only left child
        if(nodeToRemove_is == Is.RIGHT_CHILD){//right child
          parent?.right= nodeToRemove.left;
          nodeToRemove.left.parent=parent;
        }else if(nodeToRemove_is == Is.LEFT_CHILD){
          parent?.left = nodeToRemove.left;
          nodeToRemove.left.parent=parent;
        }else if(nodeToRemove_is == Is.ROOT){
          var lc_nodeToRemove = nodeToRemove.left;
          nodeToRemove.key= lc_nodeToRemove.key;
          nodeToRemove.left= lc_nodeToRemove.left;lc_nodeToRemove?.left?.parent=nodeToRemove;
          nodeToRemove.right= lc_nodeToRemove.right; lc_nodeToRemove?.right?.parent=nodeToRemove;

          start_node_for_balance=nodeToRemove;
        }

        break;
      }

      case Has.BOTH_LEFT_AND_RIGHT_CHILD:{
        var biggest_node_in_left_subtree = nodeToRemove.left;
        while(biggest_node_in_left_subtree.right != null){
          biggest_node_in_left_subtree = biggest_node_in_left_subtree.right;
        }

        //replacement=biggest_node_in_left_subtree.parent;

        var b_parent = biggest_node_in_left_subtree.parent;
        var b_LChild = biggest_node_in_left_subtree.left;

        if(nodeToRemove.left==biggest_node_in_left_subtree){//biggest node is direct child of nodeToRemove
          if(b_LChild==null){//has no childrens
            nodeToRemove.left=null;
          }else{
            nodeToRemove.left=b_LChild;
            b_LChild.parent=nodeToRemove;
          }
          start_node_for_balance=nodeToRemove;
        }else{//biggest node is not direct child of nodeToRemove
          if(b_LChild==null){//has no childrens
            b_parent.right=null;
          }else{
            b_parent.right=b_LChild;
            b_LChild.parent=b_parent;
          }
          start_node_for_balance=b_parent;
        }

        nodeToRemove.key= biggest_node_in_left_subtree.key;

        break;
      }

    }

    return start_node_for_balance;

  }

  ///balances the node
  static checkAndBalanceTree<K>(AVLTreeNode<K> node,AVLTree<K> tree) {
    AVLTreeNode<K> current = node;
    AVLTreeNode<K> prev;
    while (current!=null) {
      current = _balance_current_node(current,tree.compare);

      prev = current;

      current = current?.parent;
    }
    tree.root=prev;
  }


  //Back end funct which checks which side of tree is bigger, left or right
  static BalanceStatus _nodeSubtreeBalance<K>(AVLTreeNode<K> node){
    var bf = node.balanceFactor;
    if(bf>1){
      return BalanceStatus.LEFT_SUBTREE_IS_BIGGER;
    }else if(bf<-1){
      return BalanceStatus.RIGHT_SUBTREE_IS_BIGGER;
    }else{
      return BalanceStatus.AVL_BALANCED;
    }
  }

  ///Balances the current node
  ///
  /// **returns** new root of subtree after rotation, you must go upwards from this new root to balance the tree further upwards
  ///
  /// <a href="https://ibb.co/n3NrmX2"><img src="https://i.ibb.co/cbSJ3W5/image.png" alt="image" border="0"></a>
  /// <br/>
  ///<a href="https://ibb.co/28xFxvm"><img src="https://i.ibb.co/k3jGj4k/image.png" alt="image" border="0"></a>
  ///
  static AVLTreeNode<K> _balance_current_node<K>(AVLTreeNode<K> node,Compare<K> compare) {
    BalanceStatus node_balance = _nodeSubtreeBalance(node);

    switch(node_balance){
      case BalanceStatus.LEFT_SUBTREE_IS_BIGGER:{

        if (node.left.balanceFactor >= 0) {//node's left is again left unbalanced
          return _rightRotation(node: node, compare: compare);
        } else if (node.left.balanceFactor < 0) {
          return _leftRightRotation(node,compare);
        }

        break;
      }

      case BalanceStatus.RIGHT_SUBTREE_IS_BIGGER:{

        if (node.right.balanceFactor <= 0) {//node's right is again right unbalanced
          return _leftRotation(node: node,compare: compare);
        } else if (node.right.balanceFactor > 0) {
          return _rightLeftRotation(node,compare);
        }
        break;
      }

      case BalanceStatus.AVL_BALANCED:{
        return node;
        break;
      }
    }

  }

  ///performs left rotation : see the image to understand meaning of naming convention
  ///
  ///<img src="https://i.ibb.co/SK9xpkZ/image.png" alt="leftRotation" border="0">
  ///
  /// **returns** new root of subtree : **three_node**
  static  AVLTreeNode<K> _leftRotation<K>({AVLTreeNode<K> node, Compare<K> compare}){
    var one_node = node;
    var one_node_parent = one_node.parent;

    if(one_node.right!=null){
      var three_node = one_node.right;
      var two_node = three_node.left;

      three_node.parent= one_node.parent;

      if(one_node_parent!=null){
        var one_node_was = checkWhichChildItIsOfItsParent(one_node, compare);
        if(one_node_was==Is.LEFT_CHILD){
          one_node_parent.left=three_node;
        }else{
          one_node_parent.right=three_node;
        }
      }
      one_node.parent = three_node;
      three_node.left=one_node;

      two_node?.parent = one_node;
      one_node.right = two_node;

      return three_node;
    }
    throw "ERR: during leftRotation of ${one_node?.key}: this condition must never occur,these means there is a problem in logic of this tree!";
  }

  ///performs right rotation : see the image to understand meaning of naming convention
  ///
  ///<img src="https://i.ibb.co/cgtB0p0/image.png" alt="rightRotation" border="0">
  ///
  /// **returns** new root of subtree : **two_node**
  static AVLTreeNode<K> _rightRotation<K>({AVLTreeNode<K> node, Compare<K> compare}){
    var four_node=node;
    var four_node_parent = four_node.parent;

    if(four_node.left!=null){
      var two_node = four_node.left;
      var three_node = two_node.right;

      two_node.parent = four_node.parent;

      if(four_node_parent!=null){
        var four_node_was = checkWhichChildItIsOfItsParent(four_node, compare);
        if(four_node_was==Is.LEFT_CHILD){
          four_node_parent.left = two_node;
        }else{
          four_node_parent.right = two_node;
        }
      }
      
      four_node.parent=two_node;
      two_node.right=four_node;

      three_node?.parent = four_node;
      four_node.left = three_node;

      return two_node;
    }
    throw "ERR: during rightRotation of ${four_node?.key}: this condition must never occur,these means there is a problem in logic of this tree!";
  }

  ///performs left right rotation : see the image to understand meaning of naming convention
  ///
  ///<img src="https://i.ibb.co/wJRwXwW/image.png" alt="leftRightRotation" border="0">
  ///
  /// **returns** new root of subtree : **three_node**
  static AVLTreeNode<K> _leftRightRotation<K>(AVLTreeNode<K> node,Compare<K> compare){
    var four_node = node;

    var two_node = four_node.left;
    var three_node = two_node.right;

    _leftRotation(node: two_node,compare: compare);

    _rightRotation(node: four_node,compare: compare);

    return three_node;
  }

  ///performs right left rotation : see the image to understand meaning of naming convention
  ///
  ///<img src="https://i.ibb.co/zGsqG58/image.png" alt="rightLeftRotation" border="0">
  ///
  /// **returns** new root of subtree : **three_node**
  static  _rightLeftRotation<K>(AVLTreeNode<K> node,Compare<K> compare){

    var two_node = node;

    var four_node = two_node.right;
    var three_node= four_node.left;

    _rightRotation(node: four_node,compare: compare);

    _leftRotation(node: two_node, compare: compare);

    return three_node;
  }

  static Is checkWhichChildItIsOfItsParent<K>(AVLTreeNode<K> node,Compare<K> compare){
    if(node.parent==null){
      return Is.ROOT;
    }
    var r = compare(node.parent.key,node.key);
    if(r>0){
      return Is.LEFT_CHILD;
    }else{
      return Is.RIGHT_CHILD;
    }
  }
}

