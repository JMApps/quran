import '../entities/mushaf_page_meta_entity.dart';
import '../repositories/mushaf_page_meta_repository.dart';

class MushafPageMetaUseCase {
  final MushafPageMetaRepository _mushafPageMetaRepository;

  MushafPageMetaUseCase(this._mushafPageMetaRepository);

  Future<List<MushafPageMetaEntity>> getAllPagesMeta() {
    return _mushafPageMetaRepository.getAllPagesMeta();
  }
}