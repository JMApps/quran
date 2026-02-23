import '../../domain/entities/surah_entity.dart';
import '../models/surah_model.dart';

extension SurahModelX on SurahModel {
  SurahEntity toEntity() => SurahEntity(
    surahNumber: surahNumber,
    nameArabic: nameArabic,
    nameTranslation: nameTranslation,
    nameTranscription: nameTranscription,
    revelationOrder: revelationOrder,
    revelationPlace: revelationPlace,
    ayahsCount: ayahsCount,
    basmallaPre: basmallaPre,
    startPageNumber: startPageNumber,
  );
}

extension SurahEntityX on SurahEntity {
  SurahModel toModel() => SurahModel(
    surahNumber: surahNumber,
    nameArabic: nameArabic,
    nameTranslation: nameTranslation,
    nameTranscription: nameTranscription,
    revelationOrder: revelationOrder,
    revelationPlace: revelationPlace,
    ayahsCount: ayahsCount,
    basmallaPre: basmallaPre,
    startPageNumber: startPageNumber,
  );
}
