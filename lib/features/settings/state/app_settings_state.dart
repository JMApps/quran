import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/strings/app_keys.dart';
import '../../../core/strings/app_locale.dart';
import '../../../core/strings/app_strings.dart';

class AppSettingsState extends ChangeNotifier {
  AppSettingsState() {
    _loadSettings();
  }

  final Box<dynamic> _appSettingsBox = Hive.box(AppKeys.mainAppSettingsBox);

  late int _appLocaleIndex;

  int get getAppLocaleIndex => _appLocaleIndex;

  set setAppLocaleIndex(int index) {
    if (_appLocaleIndex != index) {
      _appLocaleIndex = index;
      _appSettingsBox.put(AppKeys.keyAppLocaleIndex, index);
      notifyListeners();
    }
  }

  late int _translationNameIndex;

  int get translationNameIndex => _translationNameIndex;

  set translationNameIndex(int index) {
    if (_translationNameIndex != index) {
      _translationNameIndex = index;
      _appSettingsBox.put(AppKeys.keyTranslationNameIndex, index);
      notifyListeners();
    }
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

  bool _displayAlwaysOn = true;
  bool get displayAlwaysOn => _displayAlwaysOn;

  Future<void> setDisplayAlwaysOn(bool value) async {
    if (_displayAlwaysOn == value) return;

    _displayAlwaysOn = value;
    await WakelockPlus.toggle(enable: value);
    _appSettingsBox.put(AppKeys.keyAlwaysDisplayOn, value);
    notifyListeners();
  }

  int _appThemeModeIndex = 0;
  int get appThemeModeIndex => _appThemeModeIndex;

  set appThemeModeIndex(int value) {
    if (_appThemeModeIndex == value) return;
    _appThemeModeIndex = value;
    _appSettingsBox.put(AppKeys.keyAppThemeModeIndex, value);
    notifyListeners();
  }

  ThemeMode get appThemeMode {
    switch (_appThemeModeIndex) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Color _themeColor = Colors.brown;
  Color get themeColor => _themeColor;

  set themeColor(Color color) {
    if (_themeColor == color) return;
    _themeColor = color;
    _appSettingsBox.put(AppKeys.keyAppThemeColor, color.toARGB32());
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

  double _ayahTranslationTextSize = 19.0;

  double get ayahTranslationTextSize => _ayahTranslationTextSize;

  set ayahTranslationTextSize(double size) {
    if (_ayahTranslationTextSize == size) return;
    _ayahTranslationTextSize = size;
    _appSettingsBox.put(AppKeys.keyAyahTranslationTextSize, size);
    notifyListeners();
  }

  void _loadSettings() {
    _appLocaleIndex = _appSettingsBox.get(AppKeys.keyAppLocaleIndex, defaultValue: _defaultLocaleIndex());

    final languageCode = AppLocale.appLocales[_appLocaleIndex].languageCode;
    final defaultIndex = AppStrings.defaultTranslationIndex[languageCode] ?? 0;

    _translationNameIndex = _appSettingsBox.get(AppKeys.keyTranslationNameIndex, defaultValue: defaultIndex);

    _arabicNameSurah = _appSettingsBox.get(
      AppKeys.keySurahArabicName,
      defaultValue: true,
    );

    _translationNameSurah = _appSettingsBox.get(
      AppKeys.keyTranslationNameSurah,
      defaultValue: true,
    );

    _displayAlwaysOn = _appSettingsBox.get(
      AppKeys.keyAlwaysDisplayOn,
      defaultValue: true,
    );

    unawaited(WakelockPlus.toggle(enable: _displayAlwaysOn));

    _themeColor = Color(
      _appSettingsBox.get(
        AppKeys.keyAppThemeColor,
        defaultValue: Colors.brown.toARGB32(),
      ),
    );

    _appThemeModeIndex = _appSettingsBox.get(
      AppKeys.keyAppThemeModeIndex,
      defaultValue: 0,
    );

    _ayahArabicTextSize = _appSettingsBox.get(AppKeys.keyAyahArabicTextSize, defaultValue: 21.0);
    _ayahTranslationTextSize = _appSettingsBox.get(AppKeys.keyAyahTranslationTextSize, defaultValue: 19.0);
  }

  int _defaultLocaleIndex() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    switch (deviceLocale.languageCode) {
      case 'ru':
        return 0;
      case 'en':
        return 1;
      default:
        return 0;
    }
  }
}