import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/line_type.dart';
import '../../domain/entities/word_glyph_entity.dart';
import '../mappers/word_glyph_mapper.dart';
import 'word_glyph_model.dart';

class LayoutModel {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final List<WordGlyphEntity> glyphs;

  const LayoutModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.glyphs,
  });

  factory LayoutModel.fromRows(List<Map<String, Object?>> rows) {
    final first = rows.first;
    return LayoutModel(
      pageNumber: first['page_number'] as int,
      lineNumber: first['line_number'] as int,
      lineType: AppStrings.lineTypeFromDb(first['line_type'] as String),
      isCentered: (first['is_centered'] as int) == 1,
      surahNumber: first['layout_surah_number'] as int?,
      glyphs: rows.map((r) => WordGlyphModel.fromMap(r).toEntity()).toList(growable: false),
    );
  }
}