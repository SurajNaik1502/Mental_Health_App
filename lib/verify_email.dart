import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_med_app/wrapper.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState() {
    sendverifylink();
    super.initState();
  }

  sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification().then((value) => {
          Get.snackbar('Link sent', 'A link has been sent to your Email',
              margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM)
        });
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => {Get.offAll(Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Text(
              'Open your email and click on the link provided to verify mail and then reload this page!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => reload()),
        child: Icon(Icons.refresh_sharp),
      ),
    );
  }
}
