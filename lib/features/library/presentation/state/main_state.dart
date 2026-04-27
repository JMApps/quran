import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  int _mainNavigatorIndex = 0;

  int get mainNavigatorIndex => _mainNavigatorIndex;

  set mainNavigatorIndex(int index) {
    _mainNavigatorIndex = index;
    notifyListeners();
  }
}