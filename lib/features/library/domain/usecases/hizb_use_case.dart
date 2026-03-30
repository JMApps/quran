import '../entities/hizb_entity.dart';
import '../repositories/hizb_repository.dart';

class HizbUseCase {
  final HizbRepository _hizbRepository;

  const HizbUseCase(this._hizbRepository);

  Future<List<HizbEntity>> getAllHizbs() {
    return _hizbRepository.getAllHizbs();
  }
}