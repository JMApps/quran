import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../state/surah_state.dart';

class HizbItem extends StatelessWidget {
  const HizbItem({
    super.key,
    required this.hizbModel,
    required this.index,
  });

  final HizbEntity hizbModel;
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
      title: Text(
        'Хизб – ${hizbModel.hizbNumber}',
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            color: appColors.onSurface,
            fontFamily: AppStrings.fontGilroy,
          ),
          children: [
            const TextSpan(text: 'Начало: '),
            TextSpan(
              text: hizbModel.firstVerseKey,
              style: TextStyle(
                color: appColors.primary,
              ),
            ),
            const TextSpan(text: ' / '),
            const TextSpan(text: 'Конец: '),
            TextSpan(
              text: hizbModel.lastVerseKey,
              style: TextStyle(
                color: appColors.primary,
              ),
            ),
            const TextSpan(text: '\n'),
            TextSpan(
              text:
              '${hizbModel.versesCount} ${AppStrings.ayahWord(hizbModel.versesCount)}',
              style: TextStyle(
                color: appColors.secondary,
              ),
            ),
          ],
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          hizbModel.hizbNumber.toString(),
          style: TextStyle(
            color: appColors.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      trailing: Text(
        hizbModel.startPageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        // Передаем в провайдер номер страницы
        Provider.of<SurahState>(context, listen: false).currentPageIndex = hizbModel.startPageNumber;
        // Открываем страницу с нужными аргументами
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: hizbModel.startPageNumber,
        );
      },
    );
  }
}
