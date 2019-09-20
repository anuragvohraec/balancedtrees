
///Unit comparator
int genUnitSortHelper<T extends Comparable>(T k1, T k2){
  return k1.compareTo(k2);
}

///Compares Array
int listSortHelper<T extends Comparable>(List<T> list1, List<T> list2){
  if(list1[0]!=list2[0]){
    return list1[0].compareTo(list2[0]);
  }else{
    if(list1.length==1){
      return list1[0].compareTo(list2[0]);
    }else{
      return listSortHelper(list1.sublist(1),list2.sublist(1));
    }

  }
}