import 'package:flutter/material.dart';
import 'package:social_app/Views/View/Chat/MainFriends/main_friends_screen.dart';
import 'package:social_app/Views/View/Home/main_home_screen.dart';

class BottomBarState extends ChangeNotifier {
  int count = 0;

  final List<Widget> pages = const [
    MainHomeScreen() ,
    MainFriendsScreen() ,
  ];

  int countState(int v) {
    notifyListeners();
    return count = v;
  }
}