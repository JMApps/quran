import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  int _mainNavigatorIndex = 0;

  int get mainNavigatorIndex => _mainNavigatorIndex;

  set mainNavigatorIndex(int index) {
    _mainNavigatorIndex = index;
    notifyListeners();
  }

  int _pageNumber = 1;

  int get currentPage => _pageNumber;

  void onMainPageChanged(int page) {
    if (_pageNumber == page) return;
    _pageNumber = page;
    notifyListeners();
  }

  int _toScrollPageNumber = 1;

  int get toScrollPageNumber => _toScrollPageNumber;

  void onMainPageChangedEnd(int page) {
    if (_toScrollPageNumber == page) return;
    _toScrollPageNumber = page;
    notifyListeners();
  }
}