import '../../../../core/strings/db_value_strings.dart';

class WordGlyphModel {
  final String location;
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;
  final String glyph;
  final String wholeWord;

  const WordGlyphModel({
    required this.location,
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
    required this.glyph,
    required this.wholeWord,
  });

  factory WordGlyphModel.fromMap(Map<String, Object?> map) {
    return WordGlyphModel(
      location: map[DbValueStrings.dbLocation] as String,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      ayahNumber: map[DbValueStrings.dbAyahNumber] as int,
      wordNumber: map[DbValueStrings.dbWordNumber] as int,
      glyph: map[DbValueStrings.dbGlyph] as String,
      wholeWord: map[DbValueStrings.dbWholeWord] as String,
    );
  }
}