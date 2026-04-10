import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/repositories/layout_repository.dart';
import '../mappers/layout_mapper.dart';
import '../models/layout_model.dart';

class LayoutRepositoryImpl implements LayoutRepository {
  final QuranDatabaseService _dbService;

  const LayoutRepositoryImpl(this._dbService);

  @override
  Future<List<LayoutEntity>> getLinesByPage({required int pageNumber}) async {
    final db = await _dbService.db;

    final rows = await db.query(
      DbValueStrings.tableOfLayouts,
      columns: const [
        DbValueStrings.dbPageNumber,
        DbValueStrings.dbLineNumber,
        DbValueStrings.dbLineType,
        DbValueStrings.dbIsCentered,
        DbValueStrings.dbFirstWordId,
        DbValueStrings.dbLastWordId,
        DbValueStrings.dbSurahNumber,
      ],
      where: '${DbValueStrings.dbPageNumber} = ?',
      whereArgs: [pageNumber],
      orderBy: '${DbValueStrings.dbLineNumber} ${DbValueStrings.dbOrderASC}',
    );

    return rows.map((row) => LayoutModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
