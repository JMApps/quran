import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/surah_state.dart';

class FavoriteMushafPageButton extends StatelessWidget {
  const FavoriteMushafPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final int mushafPage = context.select<SurahState, int>((s) => s.currentMushafPage);
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        return IconButton(
          onPressed: () {
            if (!mushafPageMetaState.isFavoritePage(mushafPage)) {
              mushafPageMetaState.addFavoritePage(pageNumber: mushafPage);
            } else {
              mushafPageMetaState.removeFavoritePage(pageNumber: mushafPage);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: appColors.inversePrimary,
                content: Text(
                  mushafPageMetaState.isFavoritePage(mushafPage) ? AppStrings.addedToFavorite : AppStrings.removedFromFavorite,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: appColors.primary,
                  ),
                ),
              ),
            );
          },
          tooltip: mushafPageMetaState.isFavoritePage(mushafPage) ? AppStrings.removeFromFavorite : AppStrings.addToFavorite,
          icon: Icon(mushafPageMetaState.isFavoritePage(mushafPage) ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          ),
        );
      },
    );
  }
}
