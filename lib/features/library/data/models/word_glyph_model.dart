import '../../../../core/strings/db_value_strings.dart';

class WordGlyphModel {
  final String location;
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;
  final String glyph;

  const WordGlyphModel({
    required this.location,
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
    required this.glyph,
  });

  factory WordGlyphModel.fromMap(Map<String, Object?> map) => WordGlyphModel(
    location: map[DbValueStrings.dbLocation] as String,
    surahNumber: map[DbValueStrings.dbSurahNumber] as int,
    ayahNumber: map[DbValueStrings.dbAyahNumber] as int,
    wordNumber: map[DbValueStrings.dbWordNumber] as int,
    glyph: map[DbValueStrings.dbGlyph] as String,
  );
}