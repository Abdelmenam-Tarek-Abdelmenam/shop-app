import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int activeLayout = 0;

  void changeLayout(int index) {
    if (index == activeLayout) return;
    activeLayout = index;
    notifyListeners();
  }
}
