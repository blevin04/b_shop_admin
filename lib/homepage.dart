import 'package:b_shop_admin/addContent.dart';
import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:input_quantity/input_quantity.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
bool darkmode = Hive.box("theme").isEmpty?false:
  Hive.box("theme").get("theme")==1?true:false;
final firestore0 = FirebaseFirestore.instance;
int curentPage = 0;
void openBoxes()async{
  await Hive.openBox("Orders");
  await Hive.openBox("Categories");
  await Hive.openBox("Stock");
  // await Hive.openBox(name)
}
void themechange(BuildContext context) async {
  await Hive.box("theme").clear();
  if (darkmode) {
    await Hive.box("theme").put("theme", 1);
  } else {
    await Hive.box("theme").put("theme", 0);
  }
  // print("lllllllllllllllll");
  // print(Hive.box("theme").values);
}
class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openBoxes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("B Shop Admin",),
        actions: [
          StatefulBuilder(
            builder: (BuildContext context, setStatetheme) {
              return IconButton(onPressed: (){
                themechange(context);
                if (darkmode) {
                  MyApp.of(context)!.changeTheme(ThemeMode.light);
                }else{
                  MyApp.of(context)!.changeTheme(ThemeMode.dark);
                }
                setStatetheme((){
                  darkmode = !darkmode;
                });
              }, icon: Icon(darkmode?Icons.dark_mode:Icons.sunny));
            },
          ),
        ],
      ),
      floatingActionButton: IconButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Addcontent()));
      }, icon:const Icon(Icons.add,size: 35,)),
      body: home(context)
    );
  }
}
Widget home(BuildContext context){
  Map stats = {
    "Orders":78,
    "Performance":{
      "Gas 9kg":40.0,
      "Gas 13kg":30.0,
      "Cerials":20.0,
      "others":10.0,
      },
  };
List orders = [
  "Gas 13kg x1",
  "Unga 2kg x3",
  "Rice 10kg x1",
  "Sugar 5kg x2",
  "Gas 9kg x1",
];
Map stock = {
  "food stuffs":20.0,
  "Gas ":30.0,
  "Cerials":30.0,
  "Electronics":10.0,
  "Others":10.0
};
String focusedCategory = "";
  return SingleChildScrollView(
    child: Column(
      children: [
        GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            String title_ = stats.keys.toList()[index];
            Map items = stats[stats.keys.toList().last];
            return Card(
              child: StreamBuilder(
                stream:firestore.collection("orders").snapshots() ,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  QuerySnapshot<Map<String,dynamic>> orders = snapshot.data!;
                  var ordersData = orders.docs;
                  List openOrders = [];
                  List todaysOrders = [];
                  // DateTime tt = DateTime(200);
                  // tt.isAfter(other)
                  for(var data in ordersData){
                    if (data.data()!["time"].toDate().isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))) {
                      todaysOrders.add(data.data());
                    }
                    if (data.data()["delivered"] != true) {
                      openOrders.add(data.data());
                    }
                  }
                  print(todaysOrders.length);
                  print(openOrders.length);
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    enableFeedback: false,
                    splashColor: Colors.transparent,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Text(title_,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            Expanded(
                              child:
                              PieChart(
                                swapAnimationCurve: Curves.bounceInOut,
                                swapAnimationDuration:const Duration(milliseconds: 200),
                                index == 0?
                                PieChartData(
                                  titleSunbeamLayout: false,
                                  sections: [
                                    PieChartSectionData(
                                      gradient:const LinearGradient(colors: [Colors.blue, Color.fromARGB(255, 53, 63, 93)]),
                                      value: (openOrders.length-todaysOrders.length)/todaysOrders.length,
                                      color:Colors.blue,
                                      ),
                                    PieChartSectionData(
                                      value:openOrders.length/todaysOrders.length,
                                      color: Colors.white
                                    ),
                                  ]
                                ):
                                PieChartData(
                                  sections: List.generate(items.length, (int index){
                                    String ttle = items.keys.toList()[index];
                                    double value = items[ttle];
                                    return PieChartSectionData(
                                      color:   Color.fromARGB(255, 16, 119, (value.floor()*2)+100),
                                      titleStyle:const TextStyle(overflow: TextOverflow.ellipsis),
                                      value: value,
                                      //title: ttle
                                    );
                                  })
                                )
                              )
                               ,
                              ),
                              
                          ],
                        ),
                        index==0?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check),
                            todaysOrders.isNotEmpty?
                            Text("${(todaysOrders.length)- openOrders.length}/${todaysOrders.length}",style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),):
                            Container(),
                          ],
                        ):
                        Container()
                      ],
                    ),
                  );
                }
              ),
            );
          },
        ),
        Card(
          child: Container(),
        ),
        // GridView.builder(
        //   physics: const NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //   ),
        //   itemCount: 2,
        //   itemBuilder: (BuildContext context, int index) {
        //     bool done = false;
        //     return SingleChildScrollView(
        //       child: Card(
        //         child:index==0? 
        //         Column(
        //           children: [
        //            const Text("Open Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        //             ListView.builder(
        //               physics: const NeverScrollableScrollPhysics(),
        //               itemCount: orders.length,
        //               shrinkWrap: true,
        //               itemBuilder: (BuildContext context, int index) {
        //                 return StatefulBuilder(
        //                   builder: (context,stateorder) {
        //                     return Padding(
        //                       padding: const EdgeInsets.all(5.0),
        //                       child: InkWell(
        //                         onTap: (){
        //                           stateorder((){
        //                             done = !done;
        //                           });
        //                         },
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                           children: [
        //                             Text(orders[index]),
        //                             Icon(done?Icons.check_box: Icons.check_box_outline_blank)
                                
        //                           ],
        //                         ),
        //                       ),
        //                     );
        //                   }
        //                 );
        //               },
        //             ),
        //           ],
        //         ):
        //         Column(
        //           children: [
        //             const Text("Sales",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        //             ListView.builder(
        //               padding:const EdgeInsets.all(0),
        //               shrinkWrap: true,
        //               itemCount: stats["Performance"].length,
        //               itemBuilder: (BuildContext context, int index) {
        //                 String pName= stats["Performance"].keys.toList()[index];
        //                 var percentage = stats["Performance"][pName];
        //                 return Padding(
        //                   padding: const EdgeInsets.all(5.0),
        //                   child: Row(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                     children: [
        //                       ColoredBox( 
        //                         color:Color.fromARGB(255, 16, 119, (percentage.floor()*2)+100), 
        //                         child:const SizedBox(
        //                           height: 20,
        //                           width: 20,
        //                         ), ),
        //                       Text(pName),
        //                       Text("${percentage.toString()}%"),
        //                     ],
        //                   ),
        //                 );
        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              //height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                 const Text("Available Stock",style: TextStyle(fontWeight: FontWeight.bold),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        height: 180,
                        child: PieChart(
                          PieChartData(
                          sections:List.generate(stock.length, (index1){
                            double value = stock[stock.keys.toList()[index1]];
                            return PieChartSectionData(
                              titleStyle:const TextStyle(fontWeight: FontWeight.bold),
                              value: value,
                              title: stock.keys.toList()[index1],
                              color:  Color.fromARGB((value.ceil()*3)+150, 56,((value.ceil())*2)+50, 39),
                            );
                          })
                        )),
                      ),
                       Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 138, 137, 137),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        height: 170,
                        width: 5,
                       ),
                       Expanded(
                         child: StatefulBuilder(
                           builder: (context,categorystate) {
                             return focusedCategory.isEmpty?
                             Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Container(
                                //   margin:const EdgeInsets.only(left: 20,right: 20,),
                                //   padding:const EdgeInsets.all(0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(30),
                                //     border: Border.all(color: const Color.fromARGB(255, 112, 111, 111))
                                //   ),
                                //   child:const Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //     Text("Filter"),
                                //      Icon(Icons.keyboard_arrow_down_outlined),
                                //   ],)
                                // ),
                               const Center(child: Text("Categories",style: TextStyle(fontWeight: FontWeight.bold),),),
                                const SizedBox(height: 5,),
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 135,
                                  child: FutureBuilder(
                                    future: getcategories(),
                                    builder: (context,categoriesSnapshot) {
                                      if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator(),);
                                      }
                                      //print("dataa ${categoriesSnapshot.data}");
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: categoriesSnapshot.data!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return 
                                          InkWell(
                                            onTap: (){
                                              categorystate((){
                                                focusedCategory = categoriesSnapshot.data![index];
                                              });
                                            },
                                            child: Container(
                                              margin:const EdgeInsets.only(left: 20,right: 20,),
                                              padding:const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                    //border: Border.all(color: const Color.fromARGB(255, 112, 111, 111))
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                    Text(categoriesSnapshot.data![index]),
                                                    const Icon(Icons.add),
                                                  ],)
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ],
                             ):Column(
                              children: [
                                Center(child: Row(children: [
                                  IconButton(onPressed: (){
                                    categorystate((){
                                      focusedCategory = "";
                                    });
                                  }, icon:const Icon(Icons.arrow_back)),
                                   Text(focusedCategory,style:const TextStyle(fontWeight: FontWeight.bold),)
                                ],),),
                                FutureBuilder(
                                  future: getFilteredStock(currentCategory),
                                  builder: (BuildContext context, AsyncSnapshot filterdSnap) {
                                    if (filterdSnap.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator(),);
                                    }
                                    //Map nice ={};
                                    List catKeys = filterdSnap.data.keys.toList();
                                    //print(catKeys);
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: catKeys.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                            margin:const EdgeInsets.only(left: 5,right: 5,),
                                            padding:const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                        //border: Border.all(color: const Color.fromARGB(255, 112, 111, 111))
                                      ),
                                      child: Wrap(
                                        children: [
                                          Text(filterdSnap.data![catKeys[index]]["Name"],softWrap: true,),
                                          const SizedBox(width: 10,),
                                          InputQty(
                                            initVal: filterdSnap.data![catKeys[index]]["Stock"],
                                            onQtyChanged: (value){
                                              reStock(catKeys[index], value.toInt());
                                            },
                                          )
                                        ],
                                      ),
                                      // child: Wrap(
                                      //   clipBehavior: Clip.none,
                                      //   verticalDirection: VerticalDirection.down,
                                      //     children: [
                                      //     
                                      //      IconButton(onPressed: (){
                                      //      }, icon:const Icon(Icons.remove_outlined)),
                                      //      Text(filterdSnap.data![catKeys[index]]["Stock"].toString()),
                                      //      IconButton(
                                           
                                      //       onPressed: (){}, icon: const Icon(Icons.add))
                                      //   ],
                                      // )
                                      );
                                      },
                                    );
                                  },
                                ),
                              ],
                             );
                           }
                         ),
                       )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
        // Card(
        //   child: InkWell(
        //     borderRadius: BorderRadius.circular(10),
        //     child: SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Row(
        //         children: [
        //           AspectRatio(
        //             aspectRatio: 1,
        //             child: PieChart(
        //               PieChartData(
        //                 sections: List.generate(stock.length,
        //                  (index){
        //                   double value = stock[stock.keys.toList()[index]];
        //                   return PieChartSectionData(
        //                     value: value,
        //                     color:  Color.fromARGB(255, 56,((value.ceil())*2)+50, 39),
        //                   );
        //                  }
        //                  )
        //               )
        //             ),
        //           ),
        //           // ListView.builder(
        //           //   itemCount: 1,
        //           //   shrinkWrap: true,
        //           //   itemBuilder: (BuildContext context, int index) {
        //           //     return ;
        //           //   },
        //           // ),
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    ),
  );
}
