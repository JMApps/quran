import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/juz_entity.dart';
import '../../state/surah_state.dart';

class JuzItem extends StatelessWidget {
  const JuzItem({
    super.key,
    required this.juzModel,
    required this.index,
  });

  final JuzEntity juzModel;
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
        'Джуз – ${juzModel.juzNumber}',
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
              text: juzModel.firstVerseKey,
              style: TextStyle(
                color: appColors.primary,
              ),
            ),
            const TextSpan(text: ' / '),
            const TextSpan(text: 'Конец: '),
            TextSpan(
              text: juzModel.lastVerseKey,
              style: TextStyle(
                color: appColors.primary,
              ),
            ),
            const TextSpan(text: '\n'),
            TextSpan(
              text:
              '${juzModel.versesCount} ${AppStrings.ayahWord(juzModel.versesCount)}',
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
          juzModel.juzNumber.toString(),
          style: TextStyle(
            color: appColors.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
      ),
      trailing: Text(
        juzModel.startPageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        // Передаем в провайдер номер страницы
        Provider.of<SurahState>(context, listen: false).currentPageIndex = juzModel.startPageNumber;
        // Открываем страницу с нужными аргументами
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: juzModel.startPageNumber,
        );
      },
    );
  }
}
