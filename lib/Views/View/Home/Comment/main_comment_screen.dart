import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Home/Comment/mobile_comment_screen.dart';

class MainCommentScreen extends StatefulWidget {

  static const String comment = '/MainCommentScreen';

  const MainCommentScreen({Key? key}) : super(key: key);

  @override
  State<MainCommentScreen> createState() => _MainCommentScreenState();
}

class _MainCommentScreenState extends State<MainCommentScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final String _postsId = ModalRoute.of(context)!.settings.arguments as String;

    return ResponsiveBuilderScreen(
        mobile: MobileCommentPage( postId: _postsId )
    );
  }
}
