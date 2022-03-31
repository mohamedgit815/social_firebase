import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/Functions/home_functions.dart';
import 'package:social_app/Update/State/lang_state.dart';
import 'package:social_app/Update/State/theme_state.dart';


final themeProv = ChangeNotifierProvider((ref)=>ThemeState());
final langProv = ChangeNotifierProvider((ref)=>LangState());
final myDataProv = StreamProvider((ref)=>AuthFunctions.getUserData());
final fetchHomeProv = FutureProvider((ref)=>HomeFunctions.fetchHomeData());

