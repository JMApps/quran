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
      juzNumber: map['juz_number'] as int,
      versesCount: map['verses_count'] as int,
      firstVerseKey: map['first_verse_key'] as String,
      lastVerseKey: map['last_verse_key'] as String,
      verseMapping: map['verse_mapping'] as String,
    );
  }
}