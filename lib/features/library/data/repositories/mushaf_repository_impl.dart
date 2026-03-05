import 'package:sqflite/sqflite.dart';
import '../../../../core/database/quran_database_service.dart';
import '../models/page_line_dto.dart';

class MushafPageRepository {
  final QuranDatabaseService _dbService;
  const MushafPageRepository(this._dbService);

  Future<List<PageLineDto>> getPageLines(int pageNumber) async {
    final Database db = await _dbService.db;

    final rows = await db.rawQuery(r'''
      SELECT
        l.page_number,
        l.line_number,
        l.line_type,
        l.is_centered,
        l.surah_number,
        l.first_word_id,
        l.last_word_id,
        CASE
          WHEN l.first_word_id IS NOT NULL AND l.last_word_id IS NOT NULL THEN (
            SELECT GROUP_CONCAT(w.text, ' ')
            FROM (
              SELECT text
              FROM Table_of_words_glyph
              WHERE id BETWEEN l.first_word_id AND l.last_word_id
              ORDER BY id ASC
            ) w
          )
          WHEN l.line_type = 'basmallah' THEN '﷽'
          WHEN l.line_type = 'surah_name' AND l.surah_number IS NOT NULL THEN (
            SELECT s.name_arabic
            FROM Table_of_surahs s
            WHERE s.surah_number = l.surah_number
            LIMIT 1
          )
          ELSE ''
        END AS line_text
      FROM Table_of_layouts l
      WHERE l.page_number = ?
      ORDER BY l.line_number ASC;
    ''', [pageNumber]);

    return rows.map((e) => PageLineDto.fromMap(e)).toList(growable: false);
  }
}