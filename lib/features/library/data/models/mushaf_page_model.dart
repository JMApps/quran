import '../../../../core/strings/db_value_strings.dart';
import '../../domain/entities/line_type.dart';

class MushafPageModel {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final int isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;
  final int charType;

  const MushafPageModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.firstWordId,
    required this.lastWordId,
    required this.surahNumber,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
    required this.charType,
  });

  factory MushafPageModel.fromMap(Map<String, dynamic> map) {
      LineType fromString(String value) {
        return switch (value) {
          'ayah' => LineType.ayah,
          'surah_name' => LineType.surahName,
          'basmallah' => LineType.basmallah,
          _ => throw ArgumentError('Unknown LineType: $value'),
        };
      }

    return MushafPageModel(
      pageNumber: map[DbValueStrings.dbPageNumber] as int,
      lineNumber: map[DbValueStrings.dbLineNumber] as int,
      lineType: fromString(map[DbValueStrings.dbLineType] as String),
      isCentered: map[DbValueStrings.dbIsCentered] as int,
      firstWordId: map[DbValueStrings.dbFirstWordId] as int?,
      lastWordId: map[DbValueStrings.dbLastWordId] as int?,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      location: map[DbValueStrings.dbLocation] as String,
      surah: map['surah'] as int,
      ayah: map[DbValueStrings.dbAyah] as int,
      word: map[DbValueStrings.dbWord] as int,
      text: map[DbValueStrings.dbText] as String,
      charType: map[DbValueStrings.dbCharType] as int,
    );
  }
}
