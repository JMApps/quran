import '../../domain/entities/hizb_entity.dart';
import '../models/hizb_model.dart';

extension HizbModelX on HizbModel {
  HizbEntity toEntity() => HizbEntity(
    hizbNumber: hizbNumber,
    versesCount: versesCount,
    firstVerseKey: firstVerseKey,
    lastVerseKey: lastVerseKey,
    verseMapping: verseMapping,
    startPageNumber: startPageNumber,
  );
}

extension HizbEntityX on HizbEntity {
  HizbModel toModel() => HizbModel(
    hizbNumber: hizbNumber,
    versesCount: versesCount,
    firstVerseKey: firstVerseKey,
    lastVerseKey: lastVerseKey,
    verseMapping: verseMapping,
    startPageNumber: startPageNumber,
  );
}
