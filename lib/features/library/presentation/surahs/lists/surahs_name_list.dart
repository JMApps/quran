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
    final double bottomHeight = kBottomNavigationBarHeight + 20;

    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        primary: false,
        itemCount: surahsList.length,
        padding: EdgeInsets.only(bottom: bottomHeight),
        separatorBuilder: (_, __) => const Divider(height: 0.75),
        itemBuilder: (context, index) {
          final surahModel = surahsList[index];
          return SurahNameItem(
            surahModel: surahModel,
            index: index,
          );
        },
      ),
    );
  }
}