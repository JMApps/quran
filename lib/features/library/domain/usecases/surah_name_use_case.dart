import '../entities/surah_name_entity.dart';
import '../repositories/surah_name_repository.dart';

class SurahNameUseCase {
  final SurahNameRepository _surahNameRepository;

  const SurahNameUseCase(this._surahNameRepository);

  Future<List<SurahNameEntity>> getAllSurahs() {
    return _surahNameRepository.getAllSurahs();
  }

  Future<SurahNameEntity?> getSurahByPage({required int pageNumber}) {
    return _surahNameRepository.getSurahByPage(pageNumber: pageNumber);
  }
}