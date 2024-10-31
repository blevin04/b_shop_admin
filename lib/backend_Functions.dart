
import 'dart:io';
import 'dart:typed_data';

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
  final String category;
  itemModel({
    required this.name,
    required this.price,
    required this.uid,
    required this.stock,
    required this.category,
  });

  Map<String,dynamic> toJyson()=>{
    "Name":name,
    "Uid":uid,
    "Price":price,
    "Stock":stock,
    "Category": category,
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
    itemModel newItem = itemModel(name: name, price: price, uid: uid, stock: stock,category: category);

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

Future<String> reStock(
  String itemUid,
  int newStock,
)async{
  String state = "Error Occured";
  try {
    state = "Success";
    await firestore.collection("Products").where("Uid",isEqualTo: itemUid).get().then((onValue)async{
      await firestore.collection("Products").doc(onValue.docs.single.id).update({"Stock":newStock});
    });
  } catch (e) {
    state = e.toString();
  }
  return state;
}
Future<Map<String,dynamic>> getStock()async{
  Map<String,dynamic> stock ={};
  await firestore.collection("Products").orderBy("Stock", descending: true).get().then((onValue){
    for(var product in onValue.docs){
      //var stock = product.data();
      stock.addAll({product.id:product.data()});
    }
  });
  return stock;
}

Future<List<Uint8List>> getProductPictures(String category,String productId)async{
  List<Uint8List> pictures = [];

  await storage.child("Products/$category/$productId").list().then((onValue)async{
    for(var img in onValue.items){
      var data = await img.getData();
      pictures.add(data!);
    }
  });
  return pictures;
}