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
      SELECT
        a.${DbValueStrings.dbAyahId},
        a.${DbValueStrings.dbVerseKey},
        a.${DbValueStrings.dbSurahNumber},
        a.${DbValueStrings.dbAyahNumber},
        a.${DbValueStrings.dbAyahArabic},
        a.${DbValueStrings.dbAyahPageNumber},
        a.${DbValueStrings.dbAyahPosition},
        COALESCE(t.$translationColumn, '') AS ${DbValueStrings.dbAyahTranslation}
      FROM ${DbValueStrings.tableOfAyahs} a
      LEFT JOIN ${DbValueStrings.tableOfTranslations} t
        ON t.${DbValueStrings.dbAyahId} = a.${DbValueStrings.dbAyahId}
      WHERE a.${DbValueStrings.dbAyahPageNumber} = ?
      ORDER BY a.${DbValueStrings.dbAyahPosition} ${DbValueStrings.dbOrderASC}
      ''',
      [pageNumber],
    );

    return result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);
  }

  @override
  Future<List<AyahByAyahEntity>> getSearchAyah({required String query, required String translationColumn}) async {
    final db = await _quranDatabaseService.db;
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return const [];

    final isArabicQuery = _containsArabic(trimmedQuery);
    final matchQuery = isArabicQuery ? _buildArabicMatchQuery(trimmedQuery) : _buildTextMatchQuery(translationColumn, trimmedQuery);

    if (matchQuery.isEmpty) return const [];

    final sql = isArabicQuery
        ? '''
          SELECT
            a.${DbValueStrings.dbAyahId},
            a.${DbValueStrings.dbVerseKey},
            a.${DbValueStrings.dbSurahNumber},
            a.${DbValueStrings.dbAyahNumber},
            a.${DbValueStrings.dbAyahArabic},
            a.${DbValueStrings.dbAyahPageNumber},
            a.${DbValueStrings.dbAyahPosition},
            COALESCE(t.$translationColumn, '') AS ${DbValueStrings.dbAyahTranslation}
          FROM (
            SELECT rowid
            FROM ${DbValueStrings.tableOfAyahsFts}
            WHERE ${DbValueStrings.tableOfAyahsFts} MATCH ?
          ) fts
          JOIN ${DbValueStrings.tableOfAyahs} a
            ON a.${DbValueStrings.dbAyahId} = fts.rowid
          LEFT JOIN ${DbValueStrings.tableOfTranslations} t
            ON t.${DbValueStrings.dbAyahId} = a.${DbValueStrings.dbAyahId}
          ORDER BY
            a.${DbValueStrings.dbSurahNumber} ${DbValueStrings.dbOrderASC},
            a.${DbValueStrings.dbAyahNumber}  ${DbValueStrings.dbOrderASC}
          LIMIT 100
        '''
        : '''
          SELECT
            a.${DbValueStrings.dbAyahId},
            a.${DbValueStrings.dbVerseKey},
            a.${DbValueStrings.dbSurahNumber},
            a.${DbValueStrings.dbAyahNumber},
            a.${DbValueStrings.dbAyahArabic},
            a.${DbValueStrings.dbAyahPageNumber},
            a.${DbValueStrings.dbAyahPosition},
            COALESCE(t.$translationColumn, '') AS ${DbValueStrings.dbAyahTranslation}
          FROM (
            SELECT rowid
            FROM ${DbValueStrings.tableOfTranslationsAyahsFts}
            WHERE ${DbValueStrings.tableOfTranslationsAyahsFts} MATCH ?
          ) fts
          JOIN ${DbValueStrings.tableOfAyahs} a
            ON a.${DbValueStrings.dbAyahId} = fts.rowid
          LEFT JOIN ${DbValueStrings.tableOfTranslations} t
            ON t.${DbValueStrings.dbAyahId} = a.${DbValueStrings.dbAyahId}
          ORDER BY
            a.${DbValueStrings.dbSurahNumber} ${DbValueStrings.dbOrderASC},
            a.${DbValueStrings.dbAyahNumber}  ${DbValueStrings.dbOrderASC}
          LIMIT 100
        ''';

    final result = await db.rawQuery(sql, [matchQuery]);
    return result
        .map((map) => AyahByAyahModel.fromMap(map).toEntity())
        .toList(growable: false);
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
        COALESCE(t.$translationColumn, '') AS ${DbValueStrings.dbAyahTranslation}
      FROM ${DbValueStrings.tableOfAyahs} a
      LEFT JOIN ${DbValueStrings.tableOfTranslations} t
        ON t.${DbValueStrings.dbAyahId} = a.${DbValueStrings.dbAyahId}
      WHERE a.${DbValueStrings.dbAyahId} IN ($placeholders)
      ''',
      ayahIds,
    );

    final ayahs = result.map((map) => AyahByAyahModel.fromMap(map).toEntity()).toList(growable: false);

    final orderMap = {
      for (int i = 0; i < ayahIds.length; i++) ayahIds[i]: i,
    };

    return List.unmodifiable(ayahs..sort((a, b) => (orderMap[a.ayahId] ?? 1 << 30).compareTo(orderMap[b.ayahId] ?? 1 << 30)));
  }

  bool _containsArabic(String value) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(value);
  }

  static String normalizeArabic(String value) {
    return value.replaceAll(RegExp(r'[\u0622\u0623\u0625\u0671]'), '\u0627').replaceAll(
      RegExp(
        r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640\u06E1\u00A0]',
      ), '',
    );
  }

  String _escapeFtsPhrase(String value) {
    return value.replaceAll('"', '""');
  }

  String _buildArabicMatchQuery(String value) {
    final String cleaned = normalizeArabic(value).replaceAll("'", ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleaned.isEmpty) return '';
    return cleaned.split(' ').map((token) => '${_escapeFtsPhrase(token)}*').join(' ');
  }

  String _buildTextMatchQuery(String translationColumn, String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (cleaned.isEmpty) return '';
    return cleaned.split(' ').map((token) => '$translationColumn:${_escapeFtsPhrase(token)}*').join(' ');
  }
}