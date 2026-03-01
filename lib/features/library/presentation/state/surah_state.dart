import 'package:flutter/material.dart';

import '../../../../core/theme/app_strings.dart';

class SurahState extends ChangeNotifier {
  // PageView index: 0..603
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  int get currentPageNumber => _currentPageIndex + 1;

  set currentPageIndex(int index) {
    final clamped = index.clamp(0, AppStrings.totalPages - 1);
    if (clamped == _currentPageIndex) return;
    _currentPageIndex = clamped;
    notifyListeners();
  }

  int get lastPageIndex => AppStrings.totalPages - 1;
  bool get isAtEnd => _currentPageIndex >= lastPageIndex;
}