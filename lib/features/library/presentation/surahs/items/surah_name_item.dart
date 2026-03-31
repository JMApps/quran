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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: appSettingsState.arabicNameSurah,
                child: Text(
                  surahModel.nameArabic,
                  style: TextStyle(
                    color: appColors.primary,
                    fontFamily: AppStrings.fontUthmanicHafs,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    surahModel.nameTranscription,
                    style: const TextStyle(
                      fontFamily: AppStrings.fontGilroyMedium,
                    ),
                  ),
                  Visibility(
                    visible: appSettingsState.translationNameSurah,
                    child: Text(
                      ' (${surahModel.nameTranslation})',
                      style: const TextStyle(
                        fontFamily: AppStrings.fontGilroy,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      subtitle: Text(
        '${surahModel.ayahsCount} ${AppStrings.ayahWord(surahModel.ayahsCount)} – ${surahModel.revelationPlace}',
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      trailing: Text(
        surahModel.startPageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.mushafCurrentPage = surahModel.startPageNumber;
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
