import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/arguments/surah_detail_args.dart';
import '../../../domain/entities/juz_entity.dart';
import '../../state/surah_name_state.dart';

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
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    final surahState = Provider.of<SurahNameState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: juzModel.firstVerseKey);
    return InkWell(
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      onTap: () {
        final surahState = Provider.of<SurahNameState>(context, listen: false);
        final arguments = SurahDetailArgs(
          currentMushafPage: juzModel.startPageNumber,
        );
        surahState.setCurrentPage(juzModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
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
                juzModel.juzNumber.toString(),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    surahInfo,
                    style: AppStyles.mainTextStyle16,
                    maxLines: 1,
                  ),
                  Text(
                    '${juzModel.versesCount} ${AppStrings.plural(juzModel.versesCount, AppStrings.ayahOne, AppStrings.ayahFew, AppStrings.ayahMany)}',
                    style: AppStyles.mainTextStyle12,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Text(
              juzModel.startPageNumber.toString(),
              style: AppStyles.mainTextStyle12.copyWith(color: appColors.secondary),
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
