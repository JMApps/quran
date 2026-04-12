import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/app_locale.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';
import '../mappers/surah_name_mapper.dart';
import '../models/surah_name_model.dart';

class SurahNameRepositoryImpl implements SurahNameRepository {
  final QuranDatabaseService _quranDatabaseService;

  const SurahNameRepositoryImpl(this._quranDatabaseService);

  String get _locale {
    final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return AppLocale.supportedAppLocales.contains(code) ? code : AppLocale.fallback;
  }

  @override
  Future<List<SurahNameEntity>> getAllSurahs() async {
    final Database database = await _quranDatabaseService.db;
    final List<Map<String, Object?>> allSurahs = await database.query(
      DbValueStrings.tableOfSurahs,
      where: '${DbValueStrings.dbLocale} = ?',
      whereArgs: [_locale],
      orderBy: '${DbValueStrings.dbSurahNumber} ${DbValueStrings.dbOrderASC}',
    );

    final result = allSurahs.map((row) => SurahNameModel.fromMap(row).toEntity()).toList(growable: false);
    if (result.isEmpty) throw Exception('${AppStrings.noDataFor} $_locale');

    return result;
  }
}
