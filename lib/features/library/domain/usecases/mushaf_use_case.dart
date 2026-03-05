import '../../data/repositories/mushaf_repository_impl.dart';
import '../../data/models/page_line_dto.dart';

class MushafPageUseCase {
  final MushafRepositoryImpl _mushafPageRepository;
  const MushafPageUseCase(this._mushafPageRepository);

  Future<List<PageLineDto>> getPageLines({required int pageNumber}) {
    return _mushafPageRepository.getPageLines(pageNumber);
  }
}