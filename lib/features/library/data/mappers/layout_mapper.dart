import '../../domain/entities/layout_entity.dart';
import '../models/layout_model.dart';

extension LayoutModelX on LayoutModel {
  LayoutEntity toEntity() => LayoutEntity(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    firstWordId: firstWordId,
    lastWordId: lastWordId,
    surahNumber: surahNumber,
  );
}

extension LayoutEntityX on LayoutEntity {
  LayoutModel toModel() => LayoutModel(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    firstWordId: firstWordId,
    lastWordId: lastWordId,
    surahNumber: surahNumber,
  );
}
