import '../entities/mushaf_ayah_entity.dart';

abstract class MushafRepository {
  Future<MushafAyahEntity?> getAyah({required int surahNumber, required int ayahNumber});

  Future<List<MushafAyahEntity>> getAyahsBySurah({required int surahNumber});

  Future<List<MushafAyahEntity>> getAyahsByRange({required int fromAyahId, required int toAyahId});
}