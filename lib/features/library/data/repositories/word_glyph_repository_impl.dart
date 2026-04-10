import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/word_glyph_entity.dart';
import '../../domain/repositories/word_glyph_repository.dart';
import '../mappers/word_glyph_mapper.dart';
import '../models/word_glyph_model.dart';

class WordGlyphRepositoryImpl implements WordGlyphRepository {
  final QuranDatabaseService _quranDatabaseService;

  const WordGlyphRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<WordGlyphEntity>> getWordsByPage({required int pageNumber}) async {
    final db = await _quranDatabaseService.db;

    final lineRows = await db.query(
      DbValueStrings.tableOfLayouts, // mushaf_page_lines
      columns: ['MIN(${DbValueStrings.dbFirstWordId}) AS min_id', 'MAX(${DbValueStrings.dbLastWordId}) AS max_id'],
      where: '${DbValueStrings.dbPageNumber} = ? AND ${DbValueStrings.dbFirstWordId} IS NOT NULL',
      whereArgs: [pageNumber],
    );

    if (lineRows.isEmpty || lineRows.first['min_id'] == null) return [];

    final minId = lineRows.first['min_id'] as int;
    final maxId = lineRows.first['max_id'] as int;

    final rows = await db.query(
      DbValueStrings.tableOfWordsGlyph,
      where: '${DbValueStrings.dbId} BETWEEN ? AND ?',
      whereArgs: [minId, maxId],
      orderBy: '${DbValueStrings.dbId} ${DbValueStrings.dbOrderASC}',
    );

    return rows.map((row) => WordGlyphModel.fromMap(row).toEntity()).toList(growable: false);
  }
}