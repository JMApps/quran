import 'package:flutter/foundation.dart';
import 'package:quran/core/theme/app_strings.dart';

class SurahState extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  set currentPageIndex(int value) {
    if (value == _currentPageIndex) return;
    _currentPageIndex = value;
    notifyListeners();
  }

  int get currentPageNumber => AppStrings.totalPages - _currentPageIndex;

  // если тебе нужно устанавливать номер страницы напрямую:
  set currentPageNumber(int pageNumber) {
    final idx = AppStrings.totalPages - pageNumber;
    if (idx == _currentPageIndex) return;
    _currentPageIndex = idx;
    notifyListeners();
  }

  int _surah = 1;
  int _ayah = 1;
  int _globalIndex = 0;

  void setCurrentAyah({
    required int surah,
    required int ayah,
    required int globalIndex,
  }) {
    _surah = surah;
    _ayah = ayah;
    _globalIndex = globalIndex;
    notifyListeners();
  }

  String get currentAyahTitle => 'Сура $_surah • Аят $_ayah';
  int get currentGlobalIndex => _globalIndex;
}