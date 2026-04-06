class AyahByAyahModel {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahTranslation;

  const AyahByAyahModel({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
  });

  factory AyahByAyahModel.fromMap(Map<String, Object?> map) {
    return AyahByAyahModel(
      ayahId: (map['ayah_id'] as num).toInt(),
      verseKey: (map['verse_key'] as String?) ?? '',
      surahNumber: (map['surah_number'] as num).toInt(),
      ayahNumber: (map['ayah_number'] as num).toInt(),
      ayahArabic: (map['ayah_arabic'] as String?) ?? '',
      ayahTranslation: (map['ayah_translation'] as String?) ?? '',
    );
  }
}