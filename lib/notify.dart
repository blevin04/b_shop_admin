import 'dart:io';

import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:flutter/material.dart';

class Notify extends StatelessWidget {
  const Notify({super.key});
static TextEditingController titlecontroller = TextEditingController();
static TextEditingController bodycontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String assetPath = "";
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Create a notification for your customers"),
            const SizedBox(height: 20,),
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:const BorderSide(color: Colors.grey)
                ),
                hintText: "Notification title",
              ),
              
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: bodycontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:const BorderSide(color: Colors.grey)
                ),
                hintText: "Notification body",
              ),
            ),
            const SizedBox(height: 20,),
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  padding:const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    image:assetPath.isNotEmpty?DecorationImage(image:FileImage(File(assetPath))):null
                  ),
                  child: Stack(
                    children: [
                       assetPath.isNotEmpty? Image(image: FileImage(File(assetPath))):Container(),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: ()async{
                          assetPath = await getsingleImage(context);
                          setState((){});
                        },
                        child:const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image),
                            Text("Attatch an image")
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Tooltip(
                
                triggerMode: TooltipTriggerMode.tap,
                message: "A notification will be sent to this phone to see how it will look like once published",
                child: TextButton(onPressed: ()async{
                  if (titlecontroller.text.isNotEmpty && bodycontroller.text.isNotEmpty) {
                    print("Deams");
                    await showNotification(titlecontroller.text, bodycontroller.text, assetPath);
                  }
                }, 
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/2,
                  padding:const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                    child:const Text("Preview",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                )),
              ),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: "once Published all the user will recieve the notification",
                child: TextButton(onPressed: ()async{
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      child: Container(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.notifications),
                            const Text("Confirm?"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                              TextButton(onPressed: ()async{
                                String state = "";
                                while (state.isEmpty) {
                                  showcircleprogress(context);
                                  state = await sendMessage(
                                    titlecontroller.text, 
                                    bodycontroller.text,
                                     assetPath);
                                }
                                Navigator.pop(context);
                                if (state == "Success") {
                                  showsnackbar(context, "Notification Sent");
                                  Navigator.pop(context);
                                }
                              }, child:const Text("Publish")),
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child:const Text("Cancel"))
                            ],)
                          ],
                        ),
                      ),
                    );
                  });
                }, child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/1.5,
                  padding:const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green),
                    child:const Text("Publish",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                )),
              )
            ],)
          ],
        ),
      ),
    );
  }
}