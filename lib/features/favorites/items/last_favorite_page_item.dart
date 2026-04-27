import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/data/arguments/mushaf_page_detail_args.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../reader/state/ayah_by_ayah_state.dart';
import '../../reader/state/word_glyph_state.dart';
import '../../reader/state/mushaf_page_number_state.dart';

class LastFavoritePageItem extends StatelessWidget {
  const LastFavoritePageItem({
    super.key,
    required this.mushafPageMetaModel,
    required this.index,
    required this.surahNameTranscription,
  });

  final PageMetaEntity mushafPageMetaModel;
  final int index;
  final String surahNameTranscription;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    return InkWell(
      onTap: () {
        final ayahByAyahState = context.read<AyahByAyahState>();
        final wordGlyphState = context.read<WordGlyphState>();

        ayahByAyahState.loadSelectPageAyahs(pageNumber: mushafPageMetaModel.pageNumber);
        ayahByAyahState.prefetchAround(pageNumber: mushafPageMetaModel.pageNumber);
        wordGlyphState.loadSelectPageLines(pageNumber: mushafPageMetaModel.pageNumber);
        wordGlyphState.prefetchAround(pageNumber: mushafPageMetaModel.pageNumber);

        final mushafPageNumberState = context.read<MushafPageNumberState>();
        mushafPageNumberState.currentPageNumber = mushafPageMetaModel.pageNumber;

        final MushafPageDetailArgs args = MushafPageDetailArgs(pageNumber: mushafPageMetaModel.pageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: args,
        );
      },
      splashColor: appColors.inversePrimary,
      focusColor: appColors.inversePrimary.withAlpha(55),
      child: Container(
        padding: AppStyles.hrMiniVrBigPadding,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: null,
              padding: .zero,
              visualDensity: .compact,
              color: appColors.secondary,
              icon: Icon(
                Icons.access_time_filled_rounded,
                color: appColors.secondary,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    '${AppStrings.surah} $surahNameTranscription',
                    textAlign: .start,
                  ),
                  Text(
                    '${AppStrings.pageShort} ${mushafPageMetaModel.pageNumber}, ${AppStrings.juz.toLowerCase()} ${mushafPageMetaModel.juzNumber}',
                    textAlign: .start,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Text(
              mushafPageMetaModel.pageNumber.toString(),
              style: TextStyle(
                color: appColors.secondary,
              ),
            ),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
