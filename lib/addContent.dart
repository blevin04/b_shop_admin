import 'package:flutter/material.dart';

class Addcontent extends StatelessWidget {
  const Addcontent({super.key});
static PageController _pageController = PageController();
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
                  child: Text("New Item",
                 
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
                      child: Text(
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
          add(context),
          restock(context)
        ],
      ) ,
    );
  }
}
Widget add(BuildContext context){
  String initial_category = "Select Category";
  List categories = [
    "Gas",
    "Cerials",
    "Food Stuffs",
    "Other",
  ];
  bool categorydrop=false;
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text("Add Product",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Name"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
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
          child: TextField(
            decoration: InputDecoration(
              hintText: "Product Price",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:const BorderSide(color:  Color.fromARGB(255, 106, 105, 105))
              )
            ),
          ),
        ),
        Container(
          margin:const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromARGB(255, 84, 82, 82))
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(onPressed: (){}, 
              icon:const Column(
                children: [
                  Icon(Icons.add_a_photo),
                  Text("Add Image")
                ],
              ))
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context,categorystate) {
            return Container(
              margin:const EdgeInsets.only(left: 20,right: 20,top: 5),
              padding:const EdgeInsets.all(5),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromARGB(255, 84, 82, 82))
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(initial_category),
                      IconButton(onPressed: (){
                        categorystate((){
                          categorydrop = !categorydrop;
                        });
                      }, icon:const Icon(Icons.keyboard_arrow_down))
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
                            initial_category = categories[index];
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
          child: TextField(
            decoration: InputDecoration(
              hintText: "Number In stock",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:const BorderSide(color:  Color.fromARGB(255, 106, 105, 105))
              )
            ),
          ),
        ),
        const SizedBox(height: 20,),
        const SizedBox(height: 20,),
        Center(
          child: TextButton(onPressed: (){}, 
          child: Container(
            padding:const EdgeInsets.all(10),
            child:const Text("Add Product"),)
          ),
        )
      ],
    ),
  );
}

Widget restock(BuildContext context){
  return SingleChildScrollView(
    child: Column(
      children: [
        SearchBar(
          leading: Icon(Icons.search),
          hintText: "Product to restock",
        )
      ],
    ),
  );
}