import '../../../../core/database/quran_database_service.dart';
import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';
import '../mappers/juz_mapper.dart';
import '../models/juz_model.dart';

class JuzRepositoryImpl implements JuzRepository {
  final QuranDatabaseService _quranDatabaseService;

  const JuzRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<JuzEntity>> getAllJuzs() async {
    final database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      DbValueStrings.tableOfJuzs,
      orderBy: '${DbValueStrings.dbJuzNumber} ${DbValueStrings.dbOrderASC}',
    );

    return rows.map((row) => JuzModel.fromMap(row).toEntity()).toList(growable: false);
  }
}
