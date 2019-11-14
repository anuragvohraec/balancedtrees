import "package:balancedtrees/bplustree/bplustree.dart";
import "package:balancedtrees/comparators/comparators.dart";
import 'util_for_test/utilities_for_testing.dart';
import "package:flutter_test/flutter_test.dart";
import "package:balancedtrees/avltree/avltree.dart";
import 'util_for_test/utilities_for_testing.dart';

main() {

 //Another insertion test, with 5 maximum elements
 test("CASE0: Insertion",(){
  var bpt = giveMeTree(maxNoOfElInANode: 5);

  var startNode = BPlusTreeAlgos.searchForLeafNode(bptree: bpt, searchKey: "n1");

  var t1 = ["n1","n10","n11","n12","n13","n14","n15","n16","n17","n18","n19","n2","n20","n21","n22","n23","n24","n25","n26","n27","n28","n29","n3","n30","n31","n32","n33","n34","n35","n36","n37","n38","n39","n4","n40","n41","n42","n43","n44","n45","n46","n47","n48","n49","n5","n50","n51","n52","n53","n54","n55","n56","n57","n58","n59","n6","n60","n61","n62","n63","n64","n65","n66","n67","n68","n69","n7","n70","n71","n72","n73","n74","n75","n76","n77","n78","n79","n8","n80","n81","n82","n83","n84","n85","n86","n87","n88","n89","n9","n90","n91","n92","n93","n94","n95","n96","n97","n98","n99"];

  var c=0;

  while(startNode!=null){
   var list = List<BPlusCell<String>>();
   AVLTreeAlgos.inorderTraversalSync(startNode: startNode.node.internalCellTree.root, list: list);

   for(var i in list){
    expect(i.key, t1[c]);
    c++;
   }
   startNode=startNode.node.rightSibling;
  }

  expect(bpt.size, 99);//size evaluation
 });

 //have used 99 insertions to test tree on bulk insertion. Do test it with at least 99 or more.
 //THis tree has passed with low load, but fails on higher load in past, so do not remove 99 example loads
 test("CASE1: Insertion",(){
  var bpt = giveMeTree();

  var startNode = BPlusTreeAlgos.searchForLeafNode(bptree: bpt, searchKey: "n1");

  var t1 = ["n1","n10","n11","n12","n13","n14","n15","n16","n17","n18","n19","n2","n20","n21","n22","n23","n24","n25","n26","n27","n28","n29","n3","n30","n31","n32","n33","n34","n35","n36","n37","n38","n39","n4","n40","n41","n42","n43","n44","n45","n46","n47","n48","n49","n5","n50","n51","n52","n53","n54","n55","n56","n57","n58","n59","n6","n60","n61","n62","n63","n64","n65","n66","n67","n68","n69","n7","n70","n71","n72","n73","n74","n75","n76","n77","n78","n79","n8","n80","n81","n82","n83","n84","n85","n86","n87","n88","n89","n9","n90","n91","n92","n93","n94","n95","n96","n97","n98","n99"];

  var c=0;

  while(startNode!=null){
   var list = List<BPlusCell<String>>();
   AVLTreeAlgos.inorderTraversalSync(startNode: startNode.node.internalCellTree.root, list: list);

   for(var i in list){
    expect(i.key, t1[c]);
    c++;
   }
   startNode=startNode.node.rightSibling;
  }

  expect(bpt.size, 99);//size evaluation
 });

 test("CASE2: Search for leafNode",(){
  var bpt = giveMeTree();
  var leafNode = BPlusTreeAlgos.searchForLeafNode(searchKey: "n47", bptree: bpt).toString();

  expect(leafNode,"n42|n43|n44|n45|n46|n47|n48|n49|n5");
 });


 test("CASE2: Search",(){
  var bpt = giveMeTree();
  //exact value
  expect(BPlusTreeAlgos.searchForKey(searchKey: "n47", bptree: bpt).getValue(),65);
  //exact value
  expect(BPlusTreeAlgos.searchForKey(searchKey: "n87", bptree: bpt).getValue(),93);
  //value greater than the largest
  expect(BPlusTreeAlgos.searchForKey(searchKey: "n99999", bptree: bpt).getValue(), 59); //least value matching
  //value lesser than the lowest
  expect(BPlusTreeAlgos.searchForKey(searchKey: "n000", bptree: bpt), null);
  //just lesser than value
  expect(BPlusTreeAlgos.searchForKey(searchKey: "n47.5", bptree: bpt).getValue(), 65);

 });

 test("CASE3: Full Deletion: maxNoOfElInANode 4",(){
  var debugFlag=true;
  var bpt = BPlusTree<String>(capacityOfNode: 4,compare: genUnitSortHelper);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 1, keyToBeInserted: "n7");
  printBPlusTree(message: "After n7", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 2, keyToBeInserted: "n42");
  printBPlusTree(message: "After n42", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 3, keyToBeInserted: "n86");
  printBPlusTree(message: "After n86", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 4, keyToBeInserted: "n22");
  printBPlusTree(message: "After n22", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 5, keyToBeInserted: "n50");
  printBPlusTree(message: "After n50", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 6, keyToBeInserted: "n79");
  printBPlusTree(message: "After n79", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 7, keyToBeInserted: "n39");
  printBPlusTree(message: "After n39", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 8, keyToBeInserted: "n34");
  printBPlusTree(message: "After n34", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 9, keyToBeInserted: "n30");
  printBPlusTree(message: "After n30", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 10, keyToBeInserted: "n13");
  printBPlusTree(message: "After n13", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 11, keyToBeInserted: "n14");
  printBPlusTree(message: "After n14", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 12, keyToBeInserted: "n59");
  printBPlusTree(message: "After n59", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 13, keyToBeInserted: "n95");
  printBPlusTree(message: "After n95", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 14, keyToBeInserted: "n46");
  printBPlusTree(message: "After n46", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 15, keyToBeInserted: "n65");
  printBPlusTree(message: "After n65", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 16, keyToBeInserted: "n85");
  printBPlusTree(message: "After n85", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 17, keyToBeInserted: "n40");
  printBPlusTree(message: "After n40", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 18, keyToBeInserted: "n19");
  printBPlusTree(message: "After n19", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 19, keyToBeInserted: "n20");//unexpected behaviour
  printBPlusTree(message: "After n20", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 20, keyToBeInserted: "n76");
  printBPlusTree(message: "After n76", bptree: bpt);
  BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 21, keyToBeInserted: "n12");
  printBPlusTree(message: "After n12", bptree: bpt);

  printBPlusTree(message: "Before n22", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: Before deletion",level_list: [
   ["n50"],
   ["n14","n22","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n22","n30","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);


  //Case: REDISTRIBUTE_WITH_RIGHT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n22");
  printBPlusTree(message: "After n22", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: REDISTRIBUTE_WITH_RIGHT_SIBLING: n22",level_list: [
   ["n50"],
   ["n14","n30","n39","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n30","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);


  //Case: REDISTRIBUTE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n30");
  printBPlusTree(message: "After n30", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: REDISTRIBUTE_WITH_LEFT_SIBLING: n30",level_list: [
   ["n50"],
   ["n14","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);


  //Case: MERGE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n95");
  printBPlusTree(message: "After n95", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: MERGE_WITH_LEFT_SIBLING: n95",level_list: [
   ["n50"],
   ["n14","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86"],
  ]);


  //Case: MERGE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n86");
  printBPlusTree(message: "After n86", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: MERGE_WITH_LEFT_SIBLING: n86",level_list: [
   ["n50"],
   ["n14","n34","n42","n7"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85"],
  ]);


  //Case: MERGE_WITH_RIGHT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n12");
  printBPlusTree(message: "After n12", bptree: bpt);
  treeAllLevelTester(bptree: bpt, message: "CASE: MERGE_WITH_RIGHT_SIBLING: n12",level_list: [
   ["n50"],
   ["n19","n34","n42","n7"],
   ["n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85"],
  ]);

  //Delete all one by one;
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n7");
  printBPlusTree(message: "After n7", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n50" ],
   ["n19","n34","n42","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n76","n79","n85" ],
  ]);



  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n42");
  printBPlusTree(message: "After n42", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  expect(bpt.size, 21-7);


  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n86");
  printBPlusTree(message: "After n86", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n22");
  printBPlusTree(message: "After n22", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n50");
  printBPlusTree(message: "After n50", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n59","n65","n76","n79","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n79");
  printBPlusTree(message: "After n79", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n39");
  printBPlusTree(message: "After n39", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n40","n46","n59","n65","n76","n85"],

  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n34");
  printBPlusTree(message: "After n34", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n46",""],
   ["n13","n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n30");
  printBPlusTree(message: "After n30", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n46",""],
   ["n13","n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n13");
  printBPlusTree(message: "After n13", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n20","n46",""],
   ["n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n14");
  printBPlusTree(message: "After n14", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n59");
  printBPlusTree(message: "After n59", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n95");
  printBPlusTree(message: "After n95", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n46");
  printBPlusTree(message: "After n46", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n65"],
   ["n19","n20","n40","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n65");
  printBPlusTree(message: "After n65", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n20","n40","n76","n85"],

  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n85");
  printBPlusTree(message: "After n85", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n20","n40","n76"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n40");
  printBPlusTree(message: "After n40", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76"],
   ["n19","n20","n76"],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n19");
  printBPlusTree(message: "After n19", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n20","n76" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n20");
  printBPlusTree(message: "After n20", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   ["n76" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n76");
  printBPlusTree(message: "After n76", bptree: bpt);
  treeAllLevelTester(bptree: bpt,level_list: [
   [],
  ]);
  expect(bpt.size, 21-21);
 });


 test("CASE4: Iterator",(){
  BPlusTree<String> bpt = giveMeTree();
  var itr1 = BPlusTreeLeafIterator<String>(bptree: bpt);
  var t1 = ["n1","n10","n11","n12","n13","n14","n15","n16","n17","n18","n19","n2","n20","n21","n22","n23","n24","n25","n26","n27","n28","n29","n3","n30","n31","n32","n33","n34","n35","n36","n37","n38","n39","n4","n40","n41","n42","n43","n44","n45","n46","n47","n48","n49","n5","n50","n51","n52","n53","n54","n55","n56","n57","n58","n59","n6","n60","n61","n62","n63","n64","n65","n66","n67","n68","n69","n7","n70","n71","n72","n73","n74","n75","n76","n77","n78","n79","n8","n80","n81","n82","n83","n84","n85","n86","n87","n88","n89","n9","n90","n91","n92","n93","n94","n95","n96","n97","n98","n99"];

  int i =0;
  while(itr1.hasSomeMoreItems()){
   expect(itr1.next().key, t1[i]);
   i++;
  }
 });

 test("CASE5: Deletion: maxNoOfElInANode 4",(){
  var bpt = giveMeTree(maxNoOfElInANode: 5);

  print( BPlusTreeAlgos.getHeight(bpt));

  printBPlusTree(bptree: bpt, message: "Before deletion");
  //Case: REDISTRIBUTE_WITH_RIGHT_SIBLING
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n57");
  printBPlusTree(bptree: bpt, message: "After n57");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n81");
  printBPlusTree(bptree: bpt, message: "After n81");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n52");
  printBPlusTree(bptree: bpt, message: "After n52");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n73");
  printBPlusTree(bptree: bpt, message: "After n73");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n97");
  printBPlusTree(bptree: bpt, message: "After n97");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n75");
  printBPlusTree(bptree: bpt, message: "After n75");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n53");
  printBPlusTree(bptree: bpt, message: "After n53");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n74");
  printBPlusTree(bptree: bpt, message: "After n74");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n93");
  printBPlusTree(bptree: bpt, message: "After n93");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n8");
  printBPlusTree(bptree: bpt, message: "After n8");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n27");
  printBPlusTree(bptree: bpt, message: "After n27");
  BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n98");// problem here : entire tree is reduced to zero height at this
  printBPlusTree(bptree: bpt, message: "After n98");
  /*
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n16");
   printBPlusTree(bptree: bpt, message: "After n16");
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n6");
   printBPlusTree(bptree: bpt, message: "After n6");
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n69");
   printBPlusTree(bptree: bpt, message: "After n51");
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n51");
   printBPlusTree(bptree: bpt, message: "After n51");
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n77");
   printBPlusTree(bptree: bpt, message: "After n77");
   BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n90");
   printBPlusTree(bptree: bpt, message: "After n90");
*/
  print( BPlusTreeAlgos.getHeight(bpt));
  printBPlusTree(bptree: bpt);
  internalTreeSize_atLevel_Tester(bpt, level:2);
 });


 test("CASE6: Min and Max of each leaf node 4",(){
  var debugFlag=true;
  var bptree = BPlusTree<String>(capacityOfNode: 4,compare: genUnitSortHelper);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 1, keyToBeInserted: "n7");
  printBPlusTree(message: "After n7", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 2, keyToBeInserted: "n42");
  printBPlusTree(message: "After n42", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 3, keyToBeInserted: "n86");
  printBPlusTree(message: "After n86", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 4, keyToBeInserted: "n22");
  printBPlusTree(message: "After n22", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 5, keyToBeInserted: "n50");
  printBPlusTree(message: "After n50", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 6, keyToBeInserted: "n79");
  printBPlusTree(message: "After n79", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 7, keyToBeInserted: "n39");
  printBPlusTree(message: "After n39", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 8, keyToBeInserted: "n34");
  printBPlusTree(message: "After n34", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 9, keyToBeInserted: "n30");
  printBPlusTree(message: "After n30", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 10, keyToBeInserted: "n13");
  printBPlusTree(message: "After n13", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 11, keyToBeInserted: "n14");
  printBPlusTree(message: "After n14", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 12, keyToBeInserted: "n59");
  printBPlusTree(message: "After n59", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 13, keyToBeInserted: "n95");
  printBPlusTree(message: "After n95", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 14, keyToBeInserted: "n46");
  printBPlusTree(message: "After n46", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 15, keyToBeInserted: "n65");
  printBPlusTree(message: "After n65", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 16, keyToBeInserted: "n85");
  printBPlusTree(message: "After n85", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 17, keyToBeInserted: "n40");
  printBPlusTree(message: "After n40", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 18, keyToBeInserted: "n19");
  printBPlusTree(message: "After n19", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 19, keyToBeInserted: "n20");//unexpected behaviour
  printBPlusTree(message: "After n20", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 20, keyToBeInserted: "n76");
  printBPlusTree(message: "After n76", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 21, keyToBeInserted: "n12");
  printBPlusTree(message: "After n12", bptree: bptree);

  printBPlusTree(message: "Before n22", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: Before deletion",level_list: [
   ["n50"],
   ["n14","n22","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n22","n30","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);

  testMinAndMaxForEachLeafNode(bptree);
  //Case: REDISTRIBUTE_WITH_RIGHT_SIBLING
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n22");
  printBPlusTree(message: "After n22", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: REDISTRIBUTE_WITH_RIGHT_SIBLING: n22",level_list: [
   ["n50"],
   ["n14","n30","n39","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n30","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);


  //Case: REDISTRIBUTE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n30");
  printBPlusTree(message: "After n30", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: REDISTRIBUTE_WITH_LEFT_SIBLING: n30",level_list: [
   ["n50"],
   ["n14","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86","n95"],
  ]);


  //Case: MERGE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n95");
  printBPlusTree(message: "After n95", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: MERGE_WITH_LEFT_SIBLING: n95",level_list: [
   ["n50"],
   ["n14","n34","n42","n7","n86"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85","n86"],
  ]);


  //Case: MERGE_WITH_LEFT_SIBLING
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n86");
  printBPlusTree(message: "After n86", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: MERGE_WITH_LEFT_SIBLING: n86",level_list: [
   ["n50"],
   ["n14","n34","n42","n7"],
   ["n12","n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85"],
  ]);

  testMinAndMaxForEachLeafNode(bptree);

  //Case: MERGE_WITH_RIGHT_SIBLING
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n12");
  printBPlusTree(message: "After n12", bptree: bptree);
  treeAllLevelTester(bptree: bptree, message: "CASE: MERGE_WITH_RIGHT_SIBLING: n12",level_list: [
   ["n50"],
   ["n19","n34","n42","n7"],
   ["n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n7","n76","n79","n85"],
  ]);

  //Delete all one by one;
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n7");
  printBPlusTree(message: "After n7", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n50" ],
   ["n19","n34","n42","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n42","n46","n50","n59","n65","n76","n79","n85" ],
  ]);



  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n42");
  printBPlusTree(message: "After n42", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  expect(bptree.size, 21-7);
  testMinAndMaxForEachLeafNode(bptree);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n86");
  printBPlusTree(message: "After n86", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n22");
  printBPlusTree(message: "After n22", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n59" ],
   ["n19","n34","n46","n76" ],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n50","n59","n65","n76","n79","n85" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n50");
  printBPlusTree(message: "After n50", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n59","n65","n76","n79","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n79");
  printBPlusTree(message: "After n79", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n39","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n39");
  printBPlusTree(message: "After n39", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n34","n46",""],
   ["n13","n14","n19","n20","n34","n40","n46","n59","n65","n76","n85"],

  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n34");
  printBPlusTree(message: "After n34", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n46",""],
   ["n13","n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n30");
  printBPlusTree(message: "After n30", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n46",""],
   ["n13","n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n13");
  printBPlusTree(message: "After n13", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n20","n46",""],
   ["n14","n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n14");
  printBPlusTree(message: "After n14", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n59","n65","n76","n85"],
  ]);
  testMinAndMaxForEachLeafNode(bptree);
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n59");
  printBPlusTree(message: "After n59", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n95");
  printBPlusTree(message: "After n95", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n46",""],
   ["n19","n20","n40","n46","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n46");
  printBPlusTree(message: "After n46", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n65"],
   ["n19","n20","n40","n65","n76","n85"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n65");
  printBPlusTree(message: "After n65", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n20","n40","n76","n85"],

  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n85");
  printBPlusTree(message: "After n85", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n20","n40","n76"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n40");
  printBPlusTree(message: "After n40", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76"],
   ["n19","n20","n76"],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n19");
  printBPlusTree(message: "After n19", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n20","n76" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n20");
  printBPlusTree(message: "After n20", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   ["n76" ],
  ]);

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n76");
  printBPlusTree(message: "After n76", bptree: bptree);
  treeAllLevelTester(bptree: bptree,level_list: [
   [],
  ]);
  expect(bptree.size, 21-21);
 });

 test("CASE7: Oblivation upon left most child removal",(){
  var bptree = giveMeTree(maxNoOfElInANode: 4);
  printBPlusTree(message: "After INSERTION", bptree: bptree);
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n92");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n93");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n87");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n88");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n89");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n9");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n59");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n65");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n79");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n81");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n6");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n60");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n61");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n62");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n66");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n69");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n73");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n78");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n72");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n74");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n84");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n85");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n82");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n77");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n71");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n76");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n7");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n70");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n80");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n8");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n86");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n68");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n58");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n57");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n63");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n55");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n54");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n96");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n99");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n98");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n95");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n91");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n97");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n83");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n94");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n49");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n46");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n47");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n48");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n5");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n75");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n56");
  // if delete n90 it should oblivaite the root
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n90");
  printBPlusTree(message: "After DELETION", bptree: bptree);

  treeAllLevelTester(bptree: bptree,level_list: [
   ["n22","n34","n42"],
   ["n11","n14","n16","n19","n26","n28","n30","n36","n39","n50","n53"],
   ["n1","n10","n11","n12","n13","n14","n15","n16","n17","n18","n19","n2","n20","n21","n22","n23","n24","n25","n26","n27","n28","n29","n3","n30","n31","n32","n33","n34","n35","n36","n37","n38","n39","n4","n40","n41","n42","n43","n44","n45","n50","n51","n52","n53","n64","n67"],
  ]);
 });


 test("CASE8: NoSuchMethodError: The getter 'right' was called on null.",(){
  var bptree = giveMeTree(maxNoOfElInANode: 4);
  printBPlusTree(message: "After INSERTION", bptree: bptree);
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n92");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n93");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n87");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n88");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n89");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n9");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n59");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n65");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n79");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n81");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n6");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n60");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n61");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n62");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n66");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n69");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n73");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n78");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n72");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n74");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n84");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n85");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n82");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n77");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n71");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n76");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n7");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n70");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n80");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n8");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n86");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n68");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n58");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n57");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n63");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n55");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n54");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n96");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n99");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n98");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n95");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n91");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n97");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n83");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n94");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n49");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n46");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n47");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n48");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n5");

  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n75");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n56");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n29");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n3");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n33");
  BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: "n32");

  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 1, keyToBeInserted: "n91");
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 1, keyToBeInserted: "n92");
  printBPlusTree(message: "After n92", bptree: bptree);
  BPlusTreeAlgos.insert(bptree: bptree, valueToBeInserted: 1, keyToBeInserted: "n93");

  printBPlusTree(message: "After DELETION", bptree: bptree);

 });
 //Inspite of merge Source remain in tree, especially when its LMC

}


BPlusTree<String> giveMeTree({maxNoOfElInANode=11}){
 var bpt = BPlusTree<String>(capacityOfNode: maxNoOfElInANode,compare: genUnitSortHelper);
 //printBPlusTree(message: "After", bptree: bpt);
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 1, keyToBeInserted: "n7");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 2, keyToBeInserted: "n42");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 3, keyToBeInserted: "n86");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 4, keyToBeInserted: "n22");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 5, keyToBeInserted: "n50");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 6, keyToBeInserted: "n79");
 BPlusTreeAlgos.insert( bptree: bpt, valueToBeInserted: 7, keyToBeInserted: "n39");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 8, keyToBeInserted: "n34");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 9, keyToBeInserted: "n30");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 10, keyToBeInserted: "n13");
 //printBPlusTree(message: "After10", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 11, keyToBeInserted: "n14");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 12, keyToBeInserted: "n59");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 13, keyToBeInserted: "n95");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 14, keyToBeInserted: "n46");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 15, keyToBeInserted: "n65");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 16, keyToBeInserted: "n85");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 17, keyToBeInserted: "n40");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 18, keyToBeInserted: "n19");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 19, keyToBeInserted: "n20");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 20, keyToBeInserted: "n76");
 //printBPlusTree(message: "After20", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 21, keyToBeInserted: "n11");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 22, keyToBeInserted: "n57");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 23, keyToBeInserted: "n81");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 24, keyToBeInserted: "n52");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 25, keyToBeInserted: "n73");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 26, keyToBeInserted: "n97");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 29, keyToBeInserted: "n74");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 27, keyToBeInserted: "n75");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 28, keyToBeInserted: "n53");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 30, keyToBeInserted: "n93");
 //printBPlusTree(message: "After30", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 31, keyToBeInserted: "n8");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 32, keyToBeInserted: "n27");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 33, keyToBeInserted: "n98");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 34, keyToBeInserted: "n16");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 35, keyToBeInserted: "n6");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 36, keyToBeInserted: "n69");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 37, keyToBeInserted: "n51");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 38, keyToBeInserted: "n77");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 39, keyToBeInserted: "n90");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 40, keyToBeInserted: "n28");
 //printBPlusTree(message: "After40", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 41, keyToBeInserted: "n83");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 42, keyToBeInserted: "n89");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 43, keyToBeInserted: "n88");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 44, keyToBeInserted: "n67");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 45, keyToBeInserted: "n84");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 46, keyToBeInserted: "n26");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 47, keyToBeInserted: "n92");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 48, keyToBeInserted: "n18");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 49, keyToBeInserted: "n38");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 50, keyToBeInserted: "n78");
 //printBPlusTree(message: "After50", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 51, keyToBeInserted: "n33");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 52, keyToBeInserted: "n5");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 53, keyToBeInserted: "n4");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 54, keyToBeInserted: "n96");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 55, keyToBeInserted: "n68");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 56, keyToBeInserted: "n29");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 57, keyToBeInserted: "n3");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 58, keyToBeInserted: "n72");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 59, keyToBeInserted: "n99");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 60, keyToBeInserted: "n71");
 //printBPlusTree(message: "After60", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 61, keyToBeInserted: "n60");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 62, keyToBeInserted: "n54");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 63, keyToBeInserted: "n10");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 64, keyToBeInserted: "n91");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 65, keyToBeInserted: "n47");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 66, keyToBeInserted: "n24");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 67, keyToBeInserted: "n56");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 68, keyToBeInserted: "n44");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 69, keyToBeInserted: "n21");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 70, keyToBeInserted: "n25");
 //printBPlusTree(message: "After70", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 71, keyToBeInserted: "n41");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 72, keyToBeInserted: "n17");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 73, keyToBeInserted: "n64");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 74, keyToBeInserted: "n36");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 75, keyToBeInserted: "n43");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 76, keyToBeInserted: "n63");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 77, keyToBeInserted: "n9");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 78, keyToBeInserted: "n55");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 79, keyToBeInserted: "n61");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 80, keyToBeInserted: "n94");
 //printBPlusTree(message: "After80", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 81, keyToBeInserted: "n1");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 82, keyToBeInserted: "n66");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 83, keyToBeInserted: "n12");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 84, keyToBeInserted: "n58");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 85, keyToBeInserted: "n15");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 86, keyToBeInserted: "n48");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 87, keyToBeInserted: "n80");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 88, keyToBeInserted: "n62");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 89, keyToBeInserted: "n23");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 90, keyToBeInserted: "n35");
 //printBPlusTree(message: "After90", bptree: bpt);

 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 91, keyToBeInserted: "n32");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 92, keyToBeInserted: "n45");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 93, keyToBeInserted: "n87");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 94, keyToBeInserted: "n31");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 95, keyToBeInserted: "n70");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 96, keyToBeInserted: "n37");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 97, keyToBeInserted: "n49");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 98, keyToBeInserted: "n82");
 BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 99, keyToBeInserted: "n2");
 //printBPlusTree(message: "After99", bptree: bpt);
 return bpt;
}
