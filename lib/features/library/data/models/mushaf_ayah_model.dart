class MushafAyahModel {
  final int ayahId;
  final String verseKey;
  final int surahNumber;
  final int ayahNumber;
  final String ayahArabic;
  final String ayahKuliev;
  final String ayahAbuAdel;

  const MushafAyahModel({
    required this.ayahId,
    required this.verseKey,
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahKuliev,
    required this.ayahAbuAdel,
  });

  factory MushafAyahModel.fromMap(Map<String, Object?> map) {
    return MushafAyahModel(
      ayahId: map['ayah_id'] as int,
      verseKey: map['verse_key'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      ayahArabic: map['ayah_arabic'] as String,
      ayahKuliev: map['ayah_kuliev'] as String,
      ayahAbuAdel: map['ayah_abu_adel'] as String,
    );
  }
}