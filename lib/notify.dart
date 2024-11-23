import 'dart:io';

import 'package:b_shop_admin/backend_Functions.dart';
import 'package:b_shop_admin/utils.dart';
import 'package:flutter/material.dart';

class name extends StatelessWidget {
  const name({super.key});
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:assetPath.isNotEmpty?DecorationImage(image:FileImage(File(assetPath))):null
                  ),
                  child: InkWell(
                    onTap: ()async{
                      assetPath = await getsingleImage(context);
                      setState((){});
                    },
                    child:const Row(
                      children: [
                        Icon(Icons.image),
                        Text("Attatch an image")
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: "A notification will be sent to this phone to see how it will look like once published",
                child: TextButton(onPressed: (){}, child: Container(
                  padding:const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue),
                    child:const Text("Test"),
                )),
              ),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: "once Published all the user will recieve the notification",
                child: TextButton(onPressed: ()async{
                  showDialog(context: context, builder: (context){
                    return Dialog(
                      child: Column(
                        children: [
                          Icon(Icons.emergency_rounded),
                          Text("Confirm?"),
                          Row(children: [
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
                    );
                  });
                }, child: Container(
                  padding:const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green),
                    child:const Text("Publish"),
                )),
              )
            ],)
          ],
        ),
      ),
    );
  }
}