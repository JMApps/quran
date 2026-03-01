import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/ayah_word_entity.dart';
import '../../domain/repositories/ayah_word_repository.dart';
import '../mappers/ayah_word_mapper.dart';
import '../models/ayah_word_model.dart';

class AyahWordRepositoryImpl implements AyahWordRepository {
  final QuranDatabaseService _quranDatabaseService;

  AyahWordRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<AyahWordEntity>> getWordsByRange({required int fromId, required int toId}) async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_words',
      where: 'id BETWEEN ? AND ?',
      whereArgs: [fromId, toId],
      orderBy: 'id ASC',
    );

    return rows.map((row) => AyahWordModel.fromMap(row).toEntity()).toList();
  }
}
