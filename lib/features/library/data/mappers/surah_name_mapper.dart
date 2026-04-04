import '../../domain/entities/surah_name_entity.dart';
import '../models/surah_name_model.dart';

extension SurahNameModelX on SurahNameModel {
  SurahNameEntity toEntity() => SurahNameEntity(
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
