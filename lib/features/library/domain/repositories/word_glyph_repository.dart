import '../entities/word_glyph_entity.dart';

abstract class WordGlyphRepository {
  Future<List<WordGlyphEntity>> getWordsByPage({required int pageNumber});
}