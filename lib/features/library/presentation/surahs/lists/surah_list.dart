import 'package:flutter/material.dart';

import '../../../domain/entities/surah_entity.dart';
import '../items/surah_item.dart';

class SurahList extends StatelessWidget {
  const SurahList({
    super.key,
    required this.scrollController,
    required this.surahsList,
  });

  final ScrollController scrollController;
  final List<SurahEntity> surahsList;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 16;
    return ListView.separated(
      controller: scrollController,
      itemCount: surahsList.length,
      padding: EdgeInsets.only(bottom: bottomHeight),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final surahModel = surahsList[index];
        return SurahItem(
          surahModel: surahModel,
          index: index,
        );
      },
    );
  }
}
