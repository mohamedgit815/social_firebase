import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen((event) {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: Colors.teal,
          content: const Text('Google'), actions: [
        CustomElevatedButton(onPressed:(){}, child: const Text('Google'))
      ]));
    });

    // FirebaseMessaging.onMessage.listen((event) {
    //   Fluttertoast.showToast(msg: 'Google');
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: Colors.red,
            content: const Text('Google'), actions: [
              CustomElevatedButton(onPressed:(){}, child: const Text('Google'))
        ]));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test'),centerTitle: true,),
      body: Column(
        children: const [

        ],
      ),
    );
  }
}
