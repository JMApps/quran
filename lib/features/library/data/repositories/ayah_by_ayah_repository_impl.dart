import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final QuranDatabaseService _quranDatabaseService;

  const AyahByAyahRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<AyahByAyahEntity>> getAyahsByPage({required int pageNumber, required String translationColumn}) async {
    final db = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
    WITH page_ayahs AS (
      SELECT DISTINCT
        w.surah AS ${DbValueStrings.dbSurahNumber},
        w.ayah  AS ${DbValueStrings.dbAyahNumber}
      FROM ${DbValueStrings.tableOfLayouts} l
      JOIN ${DbValueStrings.tableOfWordsGlyph} w
        ON w.id BETWEEN
           CAST(l.${DbValueStrings.dbFirstWordId} AS INTEGER)
           AND
           CAST(l.${DbValueStrings.dbLastWordId} AS INTEGER)
      WHERE l.${DbValueStrings.dbPageNumber} = ?
        AND l.${DbValueStrings.dbLineType} = 'ayah'
        AND l.${DbValueStrings.dbFirstWordId} IS NOT NULL
        AND l.${DbValueStrings.dbLastWordId} IS NOT NULL
    )
    SELECT
      m.${DbValueStrings.dbAyahId},
      m.${DbValueStrings.dbVerseKey},
      m.${DbValueStrings.dbSurahNumber},
      m.${DbValueStrings.dbAyahNumber},
      m.${DbValueStrings.dbAyahArabic},
      m.${DbValueStrings.dbAyahPageNumber},
      m.${DbValueStrings.dbAyahPosition},
      t.$translationColumn AS ${DbValueStrings.dbAyahTranslation}
    FROM page_ayahs p
    JOIN ${DbValueStrings.tableOfAyahs} m
      ON m.${DbValueStrings.dbSurahNumber} = p.${DbValueStrings.dbSurahNumber}
     AND m.${DbValueStrings.dbAyahNumber}  = p.${DbValueStrings.dbAyahNumber}
    JOIN ${DbValueStrings.tableOfTranslationsAyahsFts} t
      ON t.rowid = m.${DbValueStrings.dbAyahId}
    ORDER BY
      m.${DbValueStrings.dbSurahNumber} ${DbValueStrings.dbOrderASC},
      m.${DbValueStrings.dbAyahNumber}  ${DbValueStrings.dbOrderASC}
    ''',
      [pageNumber],
    );

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
  }

  @override
  Future<List<AyahByAyahEntity>> getSearchAyah({required String query, required String translationColumn}) async {
    final db = await _quranDatabaseService.db;
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return const [];

    final bool isArabicQuery = _containsArabic(trimmedQuery);
    final String matchQuery = isArabicQuery ? _buildArabicMatchQuery(trimmedQuery) : _buildTextMatchQuery(trimmedQuery);

    if (matchQuery.isEmpty) return const [];

    final String sql = isArabicQuery
        ? '''
        SELECT
          m.${DbValueStrings.dbAyahId},
          m.${DbValueStrings.dbVerseKey},
          m.${DbValueStrings.dbSurahNumber},
          m.${DbValueStrings.dbAyahNumber},
          m.${DbValueStrings.dbAyahArabic},
          m.${DbValueStrings.dbAyahPageNumber},
          m.${DbValueStrings.dbAyahPosition},
          t.$translationColumn AS ${DbValueStrings.dbAyahTranslation}
        FROM ayahs_fts
        JOIN ${DbValueStrings.tableOfAyahs} m
          ON m.${DbValueStrings.dbAyahId} = ayahs_fts.rowid
        JOIN ${DbValueStrings.tableOfTranslationsAyahsFts} t
          ON t.rowid = m.${DbValueStrings.dbAyahId}
        WHERE ayahs_fts MATCH ?
        ORDER BY m.${DbValueStrings.dbSurahNumber} ASC, m.${DbValueStrings.dbAyahNumber} ASC
      '''
        : '''
        SELECT
          m.${DbValueStrings.dbAyahId},
          m.${DbValueStrings.dbVerseKey},
          m.${DbValueStrings.dbSurahNumber},
          m.${DbValueStrings.dbAyahNumber},
          m.${DbValueStrings.dbAyahArabic},
          m.${DbValueStrings.dbAyahPageNumber},
          m.${DbValueStrings.dbAyahPosition},
          t.$translationColumn AS ${DbValueStrings.dbAyahTranslation}
        FROM ${DbValueStrings.tableOfTranslationsAyahsFts} t
        JOIN ${DbValueStrings.tableOfAyahs} m
          ON m.${DbValueStrings.dbAyahId} = t.rowid
        WHERE ${DbValueStrings.tableOfTranslationsAyahsFts} MATCH ?
        ORDER BY m.${DbValueStrings.dbSurahNumber} ASC, m.${DbValueStrings.dbAyahNumber} ASC
      ''';

    final String finalMatchQuery = isArabicQuery ? matchQuery : '$translationColumn:$matchQuery';

    final List<Map<String, Object?>> result =
    await db.rawQuery(sql, [finalMatchQuery]);

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
  }


  @override
  Future<List<AyahByAyahEntity>> getAyahsByIds({required List<int> ayahIds, required String translationColumn}) async {
    if (ayahIds.isEmpty) return const [];

    final db = await _quranDatabaseService.db;
    final placeholders = List.filled(ayahIds.length, '?').join(',');

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
    SELECT
      a.${DbValueStrings.dbAyahId},
      a.${DbValueStrings.dbVerseKey},
      a.${DbValueStrings.dbSurahNumber},
      a.${DbValueStrings.dbAyahNumber},
      a.${DbValueStrings.dbAyahArabic},
      a.${DbValueStrings.dbAyahPageNumber},
      a.${DbValueStrings.dbAyahPosition},
      t.$translationColumn AS ${DbValueStrings.dbAyahTranslation}
    FROM ${DbValueStrings.tableOfAyahs} a
    LEFT JOIN ${DbValueStrings.tableOfTranslationsAyahsFts} t
      ON t.rowid = a.${DbValueStrings.dbAyahId}
    WHERE a.${DbValueStrings.dbAyahId} IN ($placeholders)
    ''',
      ayahIds,
    );

    final ayahs = result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
    final orderMap = {for (int i = 0; i < ayahIds.length; i++) ayahIds[i]: i};
    return List.unmodifiable(ayahs..sort((a, b) => (orderMap[a.ayahId] ?? 1 << 30).compareTo(orderMap[b.ayahId] ?? 1 << 30)),
    );
  }

  bool _containsArabic(String value) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(value);
  }

  static String normalizeArabic(String value) {
    return value.replaceAll('\u0671', '\u0627').replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640\u06E1\u00A0]'), '');
  }

  String _escapeFtsPhrase(String value) {
    return value.replaceAll('"', '""');
  }

  String _buildArabicMatchQuery(String value) {
    final String cleaned = normalizeArabic(value).replaceAll("'", ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) return '';

    return '${_escapeFtsPhrase(cleaned)}*';
  }

  String _buildTextMatchQuery(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) return '';

    return '${_escapeFtsPhrase(cleaned)}*';
  }
}