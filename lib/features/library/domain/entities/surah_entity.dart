class SurahEntity {
  final int surahNumber;
  final String nameArabic;
  final String nameTranslation;
  final String nameTranscription;
  final int revelationOrder;
  final String revelationPlace;
  final int ayahsCount;
  final int basmallaPre;
  final int startPageNumber;

  const SurahEntity({
    required this.surahNumber,
    required this.nameArabic,
    required this.nameTranslation,
    required this.nameTranscription,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.basmallaPre,
    required this.startPageNumber,
  });

  bool get hasBasmallaPre => basmallaPre == 1;
}
