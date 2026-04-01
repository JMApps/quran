import 'package:quran/features/library/domain/repositories/layout_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/layout_entity.dart';
import '../mappers/layout_mapper.dart';
import '../models/layout_model.dart';

class LayoutRepositoryImpl implements LayoutRepository {
  final QuranDatabaseService _dbService;

  const LayoutRepositoryImpl(this._dbService);

  @override
  Future<List<LayoutEntity>> getLinesByPage({required int pageNumber}) async {
    final Database db = await _dbService.db;

    final rows = await db.rawQuery('''
      SELECT
        l.page_number,
        l.line_number,
        l.line_type,
        l.is_centered,
        l.first_word_id,
        l.last_word_id,
        l.surah_number,
        CASE
          WHEN l.first_word_id IS NOT NULL AND l.last_word_id IS NOT NULL THEN (
            SELECT GROUP_CONCAT(text, ' ')
            FROM (
              SELECT w.text
              FROM Table_of_words_glyph w
              WHERE CAST(w.id AS INTEGER) BETWEEN CAST(l.first_word_id AS INTEGER) AND CAST(l.last_word_id AS INTEGER)
              ORDER BY CAST(w.id AS INTEGER) ASC
            )
          )
          WHEN l.line_type = 'basmallah' THEN '﷽'
          ELSE ''
        END AS line_text,
        CASE
          WHEN l.line_type = 'surah_name' AND l.surah_number IS NOT NULL THEN (
            SELECT s.name_arabic
            FROM Table_of_surahs s
            WHERE s.surah_number = l.surah_number
            LIMIT 1
          )
          ELSE ''
        END AS surah_name_text
      FROM Table_of_layouts l
      WHERE l.page_number = ?
      ORDER BY CAST(l.line_number AS INTEGER) ASC
    ''', [pageNumber]);

    return rows
        .map((e) => LayoutModel.fromMap(e).toEntity())
        .toList(growable: false);
  }
}