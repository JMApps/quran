import 'package:equatable/equatable.dart';

import 'line_type.dart';
import 'word_glyph_entity.dart';

class LayoutEntity extends Equatable {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final List<WordGlyphEntity> glyphs;

  const LayoutEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.glyphs,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    lineNumber,
    lineType,
    isCentered,
    surahNumber,
    glyphs,
  ];
}