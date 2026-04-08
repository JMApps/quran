import 'package:flutter/material.dart';

import '../../../domain/entities/surah_name_entity.dart';
import '../items/surah_name_item.dart';

class SurahsNameList extends StatelessWidget {
  const SurahsNameList({
    super.key,
    required this.scrollController,
    required this.surahsList,
  });

  final ScrollController scrollController;
  final List<SurahNameEntity> surahsList;

  @override
  Widget build(BuildContext context) {
    final double bottomHeight = kBottomNavigationBarHeight + 14;
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        primary: false,
        controller: scrollController,
        padding: .only(bottom: bottomHeight),
        itemCount: surahsList.length,
        itemBuilder: (context, index) {
          final surahModel = surahsList[index];
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