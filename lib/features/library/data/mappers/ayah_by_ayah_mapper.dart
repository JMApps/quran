import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../models/ayah_by_ayah_model.dart';

extension AyahByAyahModelX on AyahByAyahModel {
  AyahByAyahEntity toEntity() => AyahByAyahEntity(
    ayahId: ayahId,
    verseKey: verseKey,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    ayahArabic: ayahArabic,
  );
}

extension AyahByAyahEntityX on AyahByAyahEntity {
  AyahByAyahModel toModel() => AyahByAyahModel(
    ayahId: ayahId,
    verseKey: verseKey,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    ayahArabic: ayahArabic,
  );
}
