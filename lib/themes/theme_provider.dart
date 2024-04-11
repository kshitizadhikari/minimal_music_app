import 'package:flutter/material.dart';
import 'package:minimal_music_app/themes/dark_mode.dart';
import 'package:minimal_music_app/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initial mode
  ThemeData _themeData = lightMode;

  //get theme
  ThemeData get themeData => _themeData;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    //update UI
    notifyListeners();
  }
  //is darkMode
  bool get isDarkMode => _themeData == darkMode;

  //toggle theme
  void toggleTheme() {
    if(_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
