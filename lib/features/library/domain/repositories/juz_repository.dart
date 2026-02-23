import '../entities/juz_entity.dart';

abstract class JuzRepository {
  Future<JuzEntity> getJuzInfo({required int pageNumber});
}
