import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:balancedtrees/bplustree/bplustree.dart';
import 'package:balancedtrees/comparators/comparators.dart';

import 'util_for_test/utilities_for_testing.dart';


enum Operation{INSERTION, DELETION}
var tf= false;

main() {

  var prefix = 'test/data_for_load_testing/load5';

  test("CASE1: Inserting 1048575 items in random order and checking if they are in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 101);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);
    expect(getLeafLevelSize(bptree: bptree), 1048575);
    verify_it_against_file("$prefix/sorted_data.csv", bptree);
  });

  test("CASE2: Deleting 505515 items selected randomly and checking if the result is still in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 101);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);

    do_operation(bptree, '$prefix/rand_arranged_data_for_deletion.csv', Operation.DELETION);
    expect(bptree.size, 1048575-505515);

    verify_it_against_file("$prefix/after_deletion.csv", bptree);
  });


  test("CASE3: Deleting all items selected randomly and checking if the result is still in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 101);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);

    //printBPlusTree(bptree: bptree, message: "After insertion");

    do_operation(bptree, '$prefix/rand_arranged_data_for_deletion_full.csv', Operation.DELETION);

    printBPlusTree(bptree: bptree, message: "After deletion");
    expect(bptree.size, 1048575-1048575);

  });

  test("CASE4:(Capacity of node= 11) Deleting all items selected randomly and checking if the result is still in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 11);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);

    //printBPlusTree(bptree: bptree, message: "After insertion");

    do_operation(bptree, '$prefix/rand_arranged_data_for_deletion_full.csv', Operation.DELETION);

    printBPlusTree(bptree: bptree, message: "After deletion");
    expect(bptree.size, 1048575-1048575);

  });

  test("CASE5: (Capacity of node= 4) Deleting all items selected randomly and checking if the result is still in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);

    //printBPlusTree(bptree: bptree, message: "After insertion");

    do_operation(bptree, '$prefix/rand_arranged_data_for_deletion_full.csv', Operation.DELETION);

    printBPlusTree(bptree: bptree, message: "After deletion");
    expect(bptree.size, 1048575-1048575);

  });

  test("CASE6:(Capacity of node= 4) Deleting 505515 items selected randomly and checking if the result is still in proper sorted order",(){
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);

    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 1048575);

    do_operation(bptree, '$prefix/rand_arranged_data_for_deletion.csv', Operation.DELETION);
    expect(bptree.size, 1048575-505515);

    verify_it_against_file("$prefix/after_deletion.csv", bptree);
  });

}

verify_it_against_file(String relFilePath,BPlusTree<String> bptree){
    var fileToBematchedAgainst = File(relFilePath);
    List<String> contentsAsLine = fileToBematchedAgainst.readAsLinesSync();
    var itr1 =  BPlusTreeLeafIterator<String>(bptree: bptree);
    int i = 0;
    while(itr1.hasSomeMoreItems()){
      expect(itr1.next().key, contentsAsLine[i]);
      i++;
    }
}

do_operation(BPlusTree<String> bptree, String filePath, Operation operation){
  var file_for_insertion = File(filePath);

  List<String> contentsAsLine = file_for_insertion.readAsLinesSync();

  var t  =Stopwatch()..start();
  int i=0;
  int l=0;
  for(var item in contentsAsLine){
    try{
      l++;
      switch(operation){
        case Operation.INSERTION:
          /*if(item=="n855331"){//n227905 "n316019"){//"n253238"){
            printBPlusTree(bptree: bptree, message: "Before INSERTION of: $item");
            print("Problemetic post: $item");
            tf=true;
          }*/
          BPlusTreeAlgos.insert(bptree: bptree, keyToBeInserted: item, valueToBeInserted: i);
          break;
        case Operation.DELETION:

          /*if(item=="n996745"){//n227905 "n316019"){//"n253238"){
           //printBPlusTree(bptree: bptree, message: "Before DELETION of: $item");
            print("Problemetic post: $item");
            tf=true;
          }*/
          BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: item);
         /* if(tf){
            internalTreeSize_atLevel_Tester(bptree, level: 2);
            print(item);
          }*/
          break;
      }
    }catch(e){
      print("Exception at line $l : $item");
      print(e);
      print("${operation.toString()} took: ${t.elapsed.inSeconds} seconds");
      t.stop();
      rethrow;
    }
  }

  print("${operation.toString()} took: ${t.elapsed.inSeconds} seconds");
  t.stop();
  /*Stream<List<int>> inputStream = file_for_insertion.openRead();
  var insertedItemStream = inputStream.transform(utf8.decoder).transform(LineSplitter());

  int i = 0;
  await for(var insertedItem in insertedItemStream){
      BPlusTreeAlgos.insert(bptree: bptree, debugFlag: true, keyToBeInserted: insertedItem, valueToBeInserted: i);
  }*/
}