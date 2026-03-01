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
      hizbNumber: int.parse(map['hizb_number'].toString()),
      versesCount: int.parse(map['verses_count'].toString()),
      firstVerseKey: map['first_verse_key'] as String,
      lastVerseKey: map['last_verse_key'] as String,
      verseMapping: map['verse_mapping'] as String,
      startPageNumber: map['start_page_number'] as int,
    );
  }
}
