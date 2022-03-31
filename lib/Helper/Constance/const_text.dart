import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/Views/Main/app_localizations.dart';


enum EnumLang{
  /// The Main Languages in The Application
  english , arabic , espanol ,

  /// Text Languages
  textProfile , textHome , textAccount , textLogOut , textChange , textUpdate ,
  textSetting , textSure , textYes , textNo , textChooseLang , textChat , textPost ,
  textWrite , textDelete
}

class TextTranslate {
  static Locale switchLang(String lang){
    SharedPreferences.getInstance().then((value) async {
      await value.setString('lang', lang);
    });
    if(lang == 'english'){
       lang = 'en';
    } else if(lang == 'arabic'){
      lang = 'ar';
    } else if(lang == 'espanol') {
      lang = 'es';
    }
    return Locale(lang,'');
  }

  static String? translateText(String text,BuildContext context){
    return AppLocalization.of(context)!.translate(text);
  }
}