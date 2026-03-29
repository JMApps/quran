import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/strings/app_keys.dart';

class AppSettingsState extends ChangeNotifier {
  AppSettingsState() {
    _loadSettings();
  }

  final Box<dynamic> _appSettingsBox = Hive.box(AppKeys.mainAppSettingsBox);

  bool _arabicNameSurah = false;
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

  void _loadSettings() {
    _arabicNameSurah = _appSettingsBox.get(
      AppKeys.keySurahArabicName,
      defaultValue: false,
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
  }
}