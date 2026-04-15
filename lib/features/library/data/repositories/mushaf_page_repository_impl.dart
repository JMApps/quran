import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../data/mappers/mushaf_page_mapper.dart';
import '../../data/models/mushaf_page_model.dart';
import '../../domain/entities/mushaf_page_entity.dart';
import '../../domain/repositories/mushaf_page_repository.dart';

class MushafPageRepositoryImpl implements MushafPageRepository {
  final QuranDatabaseService _quranDatabaseService;

  const MushafPageRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<MushafPageEntity>> getMushafPageData({required int pageNumber}) async {
    final db = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
      SELECT
        l.${DbValueStrings.dbPageNumber},
        l.${DbValueStrings.dbLineNumber},
        l.${DbValueStrings.dbLineType},
        l.${DbValueStrings.dbIsCentered},
        l.${DbValueStrings.dbFirstWordId},
        l.${DbValueStrings.dbLastWordId},
        l.${DbValueStrings.dbSurahNumber},
        w.${DbValueStrings.dbLocation},
        w.${DbValueStrings.dbSurah},
        w.${DbValueStrings.dbAyah},
        w.${DbValueStrings.dbWord},
        w.${DbValueStrings.dbText},
        w.${DbValueStrings.dbCharType}
      FROM ${DbValueStrings.tableOfLayouts} l
      LEFT JOIN ${DbValueStrings.tableOfWordsGlyph} w
        ON w.${DbValueStrings.dbId} BETWEEN l.${DbValueStrings.dbFirstWordId} AND l.${DbValueStrings.dbLastWordId}
      WHERE l.${DbValueStrings.dbPageNumber} = ?
      ORDER BY
        l.${DbValueStrings.dbLineNumber} ${DbValueStrings.dbOrderASC},
        w.${DbValueStrings.dbWord} ${DbValueStrings.dbOrderASC}
      ''',
      [pageNumber],
    );

    return result.map((map) => MushafPageModel.fromMap(map).toEntity()).toList(growable: false);
  }
}