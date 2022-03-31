import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'mobile_users_chat_page.dart';


class MainUsersChatScreen extends StatefulWidget {
  static const String chat = '/MainUsersChatScreen';

  const MainUsersChatScreen({Key? key}) : super(key: key);

  @override
  State<MainUsersChatScreen> createState() => _MainUsersChatScreenState();
}

class _MainUsersChatScreenState extends State<MainUsersChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileUsersChatPage()
    );
  }
}
