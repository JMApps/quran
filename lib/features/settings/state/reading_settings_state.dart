import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/strings/app_keys.dart';

class ReadingSettingsState extends ChangeNotifier {
  final Box<dynamic> _appSettingsBox = Hive.box(AppKeys.mainAppSettingsBox);

  ReadingSettingsState() {
    _loadSettings();
  }

  bool _arabicNameSurah = true;
  bool get arabicNameSurah => _arabicNameSurah;

  set arabicNameSurah(bool value) {
    if (_arabicNameSurah == value) return;
    _arabicNameSurah = value;
    _appSettingsBox.put(AppKeys.keySurahArabicName, value);
    notifyListeners();
  }

  bool _translationNameSurah = true;
  bool get translationNameSurah => _translationNameSurah;

  set translationNameSurah(bool value) {
    if (_translationNameSurah == value) return;
    _translationNameSurah = value;
    _appSettingsBox.put(AppKeys.keyTranslationNameSurah, value);
    notifyListeners();
  }

  double _ayahArabicTextSize = 21.0;

  double get ayahArabicTextSize => _ayahArabicTextSize;

  set ayahArabicTextSize(double size) {
    if (_ayahArabicTextSize == size) return;
    _ayahArabicTextSize = size;
    _appSettingsBox.put(AppKeys.keyAyahArabicTextSize, size);
    notifyListeners();
  }

  double _ayahTranslationTextSize = 17.0;

  double get ayahTranslationTextSize => _ayahTranslationTextSize;

  set ayahTranslationTextSize(double size) {
    if (_ayahTranslationTextSize == size) return;
    _ayahTranslationTextSize = size;
    _appSettingsBox.put(AppKeys.keyAyahTranslationTextSize, size);
    notifyListeners();
  }

  bool _isArabicAyahShow = true;

  bool get isArabicAyahShow => _isArabicAyahShow;

  set isArabicAyahShow(bool state) {
    if (_isArabicAyahShow == state) return;

    if (!state && !_isTranslationAyahShow) {
      _isTranslationAyahShow = true;
      _appSettingsBox.put(AppKeys.keyShowTranslationAyah, true);
    }

    _isArabicAyahShow = state;
    _appSettingsBox.put(AppKeys.keyShowArabicAyah, state);
    notifyListeners();
  }

  bool _isTranslationAyahShow = true;

  bool get isTranslationAyahShow => _isTranslationAyahShow;

  set isTranslationAyahShow(bool state) {
    if (_isTranslationAyahShow == state) return;

    if (!state && !_isArabicAyahShow) {
      _isArabicAyahShow = true;
      _appSettingsBox.put(AppKeys.keyShowArabicAyah, true);
    }

    _isTranslationAyahShow = state;
    _appSettingsBox.put(AppKeys.keyShowTranslationAyah, state);
    notifyListeners();
  }

  void _loadSettings() {
    _arabicNameSurah = _appSettingsBox.get(
      AppKeys.keySurahArabicName,
      defaultValue: true,
    );

    _translationNameSurah = _appSettingsBox.get(
      AppKeys.keyTranslationNameSurah,
      defaultValue: true,
    );

    _isArabicAyahShow = _appSettingsBox.get(AppKeys.keyShowArabicAyah, defaultValue: true);
    _isTranslationAyahShow = _appSettingsBox.get(AppKeys.keyShowTranslationAyah, defaultValue: true);

    _ayahArabicTextSize = _appSettingsBox.get(AppKeys.keyAyahArabicTextSize, defaultValue: 21.0);
    _ayahTranslationTextSize = _appSettingsBox.get(AppKeys.keyAyahTranslationTextSize, defaultValue: 17.0);
  }

  void reload() {
    _loadSettings();
    notifyListeners();
  }
}