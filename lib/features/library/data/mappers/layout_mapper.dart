import '../../domain/entities/layout_line_entity.dart';
import '../models/layout_line_model.dart';

extension LayoutLineModelX on LayoutLineModel {
  LayoutLineEntity toEntity() => LayoutLineEntity(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    firstWordId: firstWordId,
    lastWordId: lastWordId,
    surahNumber: surahNumber,
  );
}

extension LayoutLineEntityX on LayoutLineEntity {
  LayoutLineModel toModel() => LayoutLineModel(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    firstWordId: firstWordId,
    lastWordId: lastWordId,
    surahNumber: surahNumber,
  );
}
