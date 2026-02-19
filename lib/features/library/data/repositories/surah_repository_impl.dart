import 'package:sqflite/sqflite.dart';

import '../../../../core/database/surahs_database_service.dart';
import '../../domain/entities/surah_entity.dart';
import '../../domain/repositories/surah_repository.dart';
import '../mappers/surah_mapper.dart';
import '../models/surah_model.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahsDatabaseService _surahsDatabaseService;

  SurahRepositoryImpl(this._surahsDatabaseService);

  @override
  Future<List<SurahEntity>> getAllSurahs() async {
    final Database database = await _surahsDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_surahs',
      orderBy: 'id ASC',
    );

    return rows.map((row) => SurahModel.fromMap(row).toEntity()).toList();
  }
}
