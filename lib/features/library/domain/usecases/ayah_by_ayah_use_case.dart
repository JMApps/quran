import '../entities/ayah_by_ayah_entity.dart';
import '../repositories/ayah_by_ayah_repository.dart';

class AyahByAyahUseCase {
  final AyahByAyahRepository _ayahByAyahRepository;

  const AyahByAyahUseCase(this._ayahByAyahRepository);

  Future<List<AyahByAyahEntity>> getAyahsByPage({required int pageNumber, required String tableName}) {
    return _ayahByAyahRepository.getAyahsByPage(pageNumber: pageNumber, tableName: tableName);
  }
}
