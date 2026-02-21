import 'package:flutter/material.dart';

import '../../../domain/entities/surah_entity.dart';
import '../items/surah_item.dart';

class SurahList extends StatelessWidget {
  const SurahList({
    super.key,
    required this.surahsList,
  });

  final List<SurahEntity> surahsList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: surahsList.length,
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
