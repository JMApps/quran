import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/entities/ayah_list_row.dart';

class AyahListRowBuilder {
  const AyahListRowBuilder();

  List<AyahListRow> build(List<AyahByAyahEntity> ayahsPage) {
    if (ayahsPage.isEmpty) {
      return const [];
    }

    final List<AyahListRow> rows = <AyahListRow>[];
    int? previousSurahNumber;

    for (final ayah in ayahsPage) {
      final int currentSurahNumber = ayah.surahNumber;
      final bool isNewSurah = previousSurahNumber != currentSurahNumber;

      if (isNewSurah) {
        rows.add(AyahListRow.surahHeader(surahNumber: currentSurahNumber));

        if (_shouldShowBasmallah(ayah)) {
          rows.add(AyahListRow.basmallah(surahNumber: currentSurahNumber));
        }
      }

      rows.add(AyahListRow.ayah(ayah: ayah));
      previousSurahNumber = currentSurahNumber;
    }

    return rows;
  }

  bool _shouldShowBasmallah(AyahByAyahEntity ayah) {
    return ayah.ayahNumber == 1 && ayah.surahNumber != 1 && ayah.surahNumber != 9;
  }
}
