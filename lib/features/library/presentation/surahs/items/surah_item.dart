import 'package:flutter/material.dart';

import '../../../../../core/router/names_router.dart';
import '../../../domain/entities/surah_entity.dart';

class SurahItem extends StatelessWidget {
  const SurahItem({
    super.key,
    required this.surahModel,
    required this.index,
  });

  final SurahEntity surahModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(15);
    final itemEvenColor = appColors.secondary.withAlpha(0);
    final isNightMode = Theme.brightnessOf(context) == Brightness.dark;
    return ListTile(
      visualDensity: VisualDensity.standard,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.primaryContainer,
      focusColor: appColors.primary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          surahModel.id.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: appColors.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(
        '${surahModel.nameTranscription} (${surahModel.nameTranslation})',
      ),
      subtitle: Text(
        '${surahModel.ayahsCount} аятов — ${surahModel.revelationPlace}',
      ),
      trailing: Text(
        surahModel.pageNumber.toString(),
        style: TextStyle(
          fontSize: 14.0,
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          NamesRouter.pageLayoutLine,
          arguments: surahModel.pageNumber,
        );
      },
    );
  }
}
