import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final QuranDatabaseService _quranDatabaseService;

  const AyahByAyahRepositoryImpl(this._quranDatabaseService);

  static const String _arabicHighlightStart = '[[AR_HL]]';
  static const String _arabicHighlightEnd = '[[/AR_HL]]';
  static const String _translationHighlightStart = '[[TR_HL]]';
  static const String _translationHighlightEnd = '[[/TR_HL]]';

  @override
  Future<List<AyahByAyahEntity>> getAyahsByPage({
    required int pageNumber,
    required String tableName,
  }) async {
    final db = await _quranDatabaseService.db;
    final tables = _resolveTranslationTables(tableName);

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
      JOIN ${tables.dataTable} t
        ON t.${DbValueStrings.dbAyahId} = m.${DbValueStrings.dbAyahId}
      ORDER BY
        m.${DbValueStrings.dbSurahNumber} ASC,
        m.${DbValueStrings.dbAyahNumber} ASC
      ''',
      <Object>[pageNumber],
    );

    return result
        .map((map) => AyahByAyahModel.fromMap(map).toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<AyahByAyahEntity>> getSearchAyah({
    required String query,
    required String tableName,
  }) async {
    final db = await _quranDatabaseService.db;
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return const <AyahByAyahEntity>[];
    }

    final bool isArabicQuery = _containsArabic(trimmedQuery);
    final _TranslationTables tables = _resolveTranslationTables(tableName);

    final String matchQuery = isArabicQuery
        ? _buildArabicMatchQuery(trimmedQuery)
        : _buildTextMatchQuery(trimmedQuery);

    if (matchQuery.isEmpty) {
      return const <AyahByAyahEntity>[];
    }

    final String sql = isArabicQuery
        ? '''
          SELECT
            m.${DbValueStrings.dbAyahId} AS ayah_id,
            m.${DbValueStrings.dbVerseKey} AS verse_key,
            m.${DbValueStrings.dbSurahNumber} AS surah_number,
            m.${DbValueStrings.dbAyahNumber} AS ayah_number,
            m.${DbValueStrings.dbAyahArabic} AS ayah_arabic,
            tr.${DbValueStrings.dbAyahTranslation} AS ayah_translation,
            highlight(
              ayahs_fts,
              0,
              '$_arabicHighlightStart',
              '$_arabicHighlightEnd'
            ) AS highlighted_arabic,
            NULL AS highlighted_translation
          FROM ayahs_fts
          JOIN ${DbValueStrings.tableOfAyahs} m
            ON m.${DbValueStrings.dbAyahId} = ayahs_fts.rowid
          JOIN ${tables.dataTable} tr
            ON tr.${DbValueStrings.dbAyahId} = m.${DbValueStrings.dbAyahId}
          WHERE ayahs_fts MATCH ?
          ORDER BY
            bm25(ayahs_fts),
            m.${DbValueStrings.dbSurahNumber} ASC,
            m.${DbValueStrings.dbAyahNumber} ASC
        '''
        : '''
          SELECT
            m.${DbValueStrings.dbAyahId} AS ayah_id,
            m.${DbValueStrings.dbVerseKey} AS verse_key,
            m.${DbValueStrings.dbSurahNumber} AS surah_number,
            m.${DbValueStrings.dbAyahNumber} AS ayah_number,
            m.${DbValueStrings.dbAyahArabic} AS ayah_arabic,
            tr.${DbValueStrings.dbAyahTranslation} AS ayah_translation,
            NULL AS highlighted_arabic,
            highlight(
              ${tables.ftsTable},
              0,
              '$_translationHighlightStart',
              '$_translationHighlightEnd'
            ) AS highlighted_translation
          FROM ${tables.ftsTable}
          JOIN ${tables.dataTable} tr
            ON tr.${DbValueStrings.dbAyahId} = ${tables.ftsTable}.rowid
          JOIN ${DbValueStrings.tableOfAyahs} m
            ON m.${DbValueStrings.dbAyahId} = tr.${DbValueStrings.dbAyahId}
          WHERE ${tables.ftsTable} MATCH ?
          ORDER BY
            bm25(${tables.ftsTable}),
            m.${DbValueStrings.dbSurahNumber} ASC,
            m.${DbValueStrings.dbAyahNumber} ASC
        ''';

    final List<Map<String, Object?>> result = await db.rawQuery(
      sql,
      <Object>[matchQuery],
    );

    return result
        .map((map) => AyahByAyahModel.fromMap(map).toEntity())
        .toList(growable: false);
  }

  _TranslationTables _resolveTranslationTables(String tableName) {
    switch (tableName) {
      case 'Table_of_translation_kuliev':
        return const _TranslationTables(
          dataTable: 'Table_of_translation_kuliev',
          ftsTable: 'translation_kuliev_fts',
        );
      case 'Table_of_translation_adel':
        return const _TranslationTables(
          dataTable: 'Table_of_translation_adel',
          ftsTable: 'translation_adel_fts',
        );
      default:
        throw ArgumentError('Unsupported translation table: $tableName');
    }
  }

  bool _containsArabic(String value) {
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]',
    ).hasMatch(value);
  }

  String _buildArabicMatchQuery(String value) {
    final String cleaned = value
        .replaceAll('\u00A0', ' ')
        .replaceAll('"', ' ')
        .replaceAll("'", ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final List<String> tokens = cleaned
        .split(' ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }

  String _buildTextMatchQuery(String value) {
    final String cleaned = value
        .replaceAll(
      RegExp(r'[^\p{L}\p{N}\s]', unicode: true),
      ' ',
    )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final List<String> tokens = cleaned
        .split(' ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }
}

class _TranslationTables {
  final String dataTable;
  final String ftsTable;

  const _TranslationTables({
    required this.dataTable,
    required this.ftsTable,
  });
}