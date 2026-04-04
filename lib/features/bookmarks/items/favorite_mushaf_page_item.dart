import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../library/presentation/state/surah_state.dart';

class FavoriteMushafPageItem extends StatelessWidget {
  const FavoriteMushafPageItem({
    super.key,
    required this.mushafPageMetaModel,
    required this.index,
  });

  final MushafPageMetaEntity mushafPageMetaModel;
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
      leading: IconButton(
        onPressed: () {
          Provider.of<MushafPageMetaState>(context, listen: false).removeFavoritePage(pageNumber: mushafPageMetaModel.pageNumber);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 1350),
              backgroundColor: appColors.primary,
              content: const Text(
                AppStrings.removedFromFavorite,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        },
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(
          Icons.bookmark_rounded,
          color: appColors.secondary,
        ),
      ),
      onTap: () {
        final surahState = Provider.of<SurahState>(context, listen: false);
        surahState.setMushafCurrentPage(mushafPageMetaModel.pageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
        );
      },
      title: Text('${AppStrings.surah} ${mushafPageMetaModel.nameTranscription}'),
      subtitle: Text(
        '${AppStrings.pageShort} ${mushafPageMetaModel.pageNumber}, ${AppStrings.juz.toLowerCase()} ${mushafPageMetaModel.juzNumber}',
      ),
      trailing: Text(
        mushafPageMetaModel.pageNumber.toString(),
        style: TextStyle(
          color: appColors.secondary,
        ),
      ),
    );
  }
}
