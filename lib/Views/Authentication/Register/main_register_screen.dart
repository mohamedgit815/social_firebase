import 'package:social_app/Views/Authentication/Register/mobile_register_page.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:flutter/material.dart';

class MainRegisterScreen extends StatelessWidget {
  static const String register = '/MainRegisterScreen';
  const MainRegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileRegisterPage()
    );
  }
}
