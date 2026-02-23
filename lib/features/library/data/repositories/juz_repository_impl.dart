import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/database/juz_database_service.dart';
import '../../../../core/database/layout_database_service.dart';
import '../../../../core/database/word_database_service.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';
import '../mappers/juz_mapper.dart';
import '../models/juz_model.dart';

class JuzRepositoryImpl implements JuzRepository {
  final JuzDatabaseService _juzDb;
  final LayoutDatabaseService _layoutDb;
  final WordDatabaseService _wordDb;

  JuzRepositoryImpl(
      this._juzDb,
      this._layoutDb,
      this._wordDb,
      );

  @override
  Future<JuzEntity> getJuzInfo({required int pageNumber}) async {
    final Database layoutDb = await _layoutDb.db;
    final Database wordDb = await _wordDb.db;
    final Database juzDb = await _juzDb.db;

    // 1) Берём линии страницы
    final lines = await layoutDb.query(
      'Table_of_layouts',
      columns: const ['line_type', 'first_word_id', 'line_number'],
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC',
    );

    if (lines.isEmpty) {
      throw StateError('No layout lines found for page=$pageNumber');
    }

    // 2) Ищем первую строку с диапазоном слов:
    //    приоритет: ayah + first_word_id != null
    int? firstWordId;

    for (final row in lines) {
      final lineType = (row['line_type'] ?? '').toString();
      final fw = row['first_word_id'];
      if (fw == null) continue;

      if (lineType == 'ayah') {
        firstWordId = fw as int;
        break;
      }
    }

    // fallback: если вдруг нет ayah (не должно быть), берём первую строку где есть first_word_id
    firstWordId ??= (() {
      for (final row in lines) {
        final fw = row['first_word_id'];
        if (fw != null) return fw as int;
      }
      return null;
    })();

    if (firstWordId == null) {
      throw StateError('No first_word_id found for page=$pageNumber');
    }

    // 3) Получаем surah/ayah по firstWordId
    final wordRows = await wordDb.query(
      'Table_of_words',
      columns: const ['surah', 'ayah'],
      where: 'id = ?',
      whereArgs: [firstWordId],
      limit: 1,
    );

    if (wordRows.isEmpty) {
      throw StateError('Word not found for id=$firstWordId (page=$pageNumber)');
    }

    final int surah = wordRows.first['surah'] as int;
    final int ayah = wordRows.first['ayah'] as int;

    // 4) Загружаем все джузы (30 строк)
    final juzRows = await juzDb.query(
      'Table_of_juzs',
      orderBy: 'juz_number ASC',
    );

    // 5) Определяем juz по verse_mapping
    for (final row in juzRows) {
      final model = JuzModel.fromMap(row);

      final mappingRaw = model.verseMapping.trim();
      if (mappingRaw.isEmpty) continue;

      final dynamic decoded = jsonDecode(mappingRaw);

      if (decoded is! Map) continue;

      final key = surah.toString();
      final dynamic rangeRaw = decoded[key];

      if (rangeRaw == null) continue;

      final rangeStr = rangeRaw.toString(); // пример: "1-141"
      final parts = rangeStr.split('-');
      if (parts.length != 2) continue;

      final start = int.tryParse(parts[0]);
      final end = int.tryParse(parts[1]);
      if (start == null || end == null) continue;

      if (ayah >= start && ayah <= end) {
        return model.toEntity();
      }
    }

    // 6) Если вдруг verse_mapping кривой/пустой — можно fallback-ом проверять first/last key
    // (оставил как явную ошибку, чтобы не скрывать проблему данных)
    throw StateError('Juz not found for page=$pageNumber, verse=$surah:$ayah');
  }
}