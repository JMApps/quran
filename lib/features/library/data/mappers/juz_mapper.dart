import '../../domain/entities/juz_entity.dart';
import '../models/juz_model.dart';

extension JuzModelX on JuzModel {
  JuzEntity toEntity() => JuzEntity(
    juzNumber: juzNumber,
    versesCount: versesCount,
    firstVerseKey: firstVerseKey,
    lastVerseKey: lastVerseKey,
    verseMapping: verseMapping,
    startPageNumber: startPageNumber,
  );
}

extension JuzEntityX on JuzEntity {
  JuzModel toModel() => JuzModel(
    juzNumber: juzNumber,
    versesCount: versesCount,
    firstVerseKey: firstVerseKey,
    lastVerseKey: lastVerseKey,
    verseMapping: verseMapping,
    startPageNumber: startPageNumber,
  );
}
