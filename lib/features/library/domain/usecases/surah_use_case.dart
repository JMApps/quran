import '../entities/surah_entity.dart';
import '../repositories/surah_repository.dart';

class SurahUseCase {
  final SurahRepository _surahRepository;

  const SurahUseCase(this._surahRepository);

  Future<List<SurahEntity>> getAllSurahs() {
    return _surahRepository.getAllSurahs();
  }
}
