import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Update/State/switch_state.dart';

class ConstWidgets {
  static IconButton iconButtonVisibility({
    required WidgetRef ref ,
    required IconData icon ,
    required ChangeNotifierProvider<SwitchState> state ,
    VoidCallback? onPressed ,
    Color? color ,
  }){
    return IconButton(
        onPressed: onPressed ?? (){
          ref.read(state).funcSwitch();
        },
        icon: Icon(icon,color: color ?? normalWhite ));
  }
}