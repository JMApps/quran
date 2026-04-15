import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/data/arguments/surah_detail_args.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/surah_name_state.dart';

class FavoritePageItem extends StatelessWidget {
  const FavoritePageItem({
    super.key,
    required this.mushafPageMetaModel,
    required this.index,
  });

  final PageMetaEntity mushafPageMetaModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final itemOddColor = appColors.secondary.withAlpha(25);
    final itemEvenColor = appColors.secondary.withAlpha(05);
    final surahModel = context.read<SurahNameState>().getSurahById(
      surahNumber: mushafPageMetaModel.surahNumber,
    );
    return InkWell(
      onTap: () {
        final surahState = Provider.of<SurahNameState>(context, listen: false);
        final arguments = SurahDetailArgs(
          currentMushafPage: mushafPageMetaModel.pageNumber,
        );
        surahState.setCurrentPage(mushafPageMetaModel.pageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
        );
      },
      focusColor: appColors.inversePrimary.withAlpha(55),
      splashColor: appColors.inversePrimary,
      child: Container(
        padding: AppStyles.vrBigHrMiniPadding,
        decoration: BoxDecoration(
          color: index.isOdd ? itemEvenColor : itemOddColor,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Provider.of<FavoritesState>(
                  context,
                  listen: false,
                ).toggleFavoritePage(pageNumber: mushafPageMetaModel.pageNumber);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: appColors.inversePrimary,
                    content: Text(
                      AppStrings.removedFromFavorite,
                      style: AppStyles.mainTextStyle16.copyWith(color: appColors.onSurface),
                    ),
                  ),
                );
              },
              padding: .zero,
              visualDensity: .compact,
              icon: Icon(
                Icons.bookmark_rounded,
                color: appColors.primary,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    '${AppStrings.surah} ${surahModel!.nameTranscription}',
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
