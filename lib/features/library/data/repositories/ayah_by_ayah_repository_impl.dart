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
  Future<List<AyahByAyahEntity>> getAyahsByPage({
    required int pageNumber, required String tableName}) async {
    final db = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      WITH page_ayahs AS (
        SELECT DISTINCT
          w.surah AS surah_number,
          w.ayah AS ayah_number
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
        m.${DbValueStrings.dbAyahId} AS ayah_id,
        m.${DbValueStrings.dbVerseKey} AS verse_key,
        m.${DbValueStrings.dbSurahNumber} AS surah_number,
        m.${DbValueStrings.dbAyahNumber} AS ayah_number,
        m.${DbValueStrings.dbAyahArabic} AS ayah_arabic,
        t.${DbValueStrings.dbAyahTranslation} AS ayah_translation,
        NULL AS highlighted_arabic,
        NULL AS highlighted_translation
      FROM page_ayahs p
      JOIN ${DbValueStrings.tableOfAyahs} m
        ON m.${DbValueStrings.dbSurahNumber} = p.surah_number
       AND m.${DbValueStrings.dbAyahNumber} = p.ayah_number
      JOIN $tableName t
        ON t.${DbValueStrings.dbAyahId} = m.${DbValueStrings.dbAyahId}
      ORDER BY
        m.${DbValueStrings.dbSurahNumber} ASC,
        m.${DbValueStrings.dbAyahNumber} ASC
      ''',
      <Object>[pageNumber],
    );

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
  }

  @override
  Future<List<AyahByAyahEntity>> getSearchAyah({required String query, required String dataTable, required String ftsTable}) async {
    final db = await _quranDatabaseService.db;
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return const <AyahByAyahEntity>[];

    final bool isArabicQuery = _containsArabic(trimmedQuery);

    final String matchQuery = isArabicQuery ? _buildArabicMatchQuery(trimmedQuery) : _buildTextMatchQuery(trimmedQuery);

    if (matchQuery.isEmpty) return const <AyahByAyahEntity>[];
    final String sql = isArabicQuery
        ? '''
      SELECT
        m.${DbValueStrings.dbAyahId}                    AS ayah_id,
        m.${DbValueStrings.dbVerseKey}                   AS verse_key,
        m.${DbValueStrings.dbSurahNumber}                AS surah_number,
        m.${DbValueStrings.dbAyahNumber}                 AS ayah_number,
        m.${DbValueStrings.dbAyahArabicNormalized}       AS ayah_arabic,
        tr.${DbValueStrings.dbAyahTranslation}           AS ayah_translation,
        NULL AS highlighted_arabic,
        NULL AS highlighted_translation
      FROM ayahs_fts
      JOIN ${DbValueStrings.tableOfAyahs} m
        ON m.${DbValueStrings.dbAyahId} = ayahs_fts.rowid
      JOIN $dataTable tr
        ON tr.${DbValueStrings.dbAyahId} = m.${DbValueStrings.dbAyahId}
      WHERE ayahs_fts MATCH ?
      ORDER BY m.${DbValueStrings.dbSurahNumber} ASC, m.${DbValueStrings.dbAyahNumber} ASC
    '''
        : '''
      SELECT
        m.${DbValueStrings.dbAyahId}                    AS ayah_id,
        m.${DbValueStrings.dbVerseKey}                   AS verse_key,
        m.${DbValueStrings.dbSurahNumber}                AS surah_number,
        m.${DbValueStrings.dbAyahNumber}                 AS ayah_number,
        m.${DbValueStrings.dbAyahArabic}                 AS ayah_arabic,
        tr.${DbValueStrings.dbAyahTranslation}           AS ayah_translation,
        NULL AS highlighted_arabic,
        NULL AS highlighted_translation
      FROM $ftsTable
      JOIN $dataTable tr
        ON tr.${DbValueStrings.dbAyahId} = $ftsTable.rowid
      JOIN ${DbValueStrings.tableOfAyahs} m
        ON m.${DbValueStrings.dbAyahId} = tr.${DbValueStrings.dbAyahId}
      WHERE $ftsTable MATCH ?
      ORDER BY m.${DbValueStrings.dbSurahNumber} ASC, m.${DbValueStrings.dbAyahNumber} ASC
    ''';

    final List<Map<String, Object?>> result =
    await db.rawQuery(sql, <Object>[matchQuery]);

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
  }


  @override
  Future<List<AyahByAyahEntity>> getAyahsByIds({
    required String tableName,
    required List<int> ayahIds,
  }) async {
    if (ayahIds.isEmpty) return const [];

    final db = await _quranDatabaseService.db;
    final placeholders = List.filled(ayahIds.length, '?').join(',');

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
    SELECT
      a.${DbValueStrings.dbAyahId} AS ${DbValueStrings.dbAyahId},
      a.${DbValueStrings.dbVerseKey} AS ${DbValueStrings.dbVerseKey},
      a.${DbValueStrings.dbSurahNumber} AS ${DbValueStrings.dbSurahNumber},
      a.${DbValueStrings.dbAyahNumber} AS ${DbValueStrings.dbAyahNumber},
      a.${DbValueStrings.dbAyahArabic} AS ${DbValueStrings.dbAyahArabic},
      t.${DbValueStrings.dbAyahTranslation} AS ${DbValueStrings.dbAyahTranslation}
    FROM ${DbValueStrings.tableOfAyahs} a
    LEFT JOIN $tableName t
      ON t.${DbValueStrings.dbAyahId} = a.${DbValueStrings.dbAyahId}
    WHERE a.${DbValueStrings.dbAyahId} IN ($placeholders)
    ''',
      ayahIds,
    );

    final ayahs = result.map((json) => AyahByAyahModel.fromMap(json).toEntity()).toList(growable: false);

    final orderMap = <int, int>{
      for (int i = 0; i < ayahIds.length; i++) ayahIds[i]: i,
    };

    ayahs.sort((a, b) {
      final aIndex = orderMap[a.ayahId] ?? 1 << 30;
      final bIndex = orderMap[b.ayahId] ?? 1 << 30;
      return aIndex.compareTo(bIndex);
    });

    return List.unmodifiable(ayahs);
  }


  @override
  Future<AyahByAyahEntity> getAyahLocation({required int ayahId}) async {
    final db = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
    WITH page_ayahs AS (
      SELECT
        l.${DbValueStrings.dbPageNumber} AS page_number,
        w.surah AS surah_number,
        w.ayah AS ayah_number,
        MIN(w.id) AS first_word_id
      FROM ${DbValueStrings.tableOfLayouts} l
      JOIN ${DbValueStrings.tableOfWordsGlyph} w
        ON w.id BETWEEN
           CAST(l.${DbValueStrings.dbFirstWordId} AS INTEGER)
           AND
           CAST(l.${DbValueStrings.dbLastWordId} AS INTEGER)
      WHERE l.${DbValueStrings.dbLineType} = 'ayah'
        AND l.${DbValueStrings.dbFirstWordId} IS NOT NULL
        AND l.${DbValueStrings.dbLastWordId} IS NOT NULL
      GROUP BY
        l.${DbValueStrings.dbPageNumber},
        w.surah,
        w.ayah
    ),
    ranked_page_ayahs AS (
      SELECT
        page_number,
        surah_number,
        ayah_number,
        ROW_NUMBER() OVER (
          PARTITION BY page_number
          ORDER BY first_word_id ASC
        ) AS ayah_position_on_page,
        COUNT(*) OVER (
          PARTITION BY page_number
        ) AS ayahs_count_on_page
      FROM page_ayahs
    )
    SELECT
      a.${DbValueStrings.dbAyahId} AS ayah_id,
      a.${DbValueStrings.dbVerseKey} AS verse_key,
      a.${DbValueStrings.dbSurahNumber} AS surah_number,
      a.${DbValueStrings.dbAyahNumber} AS ayah_number,
      a.${DbValueStrings.dbAyahArabic} AS ayah_arabic,
      '' AS ayah_translation,
      NULL AS highlighted_arabic,
      NULL AS highlighted_translation,
      r.page_number AS page_number,
      r.ayah_position_on_page AS ayah_position_on_page,
      r.ayahs_count_on_page AS ayahs_count_on_page
    FROM ${DbValueStrings.tableOfAyahs} a
    JOIN ranked_page_ayahs r
      ON r.surah_number = a.${DbValueStrings.dbSurahNumber}
     AND r.ayah_number = a.${DbValueStrings.dbAyahNumber}
    WHERE a.${DbValueStrings.dbAyahId} = ?
    LIMIT 1
    ''',
      <Object>[ayahId],
    );

    return AyahByAyahModel.fromMap(result.first).toEntity();
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