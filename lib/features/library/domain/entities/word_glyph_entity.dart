class WordGlyphEntity {
  final int id;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;

  const WordGlyphEntity({
    required this.id,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
  });

  int get pageNumber => int.parse(location.split(':')[0]);
  int get lineNumber => int.parse(location.split(':')[1]);
  int get wordNumber => int.parse(location.split(':')[2]);
}