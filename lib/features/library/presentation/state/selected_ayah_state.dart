import 'package:flutter/material.dart';

class SelectedAyahState extends ChangeNotifier {
  int? _surahNumber;
  int? _ayahNumber;

  int? get surahNumber => _surahNumber;
  int? get ayahNumber => _ayahNumber;

  bool isSelected(int surahNumber, int ayahNumber) =>
      _surahNumber == surahNumber && _ayahNumber == ayahNumber;

  void select(int surahNumber, int ayahNumber) {
    if (isSelected(surahNumber, ayahNumber)) {
      _surahNumber = null;
      _ayahNumber = null;
    } else {
      _surahNumber = surahNumber;
      _ayahNumber = ayahNumber;
    }
    notifyListeners();
  }

  void clear() {
    _surahNumber = null;
    _ayahNumber = null;
    notifyListeners();
  }
}