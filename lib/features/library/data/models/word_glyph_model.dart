import '../../../../core/strings/db_value_strings.dart';

class WordGlyphModel {
  final int id;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;

  const WordGlyphModel({
    required this.id,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
  });

  factory WordGlyphModel.fromMap(Map<String, dynamic> map) {
    return WordGlyphModel(
      id: map[DbValueStrings.dbId] as int,
      location: map[DbValueStrings.dbLocation] as String,
      surah: map[DbValueStrings.dbSurah] as int,
      ayah: map[DbValueStrings.dbAyah] as int,
      word: map[DbValueStrings.dbWord] as int,
      text: map[DbValueStrings.dbText] as String,
    );
  }
}