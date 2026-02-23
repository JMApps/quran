import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/word_repository.dart';
import '../mappers/word_mapper.dart';
import '../models/word_model.dart';

class WordRepositoryImpl implements WordRepository {
  final QuranDatabaseService _quranDatabaseService;

  WordRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<WordEntity>> getWordsByRange({required int fromId, required int toId}) async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_words',
      where: 'id BETWEEN ? AND ?',
      whereArgs: [fromId, toId],
      orderBy: 'id ASC',
    );

    return rows.map((row) => WordModel.fromMap(row).toEntity()).toList();
  }
}
