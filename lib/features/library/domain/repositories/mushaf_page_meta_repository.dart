import '../entities/mushaf_page_meta_entity.dart';

abstract class MushafPageMetaRepository {
  Future<List<MushafPageMetaEntity>> getAllPagesMeta();
}