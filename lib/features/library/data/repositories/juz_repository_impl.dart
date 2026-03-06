import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';
import '../mappers/juz_mapper.dart';
import '../models/juz_model.dart';

class JuzRepositoryImpl implements JuzRepository {
  final QuranDatabaseService _quranDatabaseService;

  JuzRepositoryImpl(this._quranDatabaseService);

  static const String tableOfJuzs = 'Table_of_juzs';

  @override
  Future<List<JuzEntity>> getAllJuzs() async {
    final database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      tableOfJuzs,
      orderBy: 'juz_number ASC',
    );

    return rows.map((row) => JuzModel.fromMap(row).toEntity()).toList(growable: false);
  }

  @override
  Future<JuzEntity?> getJuzByPage({required int pageNumber}) async {
    final database = await _quranDatabaseService.db;

    final juzByPage = await database.query(
      tableOfJuzs,
      where: 'start_page_number <= ?',
      whereArgs: [pageNumber],
      orderBy: 'start_page_number DESC',
      limit: 1,
    );

    if (juzByPage.isEmpty) return null;

    return JuzModel.fromMap(juzByPage.first).toEntity();
  }
}
