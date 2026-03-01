import '../../domain/entities/ayah_word_entity.dart';
import '../models/ayah_word_model.dart';

extension AyahWordModelX on AyahWordModel {
  AyahWordEntity toEntity() => AyahWordEntity(
    id: id,
    location: location,
    surah: surah,
    ayah: ayah,
    word: word,
    text: text,
  );
}

extension AyahWordEntityX on AyahWordEntity {
  AyahWordModel toModel() => AyahWordModel(
    id: id,
    location: location,
    surah: surah,
    ayah: ayah,
    word: word,
    text: text,
  );
}
