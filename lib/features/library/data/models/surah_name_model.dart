import '../../../../core/strings/db_value_strings.dart';

class SurahNameModel {
  final int surahNumber;
  final String nameArabic;
  final String nameTranslation;
  final String nameTranscription;
  final int revelationOrder;
  final String revelationPlace;
  final int ayahsCount;
  final int basmallaPre;
  final int startPageNumber;

  const SurahNameModel({
    required this.surahNumber,
    required this.nameArabic,
    required this.nameTranslation,
    required this.nameTranscription,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.basmallaPre,
    required this.startPageNumber,
  });

  factory SurahNameModel.fromMap(Map<String, Object?> map) {
    return SurahNameModel(
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      nameArabic: map[DbValueStrings.dbNameArabic] as String,
      nameTranslation: map[DbValueStrings.dbNameTranslation] as String,
      nameTranscription: map[DbValueStrings.dbNameTranscription] as String,
      revelationOrder: map[DbValueStrings.dbRevelationOrder] as int,
      revelationPlace: map[DbValueStrings.dbRevelationPlace] as String,
      ayahsCount: map[DbValueStrings.dbAyahCount] as int,
      basmallaPre: map[DbValueStrings.dbBismillahPre] as int,
      startPageNumber: map[DbValueStrings.dbStartNumberPage] as int,
    );
  }
}
