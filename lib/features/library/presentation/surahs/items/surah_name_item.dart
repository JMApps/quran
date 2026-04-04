import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final itemOddColor = appColors.secondary.withAlpha(15);
    final itemEvenColor = appColors.secondary.withAlpha(0);

    return ListTile(
      visualDensity: VisualDensity.comfortable,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.primaryContainer,
      focusColor: appColors.primary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          surahModel.surahNumber.toString(),
        ),
      ),
      title: Consumer<AppSettingsState>(
        builder: (context, appSettingsState, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appSettingsState.arabicNameSurah)
                Text(
                  surahModel.nameArabic,
                  style: TextStyle(
                    color: appColors.primary,
                    fontFamily: AppStrings.fontUthmanicHafs,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Row(
                children: [
                  Text(
                    surahModel.nameTranscription,
                    style: const TextStyle(
                      fontFamily: AppStrings.fontGilroyMedium,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (appSettingsState.translationNameSurah)
                    Text(
                      ' (${surahModel.nameTranslation})',
                      style: const TextStyle(
                        fontFamily: AppStrings.fontGilroy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          );
        },
      ),
      subtitle: Text(
        '${surahModel.ayahsCount} ${AppStrings.ayahWord(surahModel.ayahsCount)} – ${surahModel.revelationPlace}',
        style: const TextStyle(fontSize: 12.0),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
