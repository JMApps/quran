class AyahByAyahEntity {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;
  final int? pageNumber;
  final int? ayahPositionOnPage;
  final int? ayahsCountOnPage;

  const AyahByAyahEntity({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.pageNumber,
    required this.ayahPositionOnPage,
    required this.ayahsCountOnPage,
  });
}