import 'package:flutter/material.dart';

import '../../../domain/entities/surah_name_entity.dart';
import '../items/surah_name_item.dart';
class SurahsNameList extends StatelessWidget {
  const SurahsNameList({
    super.key,
    required this.scrollController,
    required this.allSurahs,
  });

  final ScrollController scrollController;
  final List<SurahNameEntity> allSurahs;

  @override
  Widget build(BuildContext context) {
    final double bottomHeight = kBottomNavigationBarHeight + 7;
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        primary: false,
        controller: scrollController,
        padding: .only(bottom: bottomHeight),
        itemCount: allSurahs.length,
        itemBuilder: (context, index) {
          final surahModel = allSurahs[index];
          return SurahNameItem(
            surahModel: surahModel,
            index: index,
          );
        },
        separatorBuilder: (_, _) => const Divider(height: 0.75),
      ),
    );
  }
}