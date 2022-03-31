import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Profile/SwitchPw/mobile_changepw_page.dart';

class MainChangePwScreen extends StatefulWidget {
  static const String changePw = '/MainChangePwScreen';
  const MainChangePwScreen({Key? key}) : super(key: key);

  @override
  State<MainChangePwScreen> createState() => _MainChangePwScreenState();
}

class _MainChangePwScreenState extends State<MainChangePwScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
      mobile: MobileChangePwPage(),
    );
  }
}
