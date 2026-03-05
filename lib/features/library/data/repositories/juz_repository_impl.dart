import 'dart:convert';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';
import '../mappers/juz_mapper.dart';
import '../models/juz_model.dart';

class JuzRepositoryImpl implements JuzRepository {
  final QuranDatabaseService _quranDatabaseService;

  JuzRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<JuzEntity>> getAllJuzs() async {
    final database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_juzs',
      orderBy: 'juz_number ASC',
    );

    return rows.map((row) => JuzModel.fromMap(row).toEntity()).toList(growable: false);
  }

  @override
  Future<JuzEntity?> getJuzByPage({required int pageNumber}) async {
    final db = await _quranDatabaseService.db;

    // 1) min first_word_id на странице (first_word_id в layout может быть TEXT)
    final minWordRows = await db.rawQuery('''
      SELECT MIN(CAST(first_word_id AS INTEGER)) AS min_id
      FROM Table_of_layouts
      WHERE page_number = ?
        AND line_type = 'ayah'
        AND first_word_id IS NOT NULL
    ''', [pageNumber]);

    final minIdObj = minWordRows.isNotEmpty ? minWordRows.first['min_id'] : null;
    final int? minWordId = minIdObj == null ? null : int.tryParse(minIdObj.toString());
    if (minWordId == null) return null;

    // 2) по word_id получаем surah/ayah (ВАЖНО: Table_of_words_glyph)
    final wRows = await db.query(
      'Table_of_words_glyph',
      columns: const ['surah', 'ayah'],
      where: 'id = ?',
      whereArgs: [minWordId],
      limit: 1,
    );

    if (wRows.isEmpty) return null;

    final int surah = wRows.first['surah'] as int;
    final int ayah = wRows.first['ayah'] as int;

    // 3) находим джуз через verse_mapping
    final juzRows = await db.query('Table_of_juzs', orderBy: 'juz_number ASC');
    for (final row in juzRows) {
      final model = JuzModel.fromMap(row as Map<String, dynamic>);
      if (_isAyahInJuz(model.verseMapping, surah, ayah)) {
        return model.toEntity();
      }
    }

    return null;
  }

  bool _isAyahInJuz(String verseMappingJson, int surah, int ayah) {
    try {
      final decoded = jsonDecode(verseMappingJson);
      if (decoded is! Map) return false;

      final key = surah.toString();
      final value = decoded[key];
      if (value == null) return false;

      final str = value.toString().trim(); // "1-7" или "142-252"
      final parts = str.split('-').map((e) => e.trim()).toList();

      if (parts.isEmpty) return false;

      if (parts.length == 1) {
        final single = int.tryParse(parts[0]);
        return single != null && ayah == single;
      }

      final start = int.tryParse(parts[0]);
      final end = int.tryParse(parts[1]);
      if (start == null || end == null) return false;

      return ayah >= start && ayah <= end;
    } catch (_) {
      return false;
    }
  }
}