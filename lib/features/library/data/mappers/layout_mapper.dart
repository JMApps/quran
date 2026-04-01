import '../../domain/entities/layout_entity.dart';
import '../models/layout_model.dart';

extension LayoutModelX on LayoutModel {
  LayoutEntity toEntity() => LayoutEntity(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    surahNumber: surahNumber,
    lineText: lineText,
    surahNameText: surahNameText,
  );
}

extension LayoutEntityX on LayoutEntity {
  LayoutModel toModel() => LayoutModel(
    pageNumber: pageNumber,
    lineNumber: lineNumber,
    lineType: lineType,
    isCentered: isCentered,
    surahNumber: surahNumber,
    lineText: lineText,
    surahNameText: surahNameText,
  );
}
