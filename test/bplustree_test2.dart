

import 'package:balancedtrees/balancedtrees.dart';
import 'package:balancedtrees/util/util.dart';
import 'package:flutter_test/flutter_test.dart';

main(){

  test("CASE1: Use of custom comparator", (){
    var bpt = BPlusTree<Map<String,int>>(capacityOfNode: 4, compare: (m1, m2){
      int t1 = m1["_id"].compareTo(m2["_id"]);
      if(t1!=0){
        return t1;
      }else{
        int t2 = m1["_rev"].compareTo(m2["_rev"]);
        return t2;
      }
    });

    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 1, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 2, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 3, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 4, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 5, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 5, "_rev": 2},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 5, "_rev": 3},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 5, "_rev": 4},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 6, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 7, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 8, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 9, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 10, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 10, "_rev": 2},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 10, "_rev": 3},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 10, "_rev": 4},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 10, "_rev": 5},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 11, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 12, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 13, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 14, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 15, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 16, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 17, "_rev": 1},valueToBeInserted: 0);
    BPlusTreeAlgos.insert(bptree: bpt, keyToBeInserted: {"_id": 18, "_rev": 1},valueToBeInserted: 0);

    printBPlusTree(bptree: bpt, message: "After insertion");

    Compare<BPlusCell<Map<String,int>>> customCompare = (m1, m2){
      var t1 = m1.key["_id"].compareTo(m2.key["_id"]);
      if(t1!=0){
        return t1;
      }else{
        var t2 = (m1.key["_rev"]??99).compareTo(m2.key["_rev"]??99);
        if(t2<=0){
          return -1;
        }else{
          return 0;
        }
      }
    };

    var key1 = BPlusTreeAlgos.searchForKey<Map<String,int>>(bptree: bpt, searchKey: {"_id": 5}, customCompare: customCompare);
    expect(key1.key["_rev"],4);

    key1 = BPlusTreeAlgos.searchForKey<Map<String,int>>(bptree: bpt, searchKey: {"_id": 4}, customCompare: customCompare);
    expect(key1.key["_rev"],1);

    key1 = BPlusTreeAlgos.searchForKey<Map<String,int>>(bptree: bpt, searchKey: {"_id": 10}, customCompare: customCompare);
    expect(key1.key["_rev"],5);

    key1 = BPlusTreeAlgos.searchForKey<Map<String,int>>(bptree: bpt, searchKey: {"_id": 13}, customCompare: customCompare);
    expect(key1.key["_rev"],1);



  });
}