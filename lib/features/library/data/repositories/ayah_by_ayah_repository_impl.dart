import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final QuranDatabaseService _quranDatabaseService;

  AyahByAyahRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<AyahByAyahEntity>> getAyahsByPage({
    required int pageNumber,
    required String tableName,
  }) async {
    final db = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT DISTINCT
        m.ayah_id,
        m.verse_key,
        m.surah_number,
        m.ayah_number,
        m.ayah_arabic,
        t.ayah_translation AS ayah_translation
      FROM Table_of_layouts l
      JOIN Table_of_words_glyph w
          ON w.id BETWEEN CAST(l.first_word_id AS INTEGER) AND CAST(l.last_word_id AS INTEGER)
      JOIN Table_of_mushaf m
          ON m.surah_number = w.surah
         AND m.ayah_number = w.ayah
      JOIN $tableName t
          ON t.ayah_id = m.ayah_id
      WHERE l.page_number = ?
        AND l.line_type = 'ayah'
      ORDER BY m.surah_number, m.ayah_number
      ''',
      [pageNumber],
    );

    return result
        .map((map) => AyahByAyahModel.fromMap(map).toEntity())
        .toList();
  }
}