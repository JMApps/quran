import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/arguments/surah_detail_args.dart';
import '../../../domain/entities/surah_name_entity.dart';
import '../../state/surah_name_state.dart';

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
        final surahState = Provider.of<SurahNameState>(context, listen: false);
        final arguments = SurahDetailArgs(
          currentMushafPage: surahModel.startPageNumber,
        );
        surahState.setCurrentPage(surahModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
        );
      },
      child: Container(
        padding: AppStyles.hrMiniVrMainPadding,
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
                  Row(
                    children: [
                      Text(
                        surahModel.nameTranscription,
                        style: AppStyles.mediumTextStyle16,
                        maxLines: 1,
                      ),
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
