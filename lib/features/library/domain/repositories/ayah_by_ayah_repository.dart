import '../entities/ayah_by_ayah_entity.dart';

abstract class AyahByAyahRepository {
  Future<List<AyahByAyahEntity>> getAyahsByPage({required int pageNumber, required String tableName});
  Future<List<AyahByAyahEntity>> getSearchAyah({required String query, required String dataTable, required String ftsTable});
  Future<List<AyahByAyahEntity>> getAyahsByIds({required String tableName, required List<int> ayahIds});
}