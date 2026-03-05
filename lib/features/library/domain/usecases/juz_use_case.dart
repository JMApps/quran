import '../entities/juz_entity.dart';
import '../repositories/juz_repository.dart';

class JuzUseCase {
  final JuzRepository _juzRepository;

  const JuzUseCase(this._juzRepository);

  Future<List<JuzEntity>> getAllJuzs() {
    return _juzRepository.getAllJuzs();
  }

  Future<JuzEntity?> getJuzByPage({required int pageNumber}) {
    return _juzRepository.getJuzByPage(pageNumber: pageNumber);
  }
}