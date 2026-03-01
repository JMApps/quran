import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/repositories/layout_repository.dart';
import '../mappers/layout_mapper.dart';
import '../models/layout_model.dart';

class LayoutRepositoryImpl implements LayoutRepository {
  final QuranDatabaseService _quranDatabaseService;

  LayoutRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<LayoutEntity>> getLinesByPage({required int pageNumber}) async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_layouts',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC',
    );

    return rows.map((row) => LayoutModel.fromMap(row).toEntity()).toList();
  }
}
