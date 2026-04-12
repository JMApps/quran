class SurahNameEntity {
  final int surahNumber;
  final String nameTranslation;
  final String nameTranscription;
  final int revelationOrder;
  final int revelationPlace;
  final int ayahsCount;
  final int basmallaPre;
  final int startPageNumber;

  const SurahNameEntity({
    required this.surahNumber,
    required this.nameTranslation,
    required this.nameTranscription,
    required this.revelationOrder,
    required this.revelationPlace,
    required this.ayahsCount,
    required this.basmallaPre,
    required this.startPageNumber,
  });
}
