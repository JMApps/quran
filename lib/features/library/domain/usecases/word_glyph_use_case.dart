import '../entities/word_glyph_entity.dart';
import '../repositories/word_glyph_repository.dart';

class WordGlyphUseCase {

  final WordGlyphRepository _wordGlyphRepository;

  WordGlyphUseCase(this._wordGlyphRepository);

  Future<List<WordGlyphEntity>> getWordsByPage({required int pageNumber}) {
    return _wordGlyphRepository.getWordsByPage(pageNumber: pageNumber);
  }
}