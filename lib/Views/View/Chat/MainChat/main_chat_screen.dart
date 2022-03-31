import 'package:flutter/material.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Chat/MainChat/mobile_chat_page.dart';


class MainChatScreen extends StatelessWidget {
  static const String chat = '/MainChatScreen';

  const MainChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel _data = ModalRoute.of(context)!.settings.arguments as UserModel;
    return ResponsiveBuilderScreen(
        mobile: MobileChatPage(userModel: _data,)
    );
  }
}
