class JuzModel {
  final int juzNumber;
  final int versesCount;
  final String firstVerseKey;
  final String lastVerseKey;
  final String verseMapping;

  const JuzModel({
    required this.juzNumber,
    required this.versesCount,
    required this.firstVerseKey,
    required this.lastVerseKey,
    required this.verseMapping,
  });

  factory JuzModel.fromMap(Map<String, dynamic> map) {
    return JuzModel(
      juzNumber: int.parse(map['juz_number'].toString()),
      versesCount: int.parse(map['verses_count'].toString()),
      firstVerseKey: map['first_verse_key'] as String,
      lastVerseKey: map['last_verse_key'] as String,
      verseMapping: map['verse_mapping'] as String,
    );
  }
}