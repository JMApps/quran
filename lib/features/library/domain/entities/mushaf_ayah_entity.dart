class MushafAyahEntity {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahKuliev;
  final String ayahAbuAdel;

  const MushafAyahEntity({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahKuliev,
    required this.ayahAbuAdel,
  });
}