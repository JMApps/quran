import '../entities/layout_entity.dart';

abstract interface class WordGlyphRepository {
  Future<List<LayoutEntity>> getMushafPageData({required int pageNumber});
}