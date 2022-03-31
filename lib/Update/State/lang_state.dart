import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/Helper/Constance/const_text.dart';

class LangState extends ChangeNotifier {
  final String _key = "lang";
  late SharedPreferences _prefs;
  late String _lang;

  String get lang => _lang;

  LangState() {
    _lang = EnumLang.english.name;
    _loadFromPrefs();
  }

  toggleLang(String langV) {
    _lang = langV;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _lang = _prefs.getString(_key) ?? EnumLang.english.name;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    await _prefs.setString(_key, _lang);
  }
}