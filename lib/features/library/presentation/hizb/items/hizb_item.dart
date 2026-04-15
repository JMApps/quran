import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../data/arguments/surah_detail_args.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../state/main_state.dart';

class HizbItem extends StatelessWidget {
  const HizbItem({
    super.key,
    required this.hizbModel,
    required this.index,
    required this.surahInfo,
  });

  final HizbEntity hizbModel;
  final int index;
  final String surahInfo;

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
        mainState.setCurrentPage(hizbModel.startPageNumber);
        final arguments = SurahDetailArgs(
          currentMushafPage: hizbModel.startPageNumber,
        );
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
                hizbModel.hizbNumber.toString(),
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
                    '${hizbModel.versesCount} ${AppStrings.plural(hizbModel.versesCount, AppStrings.ayahOne, AppStrings.ayahFew, AppStrings.ayahMany)}',
                    style: AppStyles.mainTextStyle12,
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Text(
              hizbModel.startPageNumber.toString(),
              style: AppStyles.mainTextStyle12.copyWith(color: appColors.secondary),
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
