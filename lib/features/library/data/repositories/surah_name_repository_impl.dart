import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';
import '../mappers/surah_name_mapper.dart';
import '../models/surah_name_model.dart';

class SurahNameRepositoryImpl implements SurahNameRepository {
  final QuranDatabaseService _quranDatabaseService;

  SurahNameRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<SurahNameEntity>> getAllSurahs() async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> allSurahs = await database.query(
      DbValueStrings.tableOfSurahs,
      orderBy: 'surah_number ASC',
    );

    return allSurahs.map((row) => SurahNameModel.fromMap(row).toEntity()).toList(growable: false);
  }

  @override
  Future<SurahNameEntity?> getSurahByPage({required int pageNumber}) async {
    final Database database = await _quranDatabaseService.db;

    final surahByPage = await database.query(
      DbValueStrings.tableOfSurahs,
      where: 'start_page_number <= ?',
      whereArgs: [pageNumber],
      orderBy: 'start_page_number DESC',
      limit: 1,
    );

    if (surahByPage.isEmpty) return null;

    return SurahNameModel.fromMap(surahByPage.first).toEntity();
  }
}
