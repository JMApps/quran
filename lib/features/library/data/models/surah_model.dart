class SurahModel {
  final int id;
  final String nameArabic;
  final String nameTranslation;
  final String nameTranscription;
  final int revelationOrder;
  final String revelationPlace;
  final int ayahsCount;
  final int basmallaPre;
  final int pageNumber;

  const SurahModel({
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

  factory SurahModel.fromMap(Map<String, Object?> map) {
    return SurahModel(
      id: map['id'] as int,
      nameArabic: map['name_arabic'] as String,
      nameTranslation: map['name_translation'] as String,
      nameTranscription: map['name_transcription'] as String,
      revelationOrder: map['revelation_order'] as int,
      revelationPlace: map['revelation_place'] as String,
      ayahsCount: map['ayahs_count'] as int,
      basmallaPre: map['bismillah_pre'] as int,
      pageNumber: map['page_number'] as int,
    );
  }
}
