import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/repositories/mushaf_page_meta_repository.dart';
import '../mappers/mushaf_page_meta_mapper.dart';
import '../models/mushaf_page_meta_model.dart';

class MushafPageMetaRepositoryImpl implements MushafPageMetaRepository {
  final QuranDatabaseService _quranDatabaseService;

  const MushafPageMetaRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<MushafPageMetaEntity>> getAllPagesMeta() async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> result = await database.rawQuery(
      '''
      WITH RECURSIVE pages(${DbValueStrings.dbPageNumber}) AS (
        SELECT 1
        UNION ALL
        SELECT ${DbValueStrings.dbPageNumber} + 1
        FROM pages
        WHERE ${DbValueStrings.dbPageNumber} < ?
      )
      SELECT
        p.page_number,

        (
          SELECT s.${DbValueStrings.dbNameTranscription}
          FROM ${DbValueStrings.tableOfSurahs} s
          WHERE s.${DbValueStrings.dbStartNumberPage} <= p.${DbValueStrings.dbPageNumber}
          ORDER BY s.${DbValueStrings.dbStartNumberPage} ${DbValueStrings.dbOrderDESC}
          LIMIT 1
        ) AS ${DbValueStrings.dbNameTranscription},

        (
          SELECT j.${DbValueStrings.dbJuzNumber}
          FROM ${DbValueStrings.tableOfJuzs} j
          WHERE j.${DbValueStrings.dbStartNumberPage} <= p.${DbValueStrings.dbPageNumber}
          ORDER BY j.${DbValueStrings.dbStartNumberPage} ${DbValueStrings.dbOrderDESC}
          LIMIT 1
        ) AS ${DbValueStrings.dbJuzNumber},

        (
          SELECT h.${DbValueStrings.dbHizbNumber}
          FROM ${DbValueStrings.tableOfHizbs} h
          WHERE h.${DbValueStrings.dbStartNumberPage} = p.${DbValueStrings.dbPageNumber}
          LIMIT 1
        ) AS ${DbValueStrings.dbHizbNumber}

      FROM pages p
      ORDER BY p.${DbValueStrings.dbPageNumber} ${DbValueStrings.dbOrderASC}
      ''',
      [AppStrings.totalPages],
    );

    return result.where((row) => row[DbValueStrings.dbNameTranscription] != null && row[DbValueStrings.dbJuzNumber] != null,
    ).map((row) => MushafPageMetaModel.fromMap(row).toEntity()).toList();
  }
}