import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Update/State/bottombar_state.dart';


class MainBottomBarScreen extends ConsumerStatefulWidget {
  static const String bottomBar = '/MainBottomBarScreen';
  const MainBottomBarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainBottomBarScreen> createState() => _MainBottomBarScreenState();
}

class _MainBottomBarScreenState extends ConsumerState<MainBottomBarScreen> {
  final DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    ChatFunctions.updateDateChat();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        Directionality(
          textDirection: TextDirection.ltr,
          child: WillPopScope(
            onWillPop: () async {
              return customExitApp(dateTime: _dateTime);
            },
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.home_outlined),label: '${TextTranslate.translateText(EnumLang.textHome.name, context)}') ,
                  BottomNavigationBarItem(icon: const Icon(Icons.chat_bubble_outline),label: '${TextTranslate.translateText(EnumLang.textChat.name, context)}') ,
                ],
                currentIndex: ref.read(_bottomBar).count,
                onTap: (int v){
                  ref.read(_bottomBar).countState(v);
                },
              ),
              body: Stack(
                    children: ref.read(_bottomBar).pages.asMap()
                        .map((i, screen) => MapEntry(i,
                        Offstage(offstage: ref.watch(_bottomBar).count != i,child: screen,)))
                        .values.toList()

                ),
            ),
          ),
        ),

      ],
    );
  }
}

final  _bottomBar = ChangeNotifierProvider<BottomBarState>((ref)=>BottomBarState());