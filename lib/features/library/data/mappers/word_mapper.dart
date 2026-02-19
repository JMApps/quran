import '../../domain/entities/word_entity.dart';
import '../models/word_model.dart';

extension WordModelX on WordModel {
  WordEntity toEntity() => WordEntity(
    id: id,
    location: location,
    surah: surah,
    ayah: ayah,
    word: word,
    text: text,
  );
}

extension WordEntityX on WordEntity {
  WordModel toModel() => WordModel(
    id: id,
    location: location,
    surah: surah,
    ayah: ayah,
    word: word,
    text: text,
  );
}
