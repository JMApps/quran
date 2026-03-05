import '../../domain/entities/mushaf_ayah_entity.dart';
import '../models/mushaf_ayah_model.dart';

extension MushafAyahModelX on MushafAyahModel {
  MushafAyahEntity toEntity() => MushafAyahEntity(
    ayahId: ayahId,
    verseKey: verseKey,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    ayahArabic: ayahArabic,
    ayahKuliev: ayahKuliev,
    ayahAbuAdel: ayahAbuAdel,
  );
}

extension MushafAyahEntityX on MushafAyahEntity {
  MushafAyahModel toModel() => MushafAyahModel(
    ayahId: ayahId,
    verseKey: verseKey,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    ayahArabic: ayahArabic,
    ayahKuliev: ayahKuliev,
    ayahAbuAdel: ayahAbuAdel,
  );
}
