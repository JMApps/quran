import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';
import '../mappers/ayah_by_ayah_mapper.dart';
import '../models/ayah_by_ayah_model.dart';

class AyahByAyahRepositoryImpl implements AyahByAyahRepository {
  final QuranDatabaseService _quranDatabaseService;

  AyahByAyahRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<AyahByAyahEntity>> getAyahsByPage({required int pageNumber, required String tableName}) async {
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
        m.${DbValueStrings.dbAyahId},
        m.${DbValueStrings.dbVerseKey},
        m.${DbValueStrings.dbSurahNumber},
        m.${DbValueStrings.dbAyahNumber},
        m.${DbValueStrings.dbAyahArabic},
        t.${DbValueStrings.dbAyahTranslation} AS ${DbValueStrings.dbAyahTranslation}
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
      [pageNumber],
    );

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
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

    final String dataTable = tableName;
    final String ftsTable = isArabicQuery
        ? 'ayahs_fts'
        : _getTranslationFtsTable(tableName);

    final String matchQuery = isArabicQuery
        ? _buildArabicMatchQuery(trimmedQuery)
        : _buildTextMatchQuery(trimmedQuery);

    if (matchQuery.isEmpty) {
      return const <AyahByAyahEntity>[];
    }

    final String sql = isArabicQuery
        ? '''
        SELECT
          m.ayah_id,
          m.verse_key,
          m.surah_number,
          m.ayah_number,
          m.ayah_arabic,
          tr.ayah_translation AS ayah_translation
        FROM $ftsTable f
        JOIN Table_of_ayahs m
          ON m.ayah_id = f.ayah_id
        JOIN $dataTable tr
          ON tr.ayah_id = m.ayah_id
        WHERE f.ayah_arabic_normalized MATCH ?
        ORDER BY
          m.surah_number ASC,
          m.ayah_number ASC
        '''
        : '''
        SELECT
          m.ayah_id,
          m.verse_key,
          m.surah_number,
          m.ayah_number,
          m.ayah_arabic,
          tr.ayah_translation AS ayah_translation
        FROM $ftsTable f
        JOIN Table_of_ayahs m
          ON m.ayah_id = f.ayah_id
        JOIN $dataTable tr
          ON tr.ayah_id = m.ayah_id
        WHERE f.text MATCH ?
        ORDER BY
          m.surah_number ASC,
          m.ayah_number ASC
        ''';

    final List<Map<String, Object?>> result = await db.rawQuery(sql, [matchQuery]);

    return result
        .map((map) => AyahByAyahModel.fromMap(map).toEntity())
        .toList(growable: false);
  }

  String _getTranslationFtsTable(String tableName) {
    switch (tableName) {
      case 'Table_of_translation_kuliev':
        return 'Translation_kuliev_fts';
      case 'Table_of_translation_adel':
        return 'Translation_adel_fts';
      default:
        throw ArgumentError('FTS table is not configured for $tableName');
    }
  }


  bool _containsArabic(String value) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(value);
  }

  String _buildArabicMatchQuery(String value) {
    final String cleaned = value.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    final List<String> tokens = cleaned.split(' ').where((e) => e.isNotEmpty).toList(growable: false);

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }

  String _buildTextMatchQuery(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    final List<String> tokens = cleaned.split(' ').where((e) => e.isNotEmpty).toList(growable: false);

    if (tokens.isEmpty) {
      return '';
    }

    return tokens.map((token) => '$token*').join(' ');
  }
}