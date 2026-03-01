import '../entities/layout_entity.dart';
import '../repositories/layout_repository.dart';

class LayoutUseCase {
  final LayoutRepository _layoutLineRepository;

  const LayoutUseCase(this._layoutLineRepository);

  Future<List<LayoutEntity>> getLinesByPage({required int pageNumber}) {
    return _layoutLineRepository.getLinesByPage(pageNumber: pageNumber);
  }
}
