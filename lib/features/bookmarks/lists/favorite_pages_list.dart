import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../items/favorite_page_item.dart';

class FavoritePagesList extends StatelessWidget {
  const FavoritePagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 21;
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        final favoritePagesList = mushafPageMetaState.favoritePages();

        if (mushafPageMetaState.isLoadingPages) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (mushafPageMetaState.errorPages != null) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorPageFavoritesList}\n${mushafPageMetaState.errorPages}',
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        if (favoritePagesList.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                AppStrings.favoritePagesEmpty,
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        return Scrollbar(
          child: ListView.builder(
            padding: .only(bottom: bottomHeight),
            itemCount: favoritePagesList.length,
            itemBuilder: (context, index) {
              final MushafPageMetaEntity mushafPageMetaModel = favoritePagesList[index];
              return FavoritePageItem(
                mushafPageMetaModel: mushafPageMetaModel,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
