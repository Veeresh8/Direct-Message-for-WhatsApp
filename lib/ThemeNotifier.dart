import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  ThemeMode getCurrentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}