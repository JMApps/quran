import '../entities/page_meta_entity.dart';

abstract class PageMetaRepository {
  Future<List<PageMetaEntity>> getAllPagesMeta();
}