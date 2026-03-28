import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/strings/app_keys.dart';

class AppSettingsState extends ChangeNotifier{
  final Box _appSettingsBox = Hive.box(AppKeys.mainAppSettingsBox);

  bool _arabicNameSurah = false;

  bool get arabicNameSurah => _arabicNameSurah;

  set arabicNameSurah(bool arabicNameSurah) {
    _arabicNameSurah = arabicNameSurah;
    _appSettingsBox.put(AppKeys.keySurahArabicName, arabicNameSurah);
    notifyListeners();
  }
}