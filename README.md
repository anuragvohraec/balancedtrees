# balancedtrees
![balancedtrees](https://i.ibb.co/hfNYcZk/image.png "balancedtrees")

A collections of AVL and BPlus tree

## Getting Started

Usage
```
var bpt = BPlusTree<String>(capacityOfNode: 4,compare: genUnitSortHelper);
BPlusTreeAlgos.insert(bptree: bpt, valueToBeInserted: 123, keyToBeInserted: "n7");
BPlusTreeAlgos.searchForKey(searchKey: "n7", bptree: bpt).getValue(); //will give out 123
BPlusTreeAlgos.delete(bptree: bpt, keyToBeDeleted: "n7");

```

## Important points
- BPlustree's node's minimum capactiy of node must be greater than 4
- BPlustree with smaller node capacity works faster than one with more capacity.
Upon load testing it was found that with capacity 4 it performed fastest,
however when it capacity was increased to 101, it performed at most 3 times slower.