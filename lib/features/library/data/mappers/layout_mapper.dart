import '../../domain/entities/layout_entity.dart';
import '../../domain/entities/word_glyph_entity.dart';
import '../models/layout_model.dart';

extension LayoutModelX on LayoutModel {
  LayoutEntity toEntity({required List<WordGlyphEntity> words}) {
    return LayoutEntity(
      pageNumber: pageNumber,
      lineNumber: lineNumber,
      lineType: lineType,
      isCentered: isCentered,
      surahNumber: surahNumber,
      words: words,
    );
  }
}