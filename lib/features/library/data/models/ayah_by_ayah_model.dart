import '../../../../core/strings/db_value_strings.dart';

class AyahByAyahModel {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;

  const AyahByAyahModel({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
  });

  factory AyahByAyahModel.fromMap(Map<String, Object?> map) {
    return AyahByAyahModel(
      ayahId: map[DbValueStrings.dbAyahId] as int,
      verseKey: map[DbValueStrings.dbVerseKey] as String,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      ayahNumber: map[DbValueStrings.dbAyahNumber] as int,
      ayahArabic: map[DbValueStrings.dbAyahArabic] as String,
      ayahTranslation: map[DbValueStrings.dbAyahTranslation] as String,
    );
  }
}
