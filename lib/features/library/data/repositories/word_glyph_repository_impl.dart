import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/entities/line_type.dart';
import '../../domain/entities/word_glyph_entity.dart';
import '../../domain/repositories/word_glyph_repository.dart';

class WordGlyphRepositoryImpl implements WordGlyphRepository {
  final QuranDatabaseService _quranDatabaseService;

  const WordGlyphRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<LayoutEntity>> getMushafPageData({
    required int pageNumber,
  }) async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.rawQuery(
      '''
      SELECT
        l.${DbValueStrings.dbPageNumber}   AS ${DbValueStrings.dbPageNumber},
        l.${DbValueStrings.dbLineNumber}   AS ${DbValueStrings.dbLineNumber},
        l.${DbValueStrings.dbLineType}     AS ${DbValueStrings.dbLineType},
        l.${DbValueStrings.dbIsCentered}   AS ${DbValueStrings.dbIsCentered},
        l.${DbValueStrings.dbSurahNumber}  AS layout_surah_number,

        gw.${DbValueStrings.dbId}          AS ${DbValueStrings.dbId},
        gw.${DbValueStrings.dbLocation}    AS ${DbValueStrings.dbLocation},
        gw.${DbValueStrings.dbSurahNumber} AS word_surah_number,
        gw.${DbValueStrings.dbAyahNumber}  AS ${DbValueStrings.dbAyahNumber},
        gw.${DbValueStrings.dbWordNumber}  AS ${DbValueStrings.dbWordNumber},
        gw.${DbValueStrings.dbGlyph}       AS ${DbValueStrings.dbGlyph},
        gw.${DbValueStrings.dbWholeWord}   AS ${DbValueStrings.dbWholeWord}
      FROM ${DbValueStrings.tableOfLayouts} AS l
      LEFT JOIN ${DbValueStrings.tableOfGlyphsWords} AS gw
        ON gw.${DbValueStrings.dbId}
           BETWEEN l.${DbValueStrings.dbFirstWordId}
               AND l.${DbValueStrings.dbLastWordId}
      WHERE l.${DbValueStrings.dbPageNumber} = ?
      ORDER BY
        l.${DbValueStrings.dbLineNumber} ASC,
        gw.${DbValueStrings.dbId} ASC
      ''',
      <Object?>[pageNumber],
    );

    final Map<int, _LineAccumulator> grouped = <int, _LineAccumulator>{};

    for (final row in rows) {
      final int lineNumber = row[DbValueStrings.dbLineNumber] as int;

      grouped.putIfAbsent(
        lineNumber,
            () => _LineAccumulator(
          pageNumber: row[DbValueStrings.dbPageNumber] as int,
          lineNumber: lineNumber,
          lineType: AppStrings.lineTypeFromDb(
            row[DbValueStrings.dbLineType].toString(),
          ),
          isCentered: _asBool01(row[DbValueStrings.dbIsCentered]),
          surahNumber: _asNullableInt(row['layout_surah_number']),
        ),
      );

      final Object? wordId = row[DbValueStrings.dbId];
      if (wordId == null) {
        continue;
      }

      grouped[lineNumber]!.words.add(
        WordGlyphEntity(
          location: row[DbValueStrings.dbLocation] as String,
          surahNumber: _asRequiredInt(row['word_surah_number']),
          ayahNumber: _asRequiredInt(row[DbValueStrings.dbAyahNumber]),
          wordNumber: _asRequiredInt(row[DbValueStrings.dbWordNumber]),
          glyph: row[DbValueStrings.dbGlyph] as String,
          wholeWord: row[DbValueStrings.dbWholeWord] as String,
        ),
      );
    }

    final List<_LineAccumulator> orderedLines = grouped.values.toList()
      ..sort((a, b) => a.lineNumber.compareTo(b.lineNumber));

    return orderedLines
        .map(
          (line) => LayoutEntity(
        pageNumber: line.pageNumber,
        lineNumber: line.lineNumber,
        lineType: line.lineType,
        isCentered: line.isCentered,
        surahNumber: line.surahNumber,
        words: List<WordGlyphEntity>.unmodifiable(line.words),
      ),
    )
        .toList(growable: false);
  }

  static bool _asBool01(Object? value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is num) return value.toInt() == 1;
    if (value is String) {
      final String normalized = value.trim().toLowerCase();
      return normalized == '1' || normalized == 'true';
    }
    return false;
  }

  static int? _asNullableInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static int _asRequiredInt(Object? value) {
    final int? parsed = _asNullableInt(value);
    if (parsed == null) {
      throw StateError('Expected int value, but got: $value');
    }
    return parsed;
  }
}

class _LineAccumulator {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final List<WordGlyphEntity> words;

  _LineAccumulator({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
  }) : words = <WordGlyphEntity>[];
}