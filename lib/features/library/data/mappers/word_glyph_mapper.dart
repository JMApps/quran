import '../../domain/entities/word_glyph_entity.dart';
import '../models/word_glyph_model.dart';

extension WordGlyphX on WordGlyphModel {
  WordGlyphEntity toEntity() => WordGlyphEntity(
    location: location,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    wordNumber: wordNumber,
    glyph: glyph,
    wholeWord: wholeWord,
  );
}
