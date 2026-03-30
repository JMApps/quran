import '../entities/ayah_by_ayah_entity.dart';

abstract class AyahByAyahRepository {
  Future<List<AyahByAyahEntity>> getAyahsByPage(int pageNumber);
}