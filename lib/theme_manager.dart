import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  SharedPreferences prefs;

  ThemeManager(this.prefs) {
    String theme = prefs.getString("theme") ?? "light";
    _themeMode = theme == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  void toggleTheme(bool isDark) { 
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if(isDark){
      prefs.setString("theme", "dark");
    }else{
      prefs.setString("theme", "light");
    }
    notifyListeners();
  }
}
