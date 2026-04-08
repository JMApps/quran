import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/data/mappers/ayah_list_row_builder.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/ayah_list_row_type.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../items/ayah_by_ayah_item.dart';
import '../items/basmallah_item.dart';
import '../items/surah_header_item.dart';

class AyahByAyahList extends StatelessWidget {
  const AyahByAyahList({
    super.key,
    required this.ayahsPage,
    required this.allSurahs,
  });

  final List<AyahByAyahEntity> ayahsPage;
  final List<SurahNameEntity> allSurahs;

  @override
  Widget build(BuildContext context) {
    final rows = const AyahListRowBuilder().build(ayahsPage);
    final surahNamesMap = <int, String>{
      for (final surah in allSurahs) surah.surahNumber: surah.nameTranscription,
    };
    return ListView.builder(
      padding: AppStyles.vrMainPadding,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];

        switch (row.type) {
          case AyahListRowType.surahHeader:
            return SurahHeaderItem(
              surahName: surahNamesMap[row.surahNumber] ?? '${AppStrings.surah} ${row.surahNumber}',
            );

          case AyahListRowType.basmallah:
            return const BasmallahItem();

          case AyahListRowType.ayah:
            return AyahByAyahItem(
              ayahByAyahModel: row.ayah!,
              index: index,
            );
        }
      },
    );
  }
}