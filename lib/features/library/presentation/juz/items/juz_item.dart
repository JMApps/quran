import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
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
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);

    final surahState = context.read<SurahState>();
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: juzModel.firstVerseKey) ?? juzModel.firstVerseKey;

    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          juzModel.juzNumber.toString(),
        ),
      ),
      title: Text(
        surahInfo,
        style: AppStyles.mediumTextStyle16,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      subtitle: Text(
        '${juzModel.versesCount} ${AppStrings.plural(juzModel.versesCount, AppStrings.ayahOne, AppStrings.ayahFew, AppStrings.ayahMany)}',
        style: AppStyles.mainTextStyle12,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      trailing: Text(
        juzModel.startPageNumber.toString(),
      ),
      onTap: () {
        surahState.setMushafCurrentPage(juzModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
