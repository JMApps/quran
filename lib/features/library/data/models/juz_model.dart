import '../../../../core/strings/db_value_strings.dart';

class JuzModel {
  final int juzNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final String verseMapping;
  final int startPageNumber;

  const JuzModel({
    required this.juzNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.verseMapping,
    required this.startPageNumber,
  });

  factory JuzModel.fromMap(Map<String, dynamic> map) {
    return JuzModel(
      juzNumber: map[DbValueStrings.dbJuzNumber] as int,
      versesCount: map[DbValueStrings.dbVersesCount] as int,
      firstVerseKey: map[DbValueStrings.dbFirstVerseKey] as String,
      lastVerseKey: map[DbValueStrings.dbLastVerseKey] as String,
      verseMapping: map[DbValueStrings.dbVerseMapping] as String,
      startPageNumber: map[DbValueStrings.dbStartNumberPage] as int,
    );
  }
}
