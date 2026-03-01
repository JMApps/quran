import '../entities/surah_name_entity.dart';
import '../repositories/surah_name_repository.dart';

class SurahNameUseCase {
  final SurahNameRepository _surahRepository;

  const SurahNameUseCase(this._surahRepository);

  Future<List<SurahNameEntity>> getAllSurahs() {
    return _surahRepository.getAllSurahs();
  }
}
