
import 'dart:io';

import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/homepage.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
class Addcontent extends StatelessWidget {
  const Addcontent({super.key});
static final  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _pageController,
          builder: (BuildContext context, child) {
            return Row(
              children: [
                TextButton(onPressed: ()async{
                 await _pageController.animateToPage(0, duration:const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                  
                }, child: Container(
                  padding:const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:Border.all(color:_pageController.page==0.0?  const Color.fromARGB(255, 108, 107, 107): Colors.transparent)
                      ),
                  child:const Text("New Item",
                 
                 ),
                )),
                TextButton(onPressed: ()async{
                 await _pageController.animateToPage(1, duration:const Duration(milliseconds: 200), curve: Curves.bounceInOut);
                 
                }, child:  Column(
                  children: [
                    Container(
                      padding:const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color:_pageController.page==1.0? const Color.fromARGB(255, 108, 107, 107):Colors.transparent)
                      ),
                      child:const Text(
                        "Restock",
                        // style: TextStyle(decoration: _pageController.page==1?TextDecoration.underline:null),
                        ),
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
        children: [
         const add(),
          restock(context)
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
          padding: const EdgeInsets.only(left: 10.0),
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
                borderSide:const BorderSide(color: const Color.fromARGB(255, 106, 105, 105))
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
                  if (imagePath == "Error") {
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
        const SizedBox(height: 20,),
        Center(
          child: TextButton(onPressed: ()async{
            String state = await addItem(
              nameController.text, 
              stock.toInt(), 
              price.ceilToDouble(), 
              imagePath,
             currentCategory);
             if (state=="Success") {
               showsnackbar(context, "${nameController.text} added successfully");
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


Widget restock(BuildContext context){
  return SingleChildScrollView(
    child: Column(
      children: [
       const SearchBar(
          leading: Icon(Icons.search),
          hintText: "Product to restock",
        ),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: (){
                  showDialog(context: context, 
                  builder: (context){
                    return Dialog(
                      child: SizedBox(
                        height: 120,
                        width: 200,
                        child: Column(
                          children: [
                           const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Product Name",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ),
                           const InputQty.int(
                            initVal: 11,
                           ),
                            TextButton(onPressed: (){}, child:const Text("Done"))
                          ],
                        ),
                      ),
                    );
                  }
                  );
                },
                leading:const CircleAvatar(),
                title:const Text("Product Name"),
                subtitle:const Text("In Stock: 11"),

              ),
            );
          },
        ),
      ],
    ),
  );
}