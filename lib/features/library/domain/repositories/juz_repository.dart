import '../entities/juz_entity.dart';

abstract class JuzRepository {
  Future<List<JuzEntity>> getAllJuzs();

  Future<JuzEntity?> getJuzByPage({required int pageNumber});
}