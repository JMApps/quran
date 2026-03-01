class AyahWordEntity {
  final int id;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;

  const AyahWordEntity({
    required this.id,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
  });
}
