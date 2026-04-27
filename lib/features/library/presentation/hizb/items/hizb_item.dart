import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/names_router.dart';
import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../reader/state/mushaf_page_number_state.dart';
import '../../../data/arguments/mushaf_page_detail_args.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../../../reader/state/ayah_by_ayah_state.dart';
import '../../../../reader/state/word_glyph_state.dart';

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
        final ayahByAyahState = context.read<AyahByAyahState>();
        final wordGlyphState = context.read<WordGlyphState>();

        ayahByAyahState.loadSelectPageAyahs(pageNumber: hizbModel.startPageNumber);
        ayahByAyahState.prefetchAround(pageNumber: hizbModel.startPageNumber);
        wordGlyphState.loadSelectPageLines(pageNumber: hizbModel.startPageNumber);
        wordGlyphState.prefetchAround(pageNumber: hizbModel.startPageNumber);

        final mushafPageNumberState = context.read<MushafPageNumberState>();
        mushafPageNumberState.currentPageNumber = hizbModel.startPageNumber;

        final MushafPageDetailArgs args = MushafPageDetailArgs(pageNumber: hizbModel.startPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: args,
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
