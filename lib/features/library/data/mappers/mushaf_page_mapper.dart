import '../../domain/entities/mushaf_page_entity.dart';
import '../models/mushaf_page_model.dart';

extension MushafPageMapper on MushafPageModel {
  MushafPageEntity toEntity() {
    return MushafPageEntity(
      pageNumber: pageNumber,
      lineNumber: lineNumber,
      lineType: lineType,
      isCentered: isCentered,
      firstWordId: firstWordId,
      lastWordId: lastWordId,
      surahNumber: surahNumber,
      location: location,
      surah: surah,
      ayah: ayah,
      word: word,
      text: text,
      charType: charType,
    );
  }
}
