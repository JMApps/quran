class SurahEntity {
  final int id;
  final String nameArabic;
  final String nameTranslation;
  final String nameTranscription;
  final int revelationOrder;
  final String revelationPlace;
  final int ayahsCount;
  final int basmallaPre;
  final int pageNumber;

  const SurahEntity({
    required this.id,
    required this.nameArabic,
    required this.nameTranslation,
    required this.nameTranscription,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.basmallaPre,
    required this.pageNumber,
  });

  bool get hasBasmallaPre => basmallaPre == 1;
}
