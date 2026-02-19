import '../../domain/entities/surah_entity.dart';
import '../models/surah_model.dart';

extension SurahModelX on SurahModel {
  SurahEntity toEntity() => SurahEntity(
    id: id,
    nameArabic: nameArabic,
    nameTranslation: nameTranslation,
    nameTranscription: nameTranscription,
    revelationOrder: revelationOrder,
    revelationPlace: revelationPlace,
    ayahsCount: ayahsCount,
    basmallaPre: basmallaPre,
    pageNumber: pageNumber,
  );
}

extension SurahEntityX on SurahEntity {
  SurahModel toModel() => SurahModel(
    id: id,
    nameArabic: nameArabic,
    nameTranslation: nameTranslation,
    nameTranscription: nameTranscription,
    revelationOrder: revelationOrder,
    revelationPlace: revelationPlace,
    ayahsCount: ayahsCount,
    basmallaPre: basmallaPre,
    pageNumber: pageNumber,
  );
}
