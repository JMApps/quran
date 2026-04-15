import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/app_constants.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/page_meta_entity.dart';
import '../../domain/repositories/page_meta_repository.dart';
import '../mappers/page_meta_mapper.dart';
import '../models/page_meta_model.dart';

class PageMetaRepositoryImpl implements PageMetaRepository {
  final QuranDatabaseService _quranDatabaseService;

  const PageMetaRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<PageMetaEntity>> getAllPagesMeta() async {
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
      p.${DbValueStrings.dbPageNumber},

      (
        SELECT s.${DbValueStrings.dbSurahNumber}
        FROM ${DbValueStrings.tableOfSurahs} s
        WHERE s.${DbValueStrings.dbStartNumberPage} <= p.${DbValueStrings.dbPageNumber}
        ORDER BY s.${DbValueStrings.dbStartNumberPage} ${DbValueStrings.dbOrderDESC}
        LIMIT 1
      ) AS ${DbValueStrings.dbSurahNumber},

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
      [AppConstants.totalPagesCount],
    );

    return result.where((row) => row[DbValueStrings.dbSurahNumber] != null && row[DbValueStrings.dbJuzNumber] != null,).map((row) => PageMetaModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
