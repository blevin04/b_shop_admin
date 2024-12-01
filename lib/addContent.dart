import 'dart:io';
import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/homepage.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:input_quantity/input_quantity.dart';
class Addcontent extends StatelessWidget {
  const Addcontent({super.key});
static final  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    bool newItem = true;
    // _pageController.addListener((){
    //   print("nu");
    //   print(_pageController.page);
    //   if (_pageController.page == 0) {
    //     newItem == true;
    //   }else{
    //     newItem == false;
    //   }
    // });
    
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _pageController,
          builder: (BuildContext context, child) {
            // print(newItem);
            if (_pageController.page == 1) {
              newItem = false;
            }else{
              newItem = true;
              }
            return Row(
              children: [
                TextButton(onPressed: ()async{
                  newItem = true;
                 await _pageController.animateToPage(0, duration:const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                  
                }, child: Column(
                  children: [
                    const Text("New Item",),
                    Container(
                      width: 65,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: newItem?Colors.blue:Colors.transparent
                      ),
                    )
                  ],
                )),
                TextButton(onPressed: ()async{
                  newItem = false;
                 await _pageController.animateToPage(1, duration:const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                 
                }, child:  Column(
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Restock",
                          // style: TextStyle(decoration: _pageController.page==1?TextDecoration.underline:null),
                          ),
                          Container(
                            width: 55,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: !newItem?Colors.blue:Colors.transparent
                            ),
                          )
                      ],
                    ),
                    
                  ],
                ))
              ],
            );
          },
        ),
      ),
      body:PageView(
        controller: _pageController,
        children:const [
          add(),
          restock()
        ],
      ) ,
    );
  }
}

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}
  String currentCategory = "Select Category";
  TextEditingController nameController = TextEditingController();
  TextEditingController description = TextEditingController();
TextEditingController newCategoryController =TextEditingController();
List<String> imagePath = [];
  List categories = [
    "Gas",
    "Cerials",
    "Food Stuffs",
    "Other",
  ];
  bool newCategory = false;
  bool categorydrop=false;
  double price =0;
  double stock = 0;
class _addState extends State<add> {
  @override
  void dispose() {
    newCategoryController.dispose();
    nameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newCategoryController =TextEditingController();
    nameController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Center(
          child: Text("Add Product",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

        ),
       const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Name"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:const BorderSide(color:  Color.fromARGB(255, 106, 105, 105))
              )
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(5),child: Text("Price"),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InputQty(
            onQtyChanged: (value)=>price=value.ceilToDouble()
          )
        ),
        StatefulBuilder(
          builder: (context,imageState) {
            return Container(
              margin:const EdgeInsets.only(left: 10),
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromARGB(255, 84, 82, 82))
              ),
              child: InkWell(
                onTap: ()async{
                  imagePath += await getImage(context);
                  if (imagePath.isEmpty) {
                    showsnackbar(context, "Error occured");
                  }else{
                    imageState((){});
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: imagePath.isNotEmpty,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: imagePath.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Center(
                                child: Image.file(
                                  fit: BoxFit.fill,
                                  File(imagePath[index])),
                                ),
                                IconButton(onPressed: (){
                                  imageState((){
                                    imagePath.remove(imagePath[index]);
                                  });
                                }, 
                                icon:const CircleAvatar(child:  Icon(Icons.delete))),
                            ],
                          );
                        },
                      ),
                      ),
                    const Column(
                      children: [
                        Icon(Icons.add_a_photo),
                        Text("Add Image")
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        ),
        StatefulBuilder(
          builder: (context,categorystate) {
            return
            newCategory?
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onTapOutside: (event){
              categorystate((){
                currentCategory = newCategoryController.text;
              });
            },
                onSubmitted: (value){
                  currentCategory = value;
                  categorystate((){});
                },
                  decoration: InputDecoration(
                    hintText: "New Category Name",
                    
                    suffixIcon:IconButton(onPressed: (){
                      categorystate((){
                        newCategory =!newCategory;
                      });
                    }, icon:const Icon(Icons.cancel)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:const BorderSide(color:  Color.fromARGB(255, 106, 105, 105))
                    )
                  ),
                ),
              ):
             Container(
              margin:const EdgeInsets.all(8),
              padding:const EdgeInsets.all(5),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromARGB(255, 84, 82, 82))
              ),
              child:
               Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(currentCategory),
                      IconButton(onPressed: (){
                        categorystate((){
                          categorydrop = !categorydrop;
                        });
                      }, icon:const Icon(Icons.keyboard_arrow_down)),
                      TextButton(
                        onPressed: (){
                          categorystate((){
                            newCategory = true;
                          });
                          
                        }, 
                        child:const Text("New",style: TextStyle(),)
                        )
                    ],
                  ),
                  Visibility(
                    visible: categorydrop,
                    child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: (){
                            categorystate((){
                            categorydrop = !categorydrop;
                            currentCategory = categories[index];
                          });
                          },
                          title: Text(categories[index]),
                        );
                      },
                    ),
                    )
                ],
              )
            );
          }
        ),
      const Padding(
         padding:  EdgeInsets.all(8.0),
         child:  Text("Number in Stock"),
       ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InputQty(
            onQtyChanged: (value)=>stock = value.ceilToDouble(),
          )
        ),
        const SizedBox(height: 20,),
        TextField(
          controller: description,
          decoration: InputDecoration(
            hintText: "More info on the product.....",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        const SizedBox(height: 20,),
        Center(
          child: TextButton(onPressed: ()async{
            String state ="";
            while(state.isEmpty){
              showcircleprogress(context);
              state = await addItem(
              nameController.text, 
              stock.toInt(), 
              price.ceilToDouble(), 
              imagePath,
             currentCategory,
             description.text,
             );
            }
             if (state=="Success") {
               showsnackbar(context, "${nameController.text} added successfully");
               imagePath.clear();
               currentCategory ="Select Category";
               Navigator.pop(context);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Homepage()));
             }
          }, 
          child: Container(
            padding:const EdgeInsets.all(10),
            child:const Text("Add Product"),)
          ),
        )
      ],
    ),
  );
  }
}

class restock extends StatefulWidget {
  const restock({super.key});

  @override
  State<restock> createState() => _restockState();
}
TextEditingController searchController = TextEditingController();
Map<String,dynamic> filtered = {};
void openimageBox()async{
   await Hive.openBox("Images");
}
class _restockState extends State<restock> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openimageBox();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          controller: searchController,

          leading:const Icon(Icons.search),
          hintText: "Search your Product",
          onChanged: (value){
            List toRemove =[];
            filtered.forEach((key,value1){
              //String t1="";
              if (!value1["Name"].toLowerCase().contains(value)) {
                // print("contains");
                toRemove.add(key);
              }
            });
            for(var remove in toRemove){
              filtered.remove(remove);
            }
            setState(() {
            });
          },
        ),
        FutureBuilder(
          future: getStock(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center( child: CircularProgressIndicator(),);
            }
            if (snapshot.data.isEmpty) {
              return const Center(child: Icon(Icons.error),);
            }
            if (filtered.isEmpty && searchController.text.isEmpty) {
              filtered = snapshot.data;
            }
            return filtered.isEmpty&&searchController.text.isNotEmpty?const Center(child: Text("No Match"),):
            ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (BuildContext context, int index) {
                List keys = filtered.keys.toList();
                String pName = filtered[keys[index]]["Name"];
                int inStock = filtered[keys[index]]["Stock"];
                String category = filtered[keys[index]]["Category"];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: FutureBuilder(
                      future: getProductPictures(category, keys[index]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const CircleAvatar();
                        }
                        //print(snapshot.data);
                        if (snapshot.data == null) {
                          return const CircleAvatar(radius: 30,);
                        }
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: MemoryImage(snapshot.data.first),
                        );
                      },
                    ),
                    title: Text(pName),
                    subtitle: Text(category),
                    trailing: Text("$inStock Available",style:const TextStyle(fontSize: 14),),

                    onTap: (){
                      showDialog(context: context, builder: (context){
                        int newStock = stock.ceil();
                        return Dialog(
                          child: SizedBox(
                            height: 120,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                               const Text("New Stock Number"),
                                InputQty(
                                  initVal: stock.ceil(),
                                  onQtyChanged: (value){
                                    newStock = value.toInt();
                                  },
                                ),
                                TextButton(onPressed: ()async{
                                  String state ="";
                                  while(state.isEmpty){
                                    showcircleprogress(context);
                                    state = await reStock(keys[index],newStock);
                                  }
                                  Navigator.pop(context);
                                  if (state=="Success") {
                                    showsnackbar(context, "Restocked $pName");
                                    Navigator.pop(context);
                                  }else{
                                    showsnackbar(context, "An error Occurred Please try again");
                                  }
                                }, child:const Text("Done"))
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
                // return SizedBox(
                //   height: 200,
                //   width: 200,
                //   child: Row(
                //     children: [
                //       FutureBuilder(
                //       future: getProductPictures(category, keys[index]),
                //       builder: (BuildContext context, AsyncSnapshot snapshot) {
                //         if (snapshot.connectionState == ConnectionState.waiting) {
                //           return const CircleAvatar();
                //         }
                //         return Image(
                //           // height: 200,
                //           // width: 200,
                //           fit: BoxFit.contain,
                //           image: MemoryImage(snapshot.data.first));
                //       },
                //     ),
                //     
                //      
                //      
                //     ],
                //   ),
                // );
              },
            );
          },
        ),
      ],
    );
  }
}
