import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Profile/Update/mobile_profileupdate_screen.dart';


class MainProfileUpdateScreen extends StatefulWidget {
  static const String profileUpdate = '/MainProfileUpdateScreen';

  const MainProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  State<MainProfileUpdateScreen> createState() => _MainProfileUpdateScreenState();
}

class _MainProfileUpdateScreenState extends State<MainProfileUpdateScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    return ResponsiveBuilderScreen(
        mobile: MobileProfileUpdatePage(userModel: userModel)
    );
  }
}
