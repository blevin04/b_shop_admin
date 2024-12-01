import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});
  static TextEditingController emailcontroller = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: "Admin Email",
                border: OutlineInputBorder(
                  borderSide:const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
            const SizedBox(height: 50,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Admin Account Password",
                border: OutlineInputBorder(
                  borderSide:const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              child: InkWell(
                onTap: (){
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcontroller.text, password: passwordController.text);
                },
                child:const Text("Log In",style: TextStyle(fontSize: 16),),
              ),
            )

          ],
        ),
      ),
    );
  }
}