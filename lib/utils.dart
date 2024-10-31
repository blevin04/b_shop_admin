import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

showsnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<List<String>> getImage(BuildContext context)async{
  List<String> image = [];
  Permission.accessMediaLocation
    .onDeniedCallback(() async {
  Permission.accessMediaLocation.request();
  if (await Permission.accessMediaLocation.isDenied) {
    showsnackbar(context, "Permission denied");
  }
  if (await Permission.accessMediaLocation.isGranted) {
    showsnackbar(context, 'Granted');
  }
});
FilePickerResult? result = (await FilePicker.platform
    .pickFiles(type: FileType.image,allowMultiple: true));
if (result != null) {
  result.files.forEach((value){
    image.add(value.path!);
  });
  
 // setState(() {});
}
if (result == null) {
  showsnackbar(context, 'no image chossen');
}
return image;
}

void addCategory(){

}