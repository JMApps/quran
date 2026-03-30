import '../entities/ayah_by_ayah_entity.dart';
import '../repositories/ayah_by_ayah_repository.dart';

class AyahByAyahUseCase {
  final AyahByAyahRepository _ayahByAyahRepository;

  const AyahByAyahUseCase(this._ayahByAyahRepository);

  Future<List<AyahByAyahEntity>> getAyahsByPage(int pageNumber) {
    return _ayahByAyahRepository.getAyahsByPage(pageNumber);
  }
}
