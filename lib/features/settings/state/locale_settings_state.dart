import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/strings/app_keys.dart';
import '../../../core/strings/app_locale.dart';
import '../../../core/strings/app_strings.dart';

class LocaleSettingsState extends ChangeNotifier {
  LocaleSettingsState() {
    _loadSettings();
  }

  final Box<dynamic> _appSettingsBox = Hive.box(AppKeys.mainAppSettingsBox);

  late int _appLocaleIndex;

  int get appLocaleIndex => _appLocaleIndex;

  set appLocaleIndex(int index) {
    if (index < 0 || index >= AppLocale.appLocales.length) return;
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

  void _loadSettings() {
    _appLocaleIndex = _appSettingsBox.get(AppKeys.keyAppLocaleIndex, defaultValue: _defaultLocaleIndex());

    final languageCode = AppLocale.appLocales[_appLocaleIndex].languageCode;
    final defaultIndex = AppStrings.defaultTranslationIndex[languageCode] ?? 0;

    _translationNameIndex = _appSettingsBox.get(AppKeys.keyTranslationNameIndex, defaultValue: defaultIndex);
  }

  int _defaultLocaleIndex() {
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    for (var i = 0; i < AppLocale.appLocales.length; i++) {
      if (AppLocale.appLocales[i].languageCode == deviceCode) return i;
    }
    return 0;
  }

  void reload() {
    _loadSettings();
    notifyListeners();
  }
}