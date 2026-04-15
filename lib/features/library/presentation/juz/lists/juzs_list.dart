import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../domain/entities/juz_entity.dart';
import '../../state/surah_name_state.dart';
import '../items/juz_item.dart';
class JuzsList extends StatelessWidget {
  const JuzsList({
    super.key,
    required this.scrollController,
    required this.allJuzs,
  });

  final ScrollController scrollController;
  final List<JuzEntity> allJuzs;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 14;
    final SurahNameState surahNameState = context.read<SurahNameState>();
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        primary: false,
        controller: scrollController,
        padding: .only(bottom: bottomHeight),
        itemCount: allJuzs.length,
        itemBuilder: (context, index) {
          final JuzEntity juzModel = allJuzs[index];
          final String surahInfo = surahNameState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: juzModel.firstVerseKey);
          return JuzItem(
            juzModel: juzModel,
            index: index,
            surahInfo: surahInfo,
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 0.75),
      ),
    );
  }
}
