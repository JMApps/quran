import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/repositories/word_glyph_repository.dart';
import '../mappers/layout_mappers.dart';
import '../models/layout_model.dart';

class WordGlyphRepositoryImpl implements WordGlyphRepository {
  final QuranDatabaseService _quranDatabaseService;

  const WordGlyphRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<LayoutEntity>> getPageLines({required int pageNumber}) async {
    final Database database = await _quranDatabaseService.db;
    final rows = await database.rawQuery('''
        SELECT
          l.${DbValueStrings.dbPageNumber},
          l.${DbValueStrings.dbLineNumber},
          l.${DbValueStrings.dbLineType},
          l.${DbValueStrings.dbIsCentered},
          l.${DbValueStrings.dbSurahNumber} AS layout_surah_number, g.${DbValueStrings.dbSurahNumber},
          g.${DbValueStrings.dbLocation},
          g.${DbValueStrings.dbAyahNumber},
          g.${DbValueStrings.dbWordNumber},
          g.${DbValueStrings.dbGlyph}
        FROM ${DbValueStrings.tableOfLayouts} l
        JOIN ${DbValueStrings.tableOfGlyphsWords} g
          ON g.${DbValueStrings.dbId} BETWEEN l.${DbValueStrings.dbFirstWordId} AND l.${DbValueStrings.dbLastWordId}
        WHERE l.${DbValueStrings.dbPageNumber} = ?
        ORDER BY l.${DbValueStrings.dbLineNumber}, g.${DbValueStrings.dbId}
      ''', [pageNumber]);

    final grouped = <int, List<Map<String, Object?>>>{};
    for (final row in rows) {
      (grouped[row[DbValueStrings.dbLineNumber] as int] ??= []).add(row);
    }

    return grouped.values.map((lineRows) => LayoutModel.fromRows(lineRows).toEntity()).toList(growable: false);
  }
}