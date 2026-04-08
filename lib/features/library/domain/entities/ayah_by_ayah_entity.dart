class AyahByAyahEntity {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;
  final int ayahPageNumber;
  final int ayahPosition;

  const AyahByAyahEntity({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.ayahPageNumber,
    required this.ayahPosition,
  });
}