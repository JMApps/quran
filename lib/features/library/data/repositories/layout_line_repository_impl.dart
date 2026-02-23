import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/layout_line_entity.dart';
import '../../domain/repositories/layout_line_repository.dart';
import '../mappers/layout_mapper.dart';
import '../models/layout_line_model.dart';

class LayoutLineRepositoryImpl implements LayoutLineRepository {
  final QuranDatabaseService _quranDatabaseService;

  LayoutLineRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<LayoutLineEntity>> getLinesByPage({required int pageNumber}) async {
    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      'Table_of_layouts',
      where: 'page_number = ?',
      whereArgs: [pageNumber],
      orderBy: 'line_number ASC',
    );

    return rows.map((row) => LayoutLineModel.fromMap(row).toEntity()).toList();
  }
}
