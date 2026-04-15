import '../entities/mushaf_page_entity.dart';

abstract interface class MushafPageRepository {
  Future<List<MushafPageEntity>> getMushafPageData({required int pageNumber});
}