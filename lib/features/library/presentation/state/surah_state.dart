import 'package:flutter/material.dart';

class SurahState extends ChangeNotifier {
  bool _showFab = false;
  bool get showFab => _showFab;

  int _currentPageNumber = 1;

  void updateFabVisibility(double offset) {
    final shouldShow = offset > 200;

    if (shouldShow != _showFab) {
      _showFab = shouldShow;
      notifyListeners();
    }
  }

  int get currentPageNumber => _currentPageNumber;

  set currentPageNumber(int pageNumber) {
    _currentPageNumber = pageNumber;
    notifyListeners();
  }
}