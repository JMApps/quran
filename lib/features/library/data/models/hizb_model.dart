import '../../../../core/strings/db_value_strings.dart';

class HizbModel {
  final int hizbNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final String verseMapping;
  final int startPageNumber;

  const HizbModel({
    required this.hizbNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.verseMapping,
    required this.startPageNumber,
  });

  factory HizbModel.fromMap(Map<String, dynamic> map) {
    return HizbModel(
      hizbNumber: map[DbValueStrings.dbHizbNumber] as int,
      versesCount: map[DbValueStrings.dbVersesCount] as int,
      firstVerseKey: map[DbValueStrings.dbFirstVerseKey] as String,
      lastVerseKey: map[DbValueStrings.dbLastVerseKey] as String,
      verseMapping: map[DbValueStrings.dbVerseMapping] as String,
      startPageNumber: map[DbValueStrings.dbStartNumberPage] as int,
    );
  }
}
