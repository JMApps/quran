import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/hizb_entity.dart';
import '../../domain/repositories/hizb_repository.dart';
import '../mappers/hizb_mapper.dart';
import '../models/hizb_model.dart';

class HizbRepositoryImpl implements HizbRepository {
  final QuranDatabaseService _quranDatabaseService;

  HizbRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<HizbEntity>> getAllHizbs() async {
    final database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_hizbs',
      orderBy: 'hizb_number ASC',
    );

    return rows.map((row) => HizbModel.fromMap(row).toEntity()).toList(growable: false);
  }

  @override
  Future<HizbEntity?> getHizbByPage({required int pageNumber}) async {
    final db = await _quranDatabaseService.db;

    final rows = await db.query(
      'Table_of_hizbs',
      where: 'start_page_number <= ?',
      whereArgs: [pageNumber],
      orderBy: 'start_page_number DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return HizbModel.fromMap(rows.first).toEntity();
  }
}