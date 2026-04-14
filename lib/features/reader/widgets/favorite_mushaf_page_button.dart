import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/surah_name_state.dart';

class FavoriteMushafPageButton extends StatelessWidget {
  const FavoriteMushafPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final int mushafPage = context.select<SurahNameState, int>((s) => s.currentPage);
    return Consumer<FavoritesState>(
      builder: (context, mushafPageMetaState, _) {
        return IconButton(
          onPressed: () {
            mushafPageMetaState.toggleFavoritePage(pageNumber: mushafPage);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: appColors.inversePrimary,
                content: Text(
                  mushafPageMetaState.isFavoritePage(mushafPage) ? AppStrings.addedToFavorite : AppStrings.removedFromFavorite,
                  style: AppStyles.mainTextStyle18.copyWith(color: appColors.onSurface),
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
