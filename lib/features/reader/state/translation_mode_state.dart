import 'package:flutter/material.dart';

class TranslationModeState extends ChangeNotifier {

  bool _translationMode = false;

  bool get translationMode => _translationMode;

  void changeTranslationMode() {
    _translationMode = !translationMode;
    notifyListeners();
  }
}