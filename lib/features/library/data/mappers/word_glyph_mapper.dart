import '../../domain/entities/word_glyph_entity.dart';
import '../models/word_glyph_model.dart';

extension WordGlyphModelX on WordGlyphModel {
  WordGlyphEntity toEntity() => WordGlyphEntity(
    id: id,
    location: location,
    surah: surah,
    ayah: ayah,
    word: word,
    text: text,
  );
}
