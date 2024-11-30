import 'dart:io';
import 'package:b_shop_admin/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance.ref();
class itemModel{
  final String name;
  final String uid;
  final double price;
  final int stock;
  final String category;
  final String description;
  itemModel({
    required this.name,
    required this.price,
    required this.uid,
    required this.stock,
    required this.category,
    required this.description
  });

  Map<String,dynamic> toJyson()=>{
    "Name":name,
    "Uid":uid,
    "Price":price,
    "Stock":stock,
    "Category": category,
    "Clout":100,
    "Description":description,
  };
}

Future<String> addItem(
  String name,
  int stock,
  double price,
  List<String> imgPatch,
  String category,
  String description,
)async{
  String state = "Some Error Occured";
  try {
    String uid = Uuid().v1();
    itemModel newItem = itemModel(
      name: name, price: price, uid: uid, stock: stock,category: category,description: description);

    await firestore.collection("Products").doc(uid).set(newItem.toJyson());
    for(var path in imgPatch){
      String name = path.split("/").last;
      await storage.child("/Products/$uid/$name").putFile(File(path));
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
    await firestore.collection("Products").doc(itemUid).update({"Stock":newStock});
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

Future<List<dynamic>> getProductPictures(String category,String productId)async{
  List<dynamic> pictures = [];
  if (Hive.box("Images").containsKey(productId)) {
   // print("oooooooooooooooooo");
    //print(Hive.box("Images").get(productId).runtimeType);
    pictures = Hive.box("Images").get(productId);
  }else{
   // print("ppppppppppppppp");
     await storage.child("Products/$productId").list().then((onValue)async{
    for(var img in onValue.items){
      var data = await img.getData();
      pictures.add(data!);
    }
  });
  Hive.box("Images").put(productId, pictures);
  }
  print(pictures.length);
  return pictures;
}
Future<List<String>> getcategories()async{
  List<String> categories0 =  ["test"];
   await firestore.collection("Products").where("Category",whereNotIn: categories0).get().then((onValue)async{
      //print(onValue.docs.length);
      for(var val in onValue.docs){
        //print(val.data()["Category"]);
        final catName = val.data()["Category"];
        categories0.add(catName);
      }
    });
  
  categories0.remove("test");
  return categories0;
}
Future<Map<String,dynamic>> getFilteredStock(String category)async{
  Map<String,dynamic> fStock ={};
  try {
   await firestore.collection("Products").where("Category",isEqualTo: category).get().then((onValue){
      for(var value in onValue.docs){
        fStock.addAll({value.id:value.data()});
      }
    });
  } catch (e) {
  }
  return fStock;
}
Future<String>sendMessage(String messageHead,String messageBody,String assets)async{
  String state = "";
  try {
    String messageId = Uuid().v1();
   
    messageModel message = messageModel(body: messageBody, title: messageHead);
    await firestore.collection("message").doc(messageId).set(message.toJyson());
    if (assets.isNotEmpty) {
       String assetname = assets.split("/").last;
       await storage.child("/messages/$messageId/$assetname").putFile(File(assets));
    }
    state = "Success";
  } catch (e) {
    throw e.toString();
  }
  print(state);
  return state;
}
Future<Map<String,dynamic>> getOrders()async{
  Map<String,dynamic> orders = {};

  await firestore.collection("orders").where("delivered",isEqualTo: false).get().then((onValue){
    for(var value in onValue.docs){
      orders.addAll({value.id:value.data()});
    }
  });
  return orders;

}
Future<Map<String,dynamic>> getUserInfo(String userId)async{
  Map<String,dynamic> info ={};

  await firestore.collection("Users").doc(userId).get().then((onValue){
    final name = onValue.data()!["Name"];
    info.addAll({"name":name});
    if (onValue.data()!.containsKey("number")) {
      final number = onValue.data()!["number"];
      info.addAll({"number":number});
    }else{
      final email = onValue.data()!["Email"];
      info.addAll({"Email":email});
    }
  });
  return info;
}
Future<void>delivered(String orderNum)async{
  await firestore.collection("orders").doc(orderNum).update({"delivered":true,});
  // await firestore.collection("orders").doc(orderNum).get().then((onValue)async{
  //   Map items = onValue.data()!["items"];
  //   items.forEach((key,value)async{
  //     await firestore.collection("Products").doc(key).get().then((onValue)async{
  //       int stock = onValue.data()!["Stock"];
  //       int bought =value.last;
  //       stock-=bought;
  //       await firestore.collection("Products").doc(key).update({"Stock":stock});
  //     });
  //   });
  // });
}
