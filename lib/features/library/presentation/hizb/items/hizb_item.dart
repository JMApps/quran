import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
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
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);

    final surahState = context.read<SurahState>();
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: hizbModel.firstVerseKey) ?? hizbModel.firstVerseKey;

    return ListTile(
      visualDensity: .adaptivePlatformDensity,
      tileColor: index.isOdd ? itemEvenColor : itemOddColor,
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Text(
          hizbModel.hizbNumber.toString(),
        ),
      ),
      title: Text(
        surahInfo,
        style: AppStyles.mediumTextStyle16,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      subtitle: Text(
        '${hizbModel.versesCount} ${AppStrings.plural(hizbModel.versesCount, 'аят', 'аята', 'аятов')}',
        style: AppStyles.mainTextStyle12,
        maxLines: 1,
        overflow: .ellipsis,
      ),
      trailing: Text(
        hizbModel.startPageNumber.toString(),
      ),
      onTap: () {
        surahState.setMushafCurrentPage(hizbModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
    );
  }
}
