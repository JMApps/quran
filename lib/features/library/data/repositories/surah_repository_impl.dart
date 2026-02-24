import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/surah_repository.dart';
import '../mappers/surah_mapper.dart';
import '../models/surah_model.dart';

class SurahRepositoryImpl implements SurahRepository {
  final QuranDatabaseService _quranDatabaseService;

  SurahRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<SurahEntity>> getAllSurahs() async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_surahs',
      orderBy: 'surah_number ASC',
    );

    return rows.map((row) => SurahModel.fromMap(row).toEntity()).toList();
  }

  @override
  Future<SurahEntity?> getSurahByPage({required int pageNumber}) async {
    final Database database = await _quranDatabaseService.db;

    final rows = await database.query(
      'Table_of_surahs',
      where: 'start_page_number <= ?',
      whereArgs: [pageNumber],
      orderBy: 'start_page_number DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return SurahModel.fromMap(rows.first).toEntity();
  }
}
