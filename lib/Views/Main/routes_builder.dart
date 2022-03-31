import 'package:flutter/material.dart';
import 'package:social_app/Views/Authentication/Login/main_login_screen.dart';
import 'package:social_app/Views/Authentication/Register/main_register_screen.dart';
import 'package:social_app/Views/Authentication/Reset/main_reset_screen.dart';
import 'package:social_app/Views/Main/bottom_bar.dart';
import 'package:social_app/Views/View/Chat/MainChat/main_chat_screen.dart';
import 'package:social_app/Views/View/Chat/MainFriends/main_friends_screen.dart';
import 'package:social_app/Views/View/Chat/MainRequests/main_requests_screen.dart';
import 'package:social_app/Views/View/Chat/MainUsers/main_users_chat_screen.dart';
import 'package:social_app/Views/View/Home/Comment/main_comment_screen.dart';
import 'package:social_app/Views/View/Post/main_posts_screen.dart';
import 'package:social_app/Views/View/Profile/Profile/main_profile_screen.dart';
import 'package:social_app/Views/View/Profile/SwitchPw/main_changepw_screen.dart';
import 'package:social_app/Views/View/Profile/Update/main_profileupdate_screen.dart';



class RouteBuilder {
  static Map<String,WidgetBuilder> routes = {
    MainBottomBarScreen.bottomBar : (BuildContext context)=> const MainBottomBarScreen() ,
    MainLoginScreen.login : (BuildContext context)=> const MainLoginScreen() ,
    MainRegisterScreen.register : (BuildContext context)=> const MainRegisterScreen() ,
    MainResetScreen.reset : (BuildContext context)=> const MainResetScreen() ,
    MainChatScreen.chat : (BuildContext context)=> const MainChatScreen() ,
    MainPostsScreen.posts : (BuildContext context)=> const MainPostsScreen() ,
   // MainChatUsersScreen.chatUsers : (BuildContext context)=> const MainChatUsersScreen() ,
    MainCommentScreen.comment : (BuildContext context)=> const MainCommentScreen() ,
    MainProfileScreen.profile : (BuildContext context)=> const MainProfileScreen() ,
    MainRequestsScreen.requests : (BuildContext context)=> const MainRequestsScreen() ,
    MainFriendsScreen.friends : (BuildContext context)=> const MainFriendsScreen() ,
    MainUsersChatScreen.chat : (BuildContext context)=> const MainUsersChatScreen() ,
    MainChangePwScreen.changePw : (BuildContext context)=> const MainChangePwScreen() ,
    MainProfileUpdateScreen.profileUpdate : (BuildContext context)=> const MainProfileUpdateScreen() ,
  };
}