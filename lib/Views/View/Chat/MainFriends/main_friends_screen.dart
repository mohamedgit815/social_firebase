import 'package:flutter/material.dart';
import 'package:social_app/Views/Main/responsive_builder.dart';
import 'package:social_app/Views/View/Chat/MainFriends/mobile_friends_page.dart';

class MainFriendsScreen extends StatelessWidget {
  static const String friends = '/MainFriendsScreen';
  const MainFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileFriendsPage()
    );
  }
}
