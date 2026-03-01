import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../state/surah_state.dart';

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
    return ListTile(
      visualDensity: VisualDensity.standard,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.primaryContainer,
      focusColor: appColors.primary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          surahModel.surahNumber.toString(),
          style: TextStyle(
            color: appColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            surahModel.nameArabic,
            style: TextStyle(
              color: appColors.primary,
              fontFamily: AppStrings.fontUthmanicHafs,
            ),
          ),
          Text(
            '${surahModel.nameTranscription} (${surahModel.nameTranslation})',
          ),
        ],
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            color: appColors.onSurface,
            fontFamily: AppStrings.fontGilroy,
          ),
          children: [
            TextSpan(
              text: '${surahModel.ayahsCount} ${AppStrings.ayahWord(surahModel.ayahsCount)}',
              style: TextStyle(
                color: appColors.secondary,
              ),
            ),
            const TextSpan(text: ' – '),
            TextSpan(
              text: surahModel.revelationPlace,
              style: TextStyle(
                color: appColors.primary,
              ),
            ),
          ],
        ),
      ),
      trailing: Text(
        surahModel.startPageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        // Передаем в провайдер номер страницы
        Provider.of<SurahState>(context, listen: false).currentPageNumber = surahModel.startPageNumber;
        // Открываем страницу с нужными аргументами
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahModel.startPageNumber,
        );
      },
    );
  }
}
