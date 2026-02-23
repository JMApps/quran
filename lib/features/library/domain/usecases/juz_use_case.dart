import '../entities/juz_entity.dart';
import '../repositories/juz_repository.dart';

class JuzUseCase {
  final JuzRepository _juzRepository;

  const JuzUseCase(this._juzRepository);

  Future<JuzEntity> getJuzInfo({required int pageNumber}) {
    return _juzRepository.getJuzInfo(pageNumber: pageNumber);
  }
}
