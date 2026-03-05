import '../entities/mushaf_ayah_entity.dart';
import '../repositories/mushaf_repository.dart';

class MushafUseCase {
  final MushafRepository _mushafRepository;

  const MushafUseCase(this._mushafRepository);

  Future<MushafAyahEntity?> getAyah({required int surahNumber, required int ayahNumber}) {
    return _mushafRepository.getAyah(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  Future<List<MushafAyahEntity>> getAyahsBySurah({required int surahNumber}) {
    return _mushafRepository.getAyahsBySurah(surahNumber: surahNumber);
  }

  Future<List<MushafAyahEntity>> getAyahsByRange({required int fromAyahId, required int toAyahId}) {
    return _mushafRepository.getAyahsByRange(fromAyahId: fromAyahId, toAyahId: toAyahId);
  }
}