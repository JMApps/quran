import 'package:sqflite/sqflite.dart';

import '../../../../core/database/word_database_service.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/word_repository.dart';
import '../mappers/word_mapper.dart';
import '../models/word_model.dart';

class WordRepositoryImpl implements WordRepository {
  final WordScriptDatabaseService _wordScriptDatabaseService;

  WordRepositoryImpl(this._wordScriptDatabaseService);

  @override
  Future<List<WordEntity>> getWordsByRange({
    required int fromId,
    required int toId,
  }) async {
    final Database db = await _wordScriptDatabaseService.db;

    final rows = await db.rawQuery(
      '''
      SELECT
        wid AS id,
        location,
        surah,
        ayah,
        word,
        text
      FROM (
        SELECT
          ROW_NUMBER() OVER (ORDER BY surah, ayah, word) AS wid,
          location,
          surah,
          ayah,
          word,
          text
        FROM Table_of_words
      )
      WHERE wid BETWEEN ? AND ?
      ORDER BY wid ASC
      ''',
      [fromId, toId],
    );

    return rows.map((row) => WordModel.fromMap(row).toEntity()).toList();
  }
}
