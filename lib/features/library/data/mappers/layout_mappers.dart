import '../../domain/entities/layout_entity.dart';
import '../models/layout_model.dart';

extension LayoutModelX on LayoutModel {
  LayoutEntity toEntity() => LayoutEntity(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    surahNumber: surahNumber,
    glyphs: glyphs,
  );
}
