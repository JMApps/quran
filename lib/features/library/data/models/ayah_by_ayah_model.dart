import 'package:quran/core/strings/db_value_strings.dart';

class AyahByAyahModel {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;
  final int? pageNumber;
  final int? ayahPositionOnPage;
  final int? ayahsCountOnPage;


  const AyahByAyahModel({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.pageNumber,
    required this.ayahPositionOnPage,
    required this.ayahsCountOnPage,
  });

  factory AyahByAyahModel.fromMap(Map<String, Object?> map) {
    return AyahByAyahModel(
      ayahId: map[DbValueStrings.dbAyahId] as int,
      verseKey: map[DbValueStrings.dbVerseKey] as String,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      ayahNumber: map[DbValueStrings.dbAyahNumber] as int,
      ayahArabic: map[DbValueStrings.dbAyahArabic] as String,
      ayahTranslation: map[DbValueStrings.dbAyahTranslation] as String,
      pageNumber: map[DbValueStrings.dbPageNumber] as int?,
      ayahPositionOnPage: map['ayah_position_on_page'] as int?,
      ayahsCountOnPage: map['ayahs_count_on_page'] as int?,
    );
  }
}