import '../entities/ayah_by_ayah_entity.dart';

abstract class AyahByAyahRepository {
  Future<List<AyahByAyahEntity>> getAyahsByPage({
    required int pageNumber,
    required String translationColumn,
  });

  Future<List<AyahByAyahEntity>> getSearchAyah({
    required String query,
    required String translationColumn,
  });

  Future<List<AyahByAyahEntity>> getAyahsByIds({
    required List<int> ayahIds,
    required String translationColumn,
  });
}
