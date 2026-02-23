class WordModel {
  final int id;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;

  const WordModel({
    required this.id,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as int,
      location: map['location'] as String,
      surah: map['surah'] as int,
      ayah: map['ayah'] as int,
      word: map['word'] as int,
      text: map['text'] as String,
    );
  }
}
