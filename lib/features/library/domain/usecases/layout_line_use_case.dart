import '../entities/layout_line_entity.dart';
import '../repositories/layout_line_repository.dart';

class LayoutLineUseCase {
  final LayoutLineRepository _layoutLineRepository;

  const LayoutLineUseCase(this._layoutLineRepository);

  Future<List<LayoutLineEntity>> getLinesByPage({required int pageNumber}) {
    return _layoutLineRepository.getLinesByPage(pageNumber: pageNumber);
  }
}
