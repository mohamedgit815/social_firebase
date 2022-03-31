import 'package:flutter/material.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Profile/Profile/mobile_profile_page.dart';

class MainProfileScreen extends StatefulWidget {
  static const String profile = '/MainProfileScreen';
  const MainProfileScreen({Key? key}) : super(key: key);

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseOnMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _model = ModalRoute.of(context)!.settings.arguments as UserModel;
    return ResponsiveBuilderScreen(
        mobile: MobileProfilePage(requestsModel: _model)
    );
  }
}
