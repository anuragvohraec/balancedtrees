import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:balancedtrees/bplustree/bplustree.dart';
import 'package:balancedtrees/comparators/comparators.dart';

import 'util_for_test/utilities_for_testing.dart';


enum Operation{INSERTION, DELETION}
var tf= false;

main() {

  var prefix = 'test/data_for_load_testing/load6';

  test("CASE1: Test searchForRange",() async{
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);
    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 300);
    expect(getLeafLevelSize(bptree: bptree), 300);
    var str = BPlusTreeAlgos.searchForRange(bptree, "n117", "n256");
    await verify_it_against_file("$prefix/range1_data.csv", str);
  });

  test("CASE2: Test searchForRange, start key null and end key not null",() async{
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);
    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 300);
    expect(getLeafLevelSize(bptree: bptree), 300);
    var str = BPlusTreeAlgos.searchForRange(bptree, null, "n242");
    await verify_it_against_file("$prefix/range2_data.csv", str);
  });

  test("CASE3: Test searchForRange, end key null and start key not null",() async{
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);
    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 300);
    expect(getLeafLevelSize(bptree: bptree), 300);
    var str = BPlusTreeAlgos.searchForRange(bptree, "n129", null);
    await verify_it_against_file("$prefix/range3_data.csv", str);
  });

  test("CASE4: Test searchForRange, start and end key null",() async{
    var bptree = BPlusTree<String>(compare: genUnitSortHelper, capacityOfNode: 4);
    do_operation(bptree, '$prefix/rand_arranged_data_for_insertion.csv', Operation.INSERTION);
    expect(bptree.size, 300);
    expect(getLeafLevelSize(bptree: bptree), 300);
    var str = BPlusTreeAlgos.searchForRange(bptree, null, null);
    await verify_it_against_file("$prefix/sorted_data.csv", str);
  });

}

verify_it_against_file(String relFilePath,Stream<BPlusCell<String>> streamOfCells) async{
    var fileToBematchedAgainst = File(relFilePath);
    List<String> contentsAsLine = fileToBematchedAgainst.readAsLinesSync();

    int i = 0;
    await for(var t1 in streamOfCells){
      //print("actual: ${t1.key}, expected: ${contentsAsLine[i]}");
      expect(t1.key, contentsAsLine[i]);
      i++;
    }
}

do_operation(BPlusTree<String> bptree, String filePath, Operation operation){
  var file_for_insertion = File(filePath);

  List<String> contentsAsLine = file_for_insertion.readAsLinesSync();

  var t  =Stopwatch()..start();
  int i=0;
  int l =0;
  for(var item in contentsAsLine){
    try{
      l++;
      switch(operation){
        case Operation.INSERTION:
          /*if(item=="n179"){//n227905 "n316019"){//"n253238"){
            printBPlusTree(bptree: bptree, message: "Before insertion of: $item");
            print("Problemetic post: $item");
            tf=true;
          }*/
          BPlusTreeAlgos.insert(bptree: bptree, keyToBeInserted: item, valueToBeInserted: i);
          if(tf){
            printBPlusTree(bptree: bptree, message: "After insertion of: $item");
          }
          break;
        case Operation.DELETION:

          /*if(item=="n179"){//n227905 "n316019"){//"n253238"){
            print("Problemetic post: $item");
            tf=true;
          }*/
          BPlusTreeAlgos.delete(bptree: bptree, keyToBeDeleted: item);
          if(true||tf){
            printBPlusTree(bptree: bptree, message: "After deletion of: $item");
          }
          break;
      }
    }catch(e){
      print("Exception at line $l: $item");
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