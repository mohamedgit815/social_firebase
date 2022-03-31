import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Post/mobile_posts_page.dart';

class MainPostsScreen extends StatefulWidget {
  static const String posts = '/MainPostsScreen';

  const MainPostsScreen({Key? key}) : super(key: key);

  @override
  State<MainPostsScreen> createState() => _MainPostsScreenState();
}

class _MainPostsScreenState extends State<MainPostsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobilePostsPage()
    );
  }
}
