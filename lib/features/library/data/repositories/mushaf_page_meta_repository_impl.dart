import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../../../core/strings/app_strings.dart';
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
    final List<MushafPageMetaEntity> allPagesMeta = [];

    for (int pageNumber = 1; pageNumber <= AppStrings.totalPages; pageNumber++) {
      final result = await database.rawQuery(
        '''
      SELECT
        ? AS page_number,
        s.name_transcription,
        j.juz_number,
        h.hizb_number
      FROM
        (
          SELECT name_transcription
          FROM ${DbValueStrings.tableOfSurahs}
          WHERE start_page_number <= ?
          ORDER BY start_page_number DESC
          LIMIT 1
        ) s,
        (
          SELECT juz_number
          FROM ${DbValueStrings.tableOfJuzs}
          WHERE start_page_number <= ?
          ORDER BY start_page_number DESC
          LIMIT 1
        ) j
        LEFT JOIN
        (
          SELECT hizb_number
          FROM ${DbValueStrings.tableOfHizbs}
          WHERE start_page_number = ?
          LIMIT 1
        ) h
        ON 1 = 1
      ''',
        [
          pageNumber,
          pageNumber,
          pageNumber,
          pageNumber,
        ],
      );

      if (result.isEmpty) continue;

      final row = result.first;

      if (row['name_transcription'] == null || row['juz_number'] == null) {
        continue;
      }

      final model = MushafPageMetaModel.fromMap(row);
      allPagesMeta.add(model.toEntity());
    }

    return allPagesMeta;
  }
}
