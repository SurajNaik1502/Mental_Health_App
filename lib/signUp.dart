import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_med_app/wrapper.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email.text, password: password.text);
    Get.offAll(Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter Email'),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Enter Password'),
            ),
            ElevatedButton(onPressed: (() => signUp()), child: Text('SignUp')),
          ],
        ),
      ),
    );
  }
}
