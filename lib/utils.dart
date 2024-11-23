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

showcircleprogress(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return   StatefulBuilder(
    builder: (BuildContext context, setState) {
      return  FutureBuilder(
        future: Future.delayed(const Duration(seconds: 5)),
       
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 120,
            width: 120,
            color:const Color.fromARGB(84, 50, 50, 50),
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(131, 128, 124, 124),
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        );
          }
          return Container();
        },
      );
      
          }
        );
       
      });
}

Future<String> getsingleImage(BuildContext context)async{
    String image = "";
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
    .pickFiles(type: FileType.image,allowMultiple: false));
if (result != null) {
  image = result.files.single.path!;
 // setState(() {});
}
if (result == null) {
  showsnackbar(context, 'no image chossen');
}
return image;
}