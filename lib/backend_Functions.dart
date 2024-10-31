
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();
class itemModel{
  final String name;
  final String uid;
  final double price;
  final int stock;
  itemModel({
    required this.name,
    required this.price,
    required this.uid,
    required this.stock,
  });

  Map<String,dynamic> toJyson()=>{
    "Name":name,
    "uid":uid,
    "price":price,
    "Stock":stock,
  };
}

Future<String> addItem(
  String name,
  int stock,
  double price,
  List<String> imgPatch,
  String category,
)async{
  String state = "Some Error Occured";
  try {
    String uid = Uuid().v1();
    itemModel newItem = itemModel(name: name, price: price, uid: uid, stock: stock);

    await firestore.collection("Products").doc(category).set(newItem.toJyson());
    for(var path in imgPatch){
      String name = path.split("/").last;
      await storage.child("/Products/$category/$uid/$name").putFile(File(path));
    }
    state = "Success";
  } catch (e) {
    state = e.toString();
  }
  return state;
}