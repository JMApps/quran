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
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      location: map['location'] as String,
      surah: map['surah'] is int ? map['surah'] : int.parse(map['surah'].toString()),
      ayah: map['ayah'] is int ? map['ayah'] : int.parse(map['ayah'].toString()),
      word: map['word'] is int ? map['word'] : int.parse(map['word'].toString()),
      text: map['text'] as String,
    );
  }
}
