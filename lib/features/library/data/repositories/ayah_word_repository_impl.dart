import 'package:sqflite/sqflite.dart';

import '../../../../core/database/quran_database_service.dart';
import '../../domain/entities/ayah_word_entity.dart';
import '../../domain/repositories/ayah_word_repository.dart';
import '../mappers/ayah_word_mapper.dart';
import '../models/ayah_word_model.dart';

class AyahWordRepositoryImpl implements AyahWordRepository {
  static const _table = 'Table_of_words_glyph';

  final QuranDatabaseService _quranDatabaseService;

  AyahWordRepositoryImpl(this._quranDatabaseService);

  @override
  Future<List<AyahWordEntity>> getWordsByRange({
    required int fromId,
    required int toId,
  }) async {
    if (fromId <= 0 || toId <= 0) return const [];

    final start = fromId <= toId ? fromId : toId;
    final end = fromId <= toId ? toId : fromId;

    final Database database = await _quranDatabaseService.db;

    final List<Map<String, Object?>> rows = await database.query(
      _table,
      where: 'id BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'id ASC',
    );

    return rows.map((row) => AyahWordModel.fromMap(row).toEntity()).toList(growable: false);
  }
}