import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';

class FavoritePageButton extends StatelessWidget {
  const FavoritePageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final int currentPage = context.select<MainState, int>((s) => s.currentPage);
    return Consumer<FavoritesState>(
      builder: (context, mushafPageMetaState, _) {
        return IconButton(
          onPressed: () {
            mushafPageMetaState.toggleFavoritePage(pageNumber: currentPage);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: appColors.inversePrimary,
                content: Text(
                  mushafPageMetaState.isFavoritePage(currentPage) ? AppStrings.addedToFavorite : AppStrings.removedFromFavorite,
                  style: AppStyles.mainTextStyle18.copyWith(color: appColors.onSurface),
                ),
              ),
            );
          },
          tooltip: mushafPageMetaState.isFavoritePage(currentPage) ? AppStrings.removeFromFavorite : AppStrings.addToFavorite,
          icon: Icon(mushafPageMetaState.isFavoritePage(currentPage) ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          ),
        );
      },
    );
  }
}
