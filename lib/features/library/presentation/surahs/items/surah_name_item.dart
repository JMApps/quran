import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../settings/state/app_settings_state.dart';
import '../../../domain/entities/surah_name_entity.dart';
import '../../state/main_state.dart';

class SurahNameItem extends StatelessWidget {
  const SurahNameItem({
    super.key,
    required this.surahModel,
    required this.index,
  });

  final SurahNameEntity surahModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    return InkWell(
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      onTap: () {
        final mainState = context.read<MainState>();
        mainState.onMainPageChanged(surahModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail
        );
      },
      child: Container(
        padding: AppStyles.hrMiniVrBigPadding,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text(
                surahModel.surahNumber.toString(),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  if (context.watch<AppSettingsState>().arabicNameSurah)
                    Text(
                      AppStrings.surahNameByNumber(surahModel.surahNumber),
                      style: TextStyle(
                        color: appColors.primary,
                        fontFamily: AppStrings.fontSurahName,
                        fontSize: 27.5,
                        height: 1,
                      ),
                    ),
                  Row(
                    children: [
                      Text(
                        surahModel.nameTranscription,
                        style: AppStyles.mediumTextStyle16,
                        maxLines: 1,
                      ),
                      if (context.watch<AppSettingsState>().translationNameSurah)
                        Text(
                          ' (${surahModel.nameTranslation})',
                          style: AppStyles.mainTextStyle16,
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                    ],
                  ),
                  Text(
                    '${surahModel.ayahsCount} ${AppStrings.plural(surahModel.ayahsCount, AppStrings.ayahOne, AppStrings.ayahFew, AppStrings.ayahMany)} – ${surahModel.revelationPlace == 0 ? AppStrings.mecca : AppStrings.medina}',
                    style: AppStyles.mainTextStyle12,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Text(
              surahModel.startPageNumber.toString(),
              style: AppStyles.mainTextStyle12.copyWith(color: appColors.secondary),
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
