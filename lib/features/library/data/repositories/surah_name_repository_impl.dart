import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';
import '../mappers/surah_name_mapper.dart';
import '../models/surah_name_model.dart';

class SurahNameRepositoryImpl implements SurahNameRepository {
  final QuranDatabaseService _quranDatabaseService;

  const SurahNameRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<SurahNameEntity>> getAllSurahs({required String languageCode}) async {
    final cols = DbValueStrings.surahNamesColum[languageCode] ?? DbValueStrings.surahNamesColum['ru']!;
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> allSurahs = await database.rawQuery('''
        SELECT
          ${DbValueStrings.dbSurahNumber},
          ${cols.transcription} AS ${DbValueStrings.dbNameTranscription},
          ${cols.translation} AS ${DbValueStrings.dbNameTranslation},
          ${DbValueStrings.dbRevelationOrder},
          ${DbValueStrings.dbRevelationPlace},
          ${DbValueStrings.dbAyahCount},
          ${DbValueStrings.dbBismillahPre},
          ${DbValueStrings.dbStartNumberPage}
        FROM ${DbValueStrings.tableOfSurahs}
        ORDER BY ${DbValueStrings.dbSurahNumber} ${DbValueStrings.dbOrderASC}
     ''');

    return allSurahs.map((row) => SurahNameModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
