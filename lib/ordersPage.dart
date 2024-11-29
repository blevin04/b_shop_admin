import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              String owner = orderData["Owner"];
              Map lipiaResponse ={};
              if (orderData.containsKey("LipiaOnlineResponse")) {
                lipiaResponse = orderData["LipiaOnlineResponse"];
              }
              return Card(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getUserInfo(owner),
                      builder: (context,snapshotD) {
                        if (snapshotD.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        String name = snapshotD.data!["name"];
                        String contact = snapshotD.data!.containsKey("number")?
                                          snapshotD.data!["number"]:
                                          snapshotD.data!["Email"];
                        return ListTile(
                          onTap: (){
                            showDialog(
                              context: context, 
                              builder: (context){
                                return Dialog(
                                  child: SizedBox(
                                    height: lipiaResponse.isEmpty?200:300,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Owner:  $name"),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(contact),
                                            IconButton(onPressed: ()async{
                                              if (snapshotD.data!.containsKey("number")) {
                                                final Uri _phoneUri = Uri(
                                                  scheme: "tel",
                                                  path: contact
                                              );
                                              await launchUrl(_phoneUri);
                                              } else {
                                                final Uri _email = Uri(
                                                  scheme: "mailto",
                                                  path: contact,
                                                );
                                                await launchUrl(_email);
                                              }
                                              
                                            }, icon:const Icon(Icons.call))
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Order number:  $orderNum"),
                                        ),
                                        ListView.builder(
                                          itemCount: lipiaResponse.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            List keys = lipiaResponse.keys.toList();
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("${keys[index]}:  ${lipiaResponse[keys[index]]}"),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          },
                          title:Text("owner:  $name",),
                            subtitle: Text("Total: ${orderData["price"].toString()}"),
                            trailing: IconButton(
                              onPressed: ()async{
                                await openMap(
                                  location.first,
                                    location[1], context);
                              }, 
                              icon:const Icon(Icons.location_on_sharp)),
                        );
                      }
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