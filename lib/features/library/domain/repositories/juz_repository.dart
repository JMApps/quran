import '../entities/juz_entity.dart';

abstract class JuzRepository {
  Future<List<JuzEntity>> getAllJuzs();
}