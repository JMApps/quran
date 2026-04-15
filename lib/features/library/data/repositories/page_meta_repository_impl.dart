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

    // 1. Три лёгких запроса по индексу start_page_number.
    final List<Map<String, Object?>> surahRows = await database.rawQuery(
      '''
      SELECT ${DbValueStrings.dbSurahNumber}, ${DbValueStrings.dbStartNumberPage}
      FROM ${DbValueStrings.tableOfSurahs}
      ORDER BY ${DbValueStrings.dbStartNumberPage} ${DbValueStrings.dbOrderASC}
      ''',
    );

    final List<Map<String, Object?>> juzRows = await database.rawQuery(
      '''
      SELECT ${DbValueStrings.dbJuzNumber}, ${DbValueStrings.dbStartNumberPage}
      FROM ${DbValueStrings.tableOfJuzs}
      ORDER BY ${DbValueStrings.dbStartNumberPage} ${DbValueStrings.dbOrderASC}
      ''',
    );

    final List<Map<String, Object?>> hizbRows = await database.rawQuery(
      '''
      SELECT ${DbValueStrings.dbHizbNumber}, ${DbValueStrings.dbStartNumberPage}
      FROM ${DbValueStrings.tableOfHizbs}
      ''',
    );

    final int totalPages = AppConstants.totalPagesCount;

    final List<int> surahPerPage = _expandRanges(
      rows: surahRows,
      numberKey: DbValueStrings.dbSurahNumber,
      startPageKey: DbValueStrings.dbStartNumberPage,
      totalPages: totalPages,
    );

    final List<int> juzPerPage = _expandRanges(
      rows: juzRows,
      numberKey: DbValueStrings.dbJuzNumber,
      startPageKey: DbValueStrings.dbStartNumberPage,
      totalPages: totalPages,
    );

    final Map<int, int> hizbByPage = {
      for (final row in hizbRows)
        row[DbValueStrings.dbStartNumberPage] as int:
        row[DbValueStrings.dbHizbNumber] as int,
    };

    // 3. Собираем метаданные по каждой странице.
    final List<PageMetaEntity> pagesMeta = List<PageMetaEntity>.generate(
      totalPages,
          (int i) {
        final int pageNumber = i + 1;
        final PageMetaModel model = PageMetaModel(
          pageNumber: pageNumber,
          surahNumber: surahPerPage[i],
          juzNumber: juzPerPage[i],
          hizbNumber: hizbByPage[pageNumber],
        );
        return model.toEntity();
      },
      growable: false,
    );

    return pagesMeta;
  }

  List<int> _expandRanges({required List<Map<String, Object?>> rows, required String numberKey, required String startPageKey, required int totalPages}) {
    final List<int> result = List<int>.filled(totalPages, 0);
    if (rows.isEmpty) return result;

    int currentNumber = rows.first[numberKey] as int;
    int rowIndex = 0;

    for (int page = 1; page <= totalPages; page++) {
      while (rowIndex + 1 < rows.length &&
          (rows[rowIndex + 1][startPageKey] as int) <= page) {
        rowIndex++;
        currentNumber = rows[rowIndex][numberKey] as int;
      }
      result[page - 1] = currentNumber;
    }

    return result;
  }
}