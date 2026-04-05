import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../settings/state/app_settings_state.dart';
import '../../../domain/entities/surah_name_entity.dart';
import '../../state/surah_state.dart';

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
    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          surahModel.surahNumber.toString(),
        ),
      ),
      title: Consumer<AppSettingsState>(
        builder: (context, appSettingsState, _) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              if (appSettingsState.arabicNameSurah)
                Text(
                  surahModel.nameArabic,
                  style: TextStyle(
                    color: appColors.primary,
                    fontFamily: AppStrings.fontUthmanicHafs,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      surahModel.nameTranscription,
                      style: AppStyles.mediumTextStyle16,
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                  ),
                  if (appSettingsState.translationNameSurah)
                    Flexible(
                      child: Text(
                        ' (${surahModel.nameTranslation})',
                        style: AppStyles.mainTextStyle16,
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
      subtitle: Text(
        '${surahModel.ayahsCount} ${AppStrings.plural(surahModel.ayahsCount, AppStrings.ayahOne, AppStrings.ayahFew, AppStrings.ayahMany)} – ${surahModel.revelationPlace}',
        style: AppStyles.mainTextStyle12,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      trailing: Text(
        surahModel.startPageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.setMushafCurrentPage(surahModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
