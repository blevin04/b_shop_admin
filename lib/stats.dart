import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) { 
    DateTime orderFrom = DateTime(DateTime.now()
    .year,DateTime.now().month,DateTime.now().day);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(onPressed: (){}, icon: Icon(Icons.)),
        title:const Text("Stats"),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            // Divider(),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Card(
                    child: StatefulBuilder(
                      builder: (context,orderState) {
                        return StreamBuilder(
                          stream: firestore.collection("orders").where("time",isGreaterThan: Timestamp.fromDate(orderFrom)).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return ListView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                // padding: const EdgeInsets.all(10),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          padding:const EdgeInsets.all(10),
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                        Container(
                                          padding:const EdgeInsets.all(10),
                                          height: 20,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            int total = snapshot.data.docs.length;
                            List ordersDatas = snapshot.data.docs;
                            int shipped = 0;
                            for(var data in ordersDatas){
                              if (data.data()["delivered"]) {
                                shipped++;
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: [
                                     const Center(child: Text("Orders",style: TextStyle(fontSize: 18),),),
                                     TextButton(onPressed: (){
                                      showDialog(context: context, builder: (context){
                                        return Dialog(
                                          child: SizedBox(
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(onPressed: (){
                                                  orderFrom = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                                                  orderState((){});
                                                  Navigator.pop(context);
                                                }, child:const Text("Today")),
                                                TextButton(onPressed: (){
                                                  orderFrom = DateTime(DateTime.now().year,DateTime.now().month);
                                                  orderState((){});
                                                  Navigator.pop(context);
                                                }, child:const Text("This Month")),
                                                TextButton(onPressed: (){
                                                  int month = DateTime.now().month;
                                                  month-=3;
                                                  if (month<1) {
                                                    month +=13;
                                                  }
                                                  orderFrom = DateTime(DateTime.now().year,month);
                                                }, child:const Text("3 Months"))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                     }, child:orderFrom == DateTime(DateTime.now().year,DateTime.now().month)?
                                                 const Text("Month +"):
                                                 orderFrom == DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)?
                                                 const Text("Today"):
                                                 const Text("3 Month")
                                                 
                                                 )
                                                 
                                   ],
                                 ),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Total:"),
                                      Text(total.toString(),style:const TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                   const Text("Pending: "),
                                  Text("${total-shipped}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                  const Text("Shipped: "),
                                  Text(shipped.toString()),
                                ],)
                              ],
                            );
                          },
                        );
                      }
                    ),
                  );
                }
                return Card(
                    child: StreamBuilder(
                      stream: firestore.collection("Products").orderBy("Stock",descending: false).limit(5).snapshots(),
                      
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                                itemCount: 3,
                                shrinkWrap: true,
                                // padding: const EdgeInsets.all(10),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          padding:const EdgeInsets.all(10),
                                          height: 15,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                        ),
                                        Container(
                                          padding:const EdgeInsets.all(10),
                                          height: 10,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                        }
                        List products = snapshot.data.docs;
                        return InkWell(
                          onTap: (){
                            currentPage.value = 1;
                          },
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text("Low Stock Items",style: TextStyle(fontSize: 17),),
                              ),
                              const Divider(),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map product = products[index].data();
                                  String productName = product["Name"];
                                  var instock = product["Stock"];
                                  return Row(
                                    
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(productName),
                                      Text(instock.toString())
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
              },
            ),
            const SizedBox(height: 20,),
            Card(
              child: Container(
                height: 50,
                alignment: Alignment.centerRight,
                padding:const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width-10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
                ),
                child:const Text("View Full inventory ->",style: TextStyle(fontSize: 16),),
              ),
            )
          ],
        ),
      ) ,
    );
  }
}