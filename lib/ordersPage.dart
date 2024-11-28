import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orderspage extends StatefulWidget {
  const Orderspage({super.key});

  @override
  State<Orderspage> createState() => _OrderspageState();
}
// final firestore1 = FirebaseFirestore.instance;
String filter = "delivery";
class _OrderspageState extends State<Orderspage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder(
        stream: firestore.collection("orders").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          QuerySnapshot snap = snapshot.data;
          return ListView.builder(
            itemCount: snap.docs.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              String orderNum = snap.docs[index].id;
              Map orderData = snap.docs[index].data() as Map;
              Map items = orderData["items"];
              List location = orderData["Location"];
              List itemKeys = items.keys.toList();
              bool OndeliveryPayment = orderData["OndeliveryPayment"];
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title:const Text("owner:  0745222065",),
                        subtitle: Text("Total: ${orderData["price"].toString()}"),
                        trailing: IconButton(
                          onPressed: ()async{
                            await openMap(
                              location.first,
                                location[1], context);
                          }, 
                          icon:const Icon(Icons.location_on_sharp)),
                    ),
                        const Divider(),
                    ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        List itemData = items[itemKeys[index]];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            ListTile(
                              title: Text(itemData.first),
                              subtitle: Text(itemData[1].toString()),
                              trailing: OndeliveryPayment?const Text("On delivery"):const Text("Payed"),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}