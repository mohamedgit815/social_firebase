import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Home/mobile_home_page.dart';

class MainHomeScreen extends StatefulWidget {
  static const String home = '/MainHomeScreen';

  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {

  @override
  void initState() {
    super.initState();

    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileHomePage()
    );
  }
}
