import 'dart:convert';
import 'dart:io';


// this one loads the data and created a data which must be there aftre deletion,
// one has to manually sort data after creation of this data some spreasheet tool
main() async{

  var path = "/home/anurag/temp_anurag/balanced_tree_massive_data_loading/";

  var file_rand_arranged_data_for_insertion=File(path+"rand_arranged_data_for_insertion.csv");


  var file_after_deletion = File(path+"after_deletion.csv");
  var sink = file_after_deletion.openWrite(mode: FileMode.append);

  Set<String> deletedItemSet = give_me_deletedItemSet(path);//Set<String>.from(delete_list);

  Stream<List<int>> inputStream = file_rand_arranged_data_for_insertion.openRead();

  var insertionStream = inputStream.transform(utf8.decoder).transform(LineSplitter());

  await for(var insertedItem in insertionStream){
        if(deletedItemSet.contains(insertedItem)){
          continue;
        }else{
          sink.write(insertedItem+"\n");
        }
  }

  await sink.flush();
  await sink.close();

}


Set<String> give_me_deletedItemSet(String path){
  var file_rand_arranged_data_for_deletion= File(path+"rand_arranged_data_for_deletion.csv");
  List<String> delete_list = file_rand_arranged_data_for_deletion.readAsLinesSync();
  Set<String> deletedItemSet = Set<String>.from(delete_list);
  return deletedItemSet;
}
