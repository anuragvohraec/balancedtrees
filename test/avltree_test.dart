import "package:flutter_test/flutter_test.dart";
import "package:balancedtrees/avltree/avltree.dart";
import "package:balancedtrees/comparators/comparators.dart";
import 'util_for_test/utilities_for_testing.dart';


main() async{
  var atr = AVLTree<String>(compare: genUnitSortHelper);

  AVLTreeAlgos.insert(newKey: "n4",tree: atr);
  AVLTreeAlgos.insert(newKey: "n9",tree: atr);
  AVLTreeAlgos.insert(newKey: "n1",tree: atr);
  AVLTreeAlgos.insert(newKey: "n6",tree: atr);
  AVLTreeAlgos.insert(newKey: "n8",tree: atr);
  AVLTreeAlgos.insert(newKey: "n5",tree: atr);
  AVLTreeAlgos.insert(newKey: "n3",tree: atr);
  AVLTreeAlgos.insert(newKey: "n6",tree: atr);
  AVLTreeAlgos.insert(newKey: "n91",tree: atr);
  AVLTreeAlgos.insert(newKey: "n92",tree: atr);
  AVLTreeAlgos.insert(newKey: "n93",tree: atr);
  AVLTreeAlgos.insert(newKey: "n94",tree: atr);


  test("CASE0: Blance after insertion",(){
    expect(atr.size, 12); //match the size
    expect(atr.root.leftSubtreeHeight, 3);//left subtree height
    expect(atr.root.rightSubtreeHeight, 3);//right subtree height
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.left),4);
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.right), 7);
    expect(atr.root.key, "n6");
  });

  test("CASE1: insertion test",(){
    expect(12,atr.size);
  });

  test("CASE1.1: After insertion min and max",(){
    expect(atr.min.key, "n1");
    expect(atr.max.key, "n94");
  });


  test("CASE2: search exact",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n6", tree: atr);
    expect(t.key, "n6");
  });

  test("CASE3: search a key in left subtree, just greater than",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n2", tree: atr);
    expect(t.key, "n3");
  });

  test("CASE4: search a key in left subtree, just greater than",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n05", tree: atr);
    expect(t.key, "n1");
  });

  test("CASE5: search a key in right subtree, just greater than",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n7", tree: atr);
    expect(t.key, "n8");
  });

  test("CASE6: search a key in right subtree, just greater than",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n82", tree: atr);
    expect(t.key, "n9");
  });

  test("CASE7: search key smaller than smallest",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n0", tree: atr);
    expect(t.key, "n1");
  });

  test("CASE8: search key bigger than biggest",(){
    var t =AVLTreeAlgos.searchGTE(searchKey: "n99", tree: atr);
    expect(t, null);
  });

  test("CASE9: deletion test",(){
    AVLTreeAlgos.delete(keyToBeDeleted: "n1", tree: atr);
    expect(atr.size,11);
  });


  test("CASE10: test heights",(){
    expect(atr.root.height, 3);
    expect(atr.root.leftSubtreeHeight, 2);
    expect(atr.root.rightSubtreeHeight, 3);
  });

  test("CASE11: test finMin",(){
    expect(AVLTreeAlgos.findMin(atr).key, "n3");
  });

  test("CASE11: test findMax",(){
    expect(AVLTreeAlgos.findMax(atr).key, "n94");
  });

  test("CASE11.1: test max and min after deletion",(){
    var atr1 = AVLTree<String>(compare: genUnitSortHelper);

    AVLTreeAlgos.insert(newKey: "n4",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n9",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n1",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n6",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n8",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n5",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n3",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n6",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n91",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n92",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n93",tree: atr1);
    AVLTreeAlgos.insert(newKey: "n94",tree: atr1);

    AVLTreeAlgos.delete(keyToBeDeleted: "n1", tree: atr1);
    AVLTreeAlgos.delete(keyToBeDeleted: "n94", tree: atr1);
    expect(atr1.min.key, "n3");
    expect(atr1.max.key, "n93");

    AVLTreeAlgos.delete(keyToBeDeleted: "n3", tree: atr1);
    AVLTreeAlgos.delete(keyToBeDeleted: "n93", tree: atr1);
    expect(atr1.min.key, "n4");
    expect(atr1.max.key, "n92");

    AVLTreeAlgos.delete(keyToBeDeleted: "n5", tree: atr1);
    AVLTreeAlgos.delete(keyToBeDeleted: "n6", tree: atr1);
    expect(atr1.min.key, "n4");
    expect(atr1.max.key, "n92");
  });

  test("CASE12: just lesser than or equal in left subtree",(){
    expect(AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: "n35", tree: atr).key,"n3");
  });

  test("CASE13: just lesser than or equal in right subtree",(){
    expect(AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: "n85", tree: atr).key,"n8");
  });

  test("CASE14: lesser than least in left subtree, test searchJustLesserThanOrEqual",(){
    expect(AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: "n0", tree: atr)?.key,null);
  });

  test("CASE15: greater than biggest in right subtree, test searchJustLesserThanOrEqual",(){
    expect(AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey: "n99", tree: atr)?.key,"n94");
  });

  test("CASE16: recalculate size",(){
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root),atr.size);
  });

  test("CASE17: Only root present, test deletion",(){
    var atr2 = AVLTree<String>(compare: genUnitSortHelper);
    AVLTreeAlgos.insert(newKey: "n1", tree: atr2);
    AVLTreeAlgos.delete(keyToBeDeleted: "n1", tree: atr2);
    int s =AVLTreeAlgos.reCalculateSize(startNode: atr2.root);
    expect(s, 0);
  });

  test("CASE18: Only root with right child present, test deletion",(){
    var atr2 = AVLTree<String>(compare: genUnitSortHelper);
    AVLTreeAlgos.insert(newKey: "n1", tree: atr2);
    AVLTreeAlgos.insert(newKey: "n2", tree: atr2);
    AVLTreeAlgos.delete(keyToBeDeleted: "n1", tree: atr2);
    int s =AVLTreeAlgos.reCalculateSize(startNode: atr2.root);
    expect(s, 1);
    expect(atr2.root.key.toString(),"n2");
  });

  test("CASE19: Only root with left child present, test deletion",(){
    var atr2 = AVLTree<String>(compare: genUnitSortHelper);
    AVLTreeAlgos.insert(newKey: "n4", tree: atr2);
    AVLTreeAlgos.insert(newKey: "n2", tree: atr2);
    AVLTreeAlgos.delete(keyToBeDeleted: "n4", tree: atr2);
    int s =AVLTreeAlgos.reCalculateSize(startNode: atr2.root);
    expect(s, 1);
    expect(atr2.root.key.toString(),"n2");
  });

  test("CASE20: Test forward Iterator for AVL tree",(){
    var atr3  = AVLTree<String>(compare: genUnitSortHelper);
    AVLTreeAlgos.insert(newKey: "n3", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n2", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n1", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n6", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n4", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n5", tree: atr3);
    var t2 = ["n1","n2","n3","n4","n5","n6"];
    var iterator = AVLTreeIterator<String>(tree: atr3);
    var i =0;
    while(iterator.hasSomeMoreItems()){
      var t1 = iterator.next();
      expect(t1.key, t2[i]);
      i++;
    }
  });

  test("CASE21: Test reverse Iterator for AVL tree",(){
    var atr3  = AVLTree<String>(compare: genUnitSortHelper);
    AVLTreeAlgos.insert(newKey: "n3", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n2", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n1", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n6", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n4", tree: atr3);
    AVLTreeAlgos.insert(newKey: "n5", tree: atr3);
    var t2 = ["n6","n5","n4","n3","n2","n1"];
    var iterator = AVLTreeIterator<String>(tree: atr3, isForwardIterator: false);
    var i =0;
    while(iterator.hasSomeMoreItems()){
      var t1 = iterator.previous();
      expect(t1.key, t2[i]);
      i++;
    }
  });

  test("CASE22: Test in order traversal using iterator",(){
    var atr = AVLTree<String>(compare: genUnitSortHelper);

    AVLTreeAlgos.insert(newKey: "n7", tree: atr);
    AVLTreeAlgos.insert(newKey: "n42", tree: atr);
    AVLTreeAlgos.insert(newKey: "n86", tree: atr);
    AVLTreeAlgos.insert(newKey: "n22", tree: atr);
    AVLTreeAlgos.insert(newKey: "n50", tree: atr);
    AVLTreeAlgos.insert(newKey: "n79", tree: atr);
    AVLTreeAlgos.insert(newKey: "n39", tree: atr);
    AVLTreeAlgos.insert(newKey: "n34", tree: atr);
    AVLTreeAlgos.insert(newKey: "n30", tree: atr);
    AVLTreeAlgos.insert(newKey: "n13", tree: atr);
    AVLTreeAlgos.insert(newKey: "n14", tree: atr);
    AVLTreeAlgos.insert(newKey: "n59", tree: atr);
    AVLTreeAlgos.insert(newKey: "n95", tree: atr);
    AVLTreeAlgos.insert(newKey: "n46", tree: atr);
    AVLTreeAlgos.insert(newKey: "n65", tree: atr);
    AVLTreeAlgos.insert(newKey: "n85", tree: atr);
    AVLTreeAlgos.insert(newKey: "n40", tree: atr);
    AVLTreeAlgos.insert(newKey: "n19", tree: atr);
    AVLTreeAlgos.insert(newKey: "n20", tree: atr);
    AVLTreeAlgos.insert(newKey: "n76", tree: atr);
    AVLTreeAlgos.insert(newKey: "n11", tree: atr);
    AVLTreeAlgos.insert(newKey: "n57", tree: atr);
    AVLTreeAlgos.insert(newKey: "n81", tree: atr);
    AVLTreeAlgos.insert(newKey: "n52", tree: atr);
    AVLTreeAlgos.insert(newKey: "n73", tree: atr);
    AVLTreeAlgos.insert(newKey: "n97", tree: atr);
    AVLTreeAlgos.insert(newKey: "n75", tree: atr);
    AVLTreeAlgos.insert(newKey: "n53", tree: atr);
    AVLTreeAlgos.insert(newKey: "n74", tree: atr);
    AVLTreeAlgos.insert(newKey: "n93", tree: atr);
    AVLTreeAlgos.insert(newKey: "n8", tree: atr);
    AVLTreeAlgos.insert(newKey: "n27", tree: atr);
    AVLTreeAlgos.insert(newKey: "n98", tree: atr);
    AVLTreeAlgos.insert(newKey: "n16", tree: atr);
    AVLTreeAlgos.insert(newKey: "n6", tree: atr);
    AVLTreeAlgos.insert(newKey: "n69", tree: atr);
    AVLTreeAlgos.insert(newKey: "n51", tree: atr);
    AVLTreeAlgos.insert(newKey: "n77", tree: atr);
    AVLTreeAlgos.insert(newKey: "n90", tree: atr);
    AVLTreeAlgos.insert(newKey: "n28", tree: atr);
    AVLTreeAlgos.insert(newKey: "n83", tree: atr);
    AVLTreeAlgos.insert(newKey: "n89", tree: atr);
    AVLTreeAlgos.insert(newKey: "n88", tree: atr);
    AVLTreeAlgos.insert(newKey: "n67", tree: atr);
    AVLTreeAlgos.insert(newKey: "n84", tree: atr);
    AVLTreeAlgos.insert(newKey: "n26", tree: atr);
    AVLTreeAlgos.insert(newKey: "n92", tree: atr);
    AVLTreeAlgos.insert(newKey: "n18", tree: atr);
    AVLTreeAlgos.insert(newKey: "n38", tree: atr);
    AVLTreeAlgos.insert(newKey: "n78", tree: atr);
    AVLTreeAlgos.insert(newKey: "n33", tree: atr);
    AVLTreeAlgos.insert(newKey: "n5", tree: atr);
    AVLTreeAlgos.insert(newKey: "n4", tree: atr);
    AVLTreeAlgos.insert(newKey: "n96", tree: atr);
    AVLTreeAlgos.insert(newKey: "n68", tree: atr);
    AVLTreeAlgos.insert(newKey: "n29", tree: atr);
    AVLTreeAlgos.insert(newKey: "n3", tree: atr);
    AVLTreeAlgos.insert(newKey: "n72", tree: atr);
    AVLTreeAlgos.insert(newKey: "n99", tree: atr);
    AVLTreeAlgos.insert(newKey: "n71", tree: atr);
    AVLTreeAlgos.insert(newKey: "n60", tree: atr);
    AVLTreeAlgos.insert(newKey: "n54", tree: atr);
    AVLTreeAlgos.insert(newKey: "n10", tree: atr);
    AVLTreeAlgos.insert(newKey: "n91", tree: atr);
    AVLTreeAlgos.insert(newKey: "n47", tree: atr);
    AVLTreeAlgos.insert(newKey: "n24", tree: atr);
    AVLTreeAlgos.insert(newKey: "n56", tree: atr);
    AVLTreeAlgos.insert(newKey: "n44", tree: atr);
    AVLTreeAlgos.insert(newKey: "n21", tree: atr);
    AVLTreeAlgos.insert(newKey: "n25", tree: atr);
    AVLTreeAlgos.insert(newKey: "n41", tree: atr);
    AVLTreeAlgos.insert(newKey: "n17", tree: atr);
    AVLTreeAlgos.insert(newKey: "n64", tree: atr);
    AVLTreeAlgos.insert(newKey: "n36", tree: atr);
    AVLTreeAlgos.insert(newKey: "n43", tree: atr);
    AVLTreeAlgos.insert(newKey: "n63", tree: atr);
    AVLTreeAlgos.insert(newKey: "n9", tree: atr);
    AVLTreeAlgos.insert(newKey: "n55", tree: atr);
    AVLTreeAlgos.insert(newKey: "n61", tree: atr);
    AVLTreeAlgos.insert(newKey: "n94", tree: atr);
    AVLTreeAlgos.insert(newKey: "n1", tree: atr);
    AVLTreeAlgos.insert(newKey: "n66", tree: atr);
    AVLTreeAlgos.insert(newKey: "n12", tree: atr);
    AVLTreeAlgos.insert(newKey: "n58", tree: atr);
    AVLTreeAlgos.insert(newKey: "n15", tree: atr);
    AVLTreeAlgos.insert(newKey: "n48", tree: atr);
    AVLTreeAlgos.insert(newKey: "n80", tree: atr);
    AVLTreeAlgos.insert(newKey: "n62", tree: atr);
    AVLTreeAlgos.insert(newKey: "n23", tree: atr);
    AVLTreeAlgos.insert(newKey: "n35", tree: atr);
    AVLTreeAlgos.insert(newKey: "n32", tree: atr);
    AVLTreeAlgos.insert(newKey: "n45", tree: atr);
    AVLTreeAlgos.insert(newKey: "n87", tree: atr);
    AVLTreeAlgos.insert(newKey: "n31", tree: atr);
    AVLTreeAlgos.insert(newKey: "n70", tree: atr);
    AVLTreeAlgos.insert(newKey: "n37", tree: atr);
    AVLTreeAlgos.insert(newKey: "n49", tree: atr);
    AVLTreeAlgos.insert(newKey: "n82", tree: atr);
    AVLTreeAlgos.insert(newKey: "n2", tree: atr);

    var list_of_sorted_el = ["n1",	"n10",	"n11",	"n12",	"n13",	"n14",	"n15",	"n16",	"n17",	"n18",	"n19",	"n2",	"n20",	"n21",	"n22",	"n23",	"n24",	"n25",	"n26",	"n27",	"n28",	"n29",	"n3",	"n30",	"n31",	"n32",	"n33",	"n34",	"n35",	"n36",	"n37",	"n38",	"n39",	"n4",	"n40",	"n41",	"n42",	"n43",	"n44",	"n45",	"n46",	"n47",	"n48",	"n49",	"n5",	"n50",	"n51",	"n52",	"n53",	"n54",	"n55",	"n56",	"n57",	"n58",	"n59",	"n6",	"n60",	"n61",	"n62",	"n63",	"n64",	"n65",	"n66",	"n67",	"n68",	"n69",	"n7",	"n70",	"n71",	"n72",	"n73",	"n74",	"n75",	"n76",	"n77",	"n78",	"n79",	"n8",	"n80",	"n81",	"n82",	"n83",	"n84",	"n85",	"n86",	"n87",	"n88",	"n89",	"n9",	"n90",	"n91",	"n92",	"n93",	"n94",	"n95",	"n96",	"n97",	"n98",	"n99"];

    var iterator = AVLTreeIterator<String>(tree: atr);
    int i=0;
    while(iterator.hasSomeMoreItems()){
      var t1 = iterator.next();
      expect(t1.key, list_of_sorted_el[i]);
      i++;
    }
  });

  test("CASE23: LOAD testing , insertion [n1-n99 in random order], deletion",(){
    var atr = AVLTree<String>(compare: genUnitSortHelper);
    //below are value from n1-n99 in random order
    AVLTreeAlgos.insert(newKey: "n7",tree: atr);
    AVLTreeAlgos.insert(newKey: "n42",tree: atr);
    AVLTreeAlgos.insert(newKey: "n86",tree: atr);
    AVLTreeAlgos.insert(newKey: "n22",tree: atr);
    AVLTreeAlgos.insert(newKey: "n50",tree: atr);
    AVLTreeAlgos.insert(newKey: "n79",tree: atr);
    AVLTreeAlgos.insert(newKey: "n39",tree: atr);
    AVLTreeAlgos.insert(newKey: "n34",tree: atr);
    AVLTreeAlgos.insert(newKey: "n30",tree: atr);
    AVLTreeAlgos.insert(newKey: "n13",tree: atr);
    AVLTreeAlgos.insert(newKey: "n14",tree: atr);
    AVLTreeAlgos.insert(newKey: "n59",tree: atr);
    AVLTreeAlgos.insert(newKey: "n95",tree: atr);
    AVLTreeAlgos.insert(newKey: "n46",tree: atr);
    AVLTreeAlgos.insert(newKey: "n65",tree: atr);
    AVLTreeAlgos.insert(newKey: "n85",tree: atr);
    AVLTreeAlgos.insert(newKey: "n40",tree: atr);
    AVLTreeAlgos.insert(newKey: "n19",tree: atr);
    AVLTreeAlgos.insert(newKey: "n20",tree: atr);
    AVLTreeAlgos.insert(newKey: "n76",tree: atr);
    AVLTreeAlgos.insert(newKey: "n11",tree: atr);
    AVLTreeAlgos.insert(newKey: "n57",tree: atr);
    AVLTreeAlgos.insert(newKey: "n81",tree: atr);
    AVLTreeAlgos.insert(newKey: "n52",tree: atr);
    AVLTreeAlgos.insert(newKey: "n73",tree: atr);
    AVLTreeAlgos.insert(newKey: "n97",tree: atr);
    AVLTreeAlgos.insert(newKey: "n75",tree: atr);
    AVLTreeAlgos.insert(newKey: "n53",tree: atr);
    AVLTreeAlgos.insert(newKey: "n74",tree: atr);
    AVLTreeAlgos.insert(newKey: "n93",tree: atr);
    AVLTreeAlgos.insert(newKey: "n8",tree: atr);
    AVLTreeAlgos.insert(newKey: "n27",tree: atr);
    AVLTreeAlgos.insert(newKey: "n98",tree: atr);
    AVLTreeAlgos.insert(newKey: "n16",tree: atr);
    AVLTreeAlgos.insert(newKey: "n6",tree: atr);
    AVLTreeAlgos.insert(newKey: "n69",tree: atr);
    AVLTreeAlgos.insert(newKey: "n51",tree: atr);
    AVLTreeAlgos.insert(newKey: "n77",tree: atr);
    AVLTreeAlgos.insert(newKey: "n90",tree: atr);
    AVLTreeAlgos.insert(newKey: "n28",tree: atr);
    AVLTreeAlgos.insert(newKey: "n83",tree: atr);
    AVLTreeAlgos.insert(newKey: "n89",tree: atr);
    AVLTreeAlgos.insert(newKey: "n88",tree: atr);
    AVLTreeAlgos.insert(newKey: "n67",tree: atr);
    AVLTreeAlgos.insert(newKey: "n84",tree: atr);
    AVLTreeAlgos.insert(newKey: "n26",tree: atr);
    AVLTreeAlgos.insert(newKey: "n92",tree: atr);
    AVLTreeAlgos.insert(newKey: "n18",tree: atr);
    AVLTreeAlgos.insert(newKey: "n38",tree: atr);
    AVLTreeAlgos.insert(newKey: "n78",tree: atr);
    AVLTreeAlgos.insert(newKey: "n33",tree: atr);
    AVLTreeAlgos.insert(newKey: "n5",tree: atr);
    AVLTreeAlgos.insert(newKey: "n4",tree: atr);
    AVLTreeAlgos.insert(newKey: "n96",tree: atr);
    AVLTreeAlgos.insert(newKey: "n68",tree: atr);
    AVLTreeAlgos.insert(newKey: "n29",tree: atr);
    AVLTreeAlgos.insert(newKey: "n3",tree: atr);
    AVLTreeAlgos.insert(newKey: "n72",tree: atr);
    AVLTreeAlgos.insert(newKey: "n99",tree: atr);
    AVLTreeAlgos.insert(newKey: "n71",tree: atr);
    AVLTreeAlgos.insert(newKey: "n60",tree: atr);
    AVLTreeAlgos.insert(newKey: "n54",tree: atr);
    AVLTreeAlgos.insert(newKey: "n10",tree: atr);
    AVLTreeAlgos.insert(newKey: "n91",tree: atr);
    AVLTreeAlgos.insert(newKey: "n47",tree: atr);
    AVLTreeAlgos.insert(newKey: "n24",tree: atr);
    AVLTreeAlgos.insert(newKey: "n56",tree: atr);
    AVLTreeAlgos.insert(newKey: "n44",tree: atr);
    AVLTreeAlgos.insert(newKey: "n21",tree: atr);
    AVLTreeAlgos.insert(newKey: "n25",tree: atr);
    AVLTreeAlgos.insert(newKey: "n41",tree: atr);
    AVLTreeAlgos.insert(newKey: "n17",tree: atr);
    AVLTreeAlgos.insert(newKey: "n64",tree: atr);
    AVLTreeAlgos.insert(newKey: "n36",tree: atr);
    AVLTreeAlgos.insert(newKey: "n43",tree: atr);
    AVLTreeAlgos.insert(newKey: "n63",tree: atr);
    AVLTreeAlgos.insert(newKey: "n9",tree: atr);
    AVLTreeAlgos.insert(newKey: "n55",tree: atr);
    AVLTreeAlgos.insert(newKey: "n61",tree: atr);
    AVLTreeAlgos.insert(newKey: "n94",tree: atr);
    AVLTreeAlgos.insert(newKey: "n1",tree: atr);
    AVLTreeAlgos.insert(newKey: "n66",tree: atr);
    AVLTreeAlgos.insert(newKey: "n12",tree: atr);
    AVLTreeAlgos.insert(newKey: "n58",tree: atr);
    AVLTreeAlgos.insert(newKey: "n15",tree: atr);
    AVLTreeAlgos.insert(newKey: "n48",tree: atr);
    AVLTreeAlgos.insert(newKey: "n80",tree: atr);
    AVLTreeAlgos.insert(newKey: "n62",tree: atr);
    AVLTreeAlgos.insert(newKey: "n23",tree: atr);
    AVLTreeAlgos.insert(newKey: "n35",tree: atr);
    AVLTreeAlgos.insert(newKey: "n32",tree: atr);
    AVLTreeAlgos.insert(newKey: "n45",tree: atr);
    AVLTreeAlgos.insert(newKey: "n87",tree: atr);
    AVLTreeAlgos.insert(newKey: "n31",tree: atr);
    AVLTreeAlgos.insert(newKey: "n70",tree: atr);
    AVLTreeAlgos.insert(newKey: "n37",tree: atr);
    AVLTreeAlgos.insert(newKey: "n49",tree: atr);
    AVLTreeAlgos.insert(newKey: "n82",tree: atr);
    AVLTreeAlgos.insert(newKey: "n2",tree: atr);

    expect(atr.size, 99); //match the size
    expect(atr.root.leftSubtreeHeight, 7);//left subtree height
    expect(atr.root.rightSubtreeHeight, 7);//right subtree height
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.left),45);
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.right), 53);
    expect(atr.root.key, "n50");


    //delting 35 items from tree [36 selected randomly]

    AVLTreeAlgos.delete(keyToBeDeleted: "n57", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n81", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n52", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n73", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n97", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n75", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n53", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n74", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n93", tree: atr);//n7 right child gone
    AVLTreeAlgos.delete(keyToBeDeleted: "n8", tree: atr);

    AVLTreeAlgos.delete(keyToBeDeleted: "n27", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n98", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n16", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n6", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n69", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n51", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n77", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n90", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n28", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n83", tree: atr);

    AVLTreeAlgos.delete(keyToBeDeleted: "n89", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n88", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n67", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n84", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n26", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n92", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n18", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n38", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n78", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n33", tree: atr);

    AVLTreeAlgos.delete(keyToBeDeleted: "n5", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n4", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n96", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n68", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n29", tree: atr);
    AVLTreeAlgos.delete(keyToBeDeleted: "n50", tree: atr);

    expect(atr.size, 99-36); //match the size
    expect(atr.root.leftSubtreeHeight, 6);//left subtree height
    expect(atr.root.rightSubtreeHeight, 6);//right subtree height
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.left),34);
    expect(AVLTreeAlgos.reCalculateSize(startNode: atr.root.right), 28);
    expect(atr.root.key, "n49");

    //todo verifiy elemnt by inorder traversal
    var list_of_sorted_el = ["n1",	"n10",	"n11",	"n12",	"n13",	"n14",	"n15",	"n17",	"n19",	"n2",	"n20",	"n21",	"n22",	"n23",	"n24",	"n25",	"n3",	"n30",	"n31",	"n32",	"n34",	"n35",	"n36",	"n37",	"n39",	"n40",	"n41",	"n42",	"n43",	"n44",	"n45",	"n46",	"n47",	"n48",	"n49",	"n54",	"n55",	"n56",	"n58",	"n59",	"n60",	"n61",	"n62",	"n63",	"n64",	"n65",	"n66",	"n7",	"n70",	"n71",	"n72",	"n76",	"n79",	"n80",	"n82",	"n85",	"n86",	"n87",	"n9",	"n91",	"n94",	"n95",	"n99"];

    var iterator = AVLTreeIterator<String>(tree: atr);
    int i=0;
    while(iterator.hasSomeMoreItems()){
      var t1 = iterator.next();
      expect(t1.key, list_of_sorted_el[i]);
      i++;
    }

  });

  test("CASE24: Bug fix, where in during deletion[case: node has both child], after deletion new node has itself as its parent, which created infinite loop while checkAndBalance after deletion", (){
    //this issue was found in while using it it BPlus tree, for the following below case
    var items = ["n503928","n50392","n503914","n503912","n503911","n503913","n503917","n503916","n503915","n503919","n503918","n503923","n503921","n503920","n503922","n503925","n503924","n503926","n503927","n503939","n503931","n50393","n503929","n503930","n503935","n503933","n503932","n503934","n503937","n503936","n503938","n503943","n503940","n50394","n503942","n503941","n503946","n503945","n503944","n503948","n503947","n503949"];
    var atr = AVLTree<String>(compare: genUnitSortHelper);
    for(var i in items){
      AVLTreeAlgos.insertWithoutBalance(newKey: i, tree: atr);
    }

    var t1 = AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey:  "n503946", tree: atr);
    expect(t1.parent.key,"n503943");
    expect(t1.left.key,"n503945");
    expect(t1.right.key,"n503948");
    //preorderTraversalPrettyPrint(atr);

    AVLTreeAlgos.delete(tree: atr, keyToBeDeleted: "n503946");
    t1 = AVLTreeAlgos.searchJustLesserThanOrEqual(searchKey:  "n503945", tree: atr);
    expect(t1.parent.key,"n503943");
    expect(t1.left.key,"n503944");
    expect(t1.right.key,"n503948");
    //preorderTraversalPrettyPrint(atr);
  });

  test("CASE25: Bug fix, during load deletion test, the reverse iterator was gving error", (){
    //this issue was found in while using it it BPlus tree, for the following below case
    var items = ["n231408","n228778","n227497","n226985","n226626","n226504","n226390","n226815","n226725","n226910","n227180","n227062","n227343","n227294","n227406","n228029","n227749","n227608","n227688","n227878","n227824","n227947","n227875","n228395","n228212","n228118","n228317","n228552","n228481","n228667","n229913","n229224","n229049","n22893","n229125","n229615","n229461","n229366","n229536","n229696","n22983","n230697","n230304","n230125","n23000","n230220","n230500","n230419","n230573","n231055","n230815","n230957","n231124","n231272","n233082","n232348","n231897","n231626","n231513","n231757","n232150","n232010","n232229","n232742","n232552","n232450","n23266","n232947","n232857","n233922","n233559","n233327","n233232","n233440","n233705","n233834","n234702","n234286","n23409","n23419","n234430","n234574","n234860","n234994"];
    var atr = AVLTree<String>(compare: genUnitSortHelper);
    for(var i in items){
      AVLTreeAlgos.insertWithoutBalance(newKey: i, tree: atr);
    }

    print(preorderTraversalPrettyTreeView(atr, showStats: true));
  });

}
