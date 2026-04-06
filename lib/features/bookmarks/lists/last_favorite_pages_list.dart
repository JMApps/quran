import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../items/last_favorite_page_item.dart';

class LastFavoritePagesList extends StatelessWidget {
  const LastFavoritePagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 21;
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        final recentPagesList = mushafPageMetaState.lastOpenedPages();

        if (mushafPageMetaState.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (mushafPageMetaState.error != null) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorLoadSurahsList}\n${mushafPageMetaState.error}',
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        if (recentPagesList.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                AppStrings.lastMushafPagesEmpty,
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        return Scrollbar(
          child: ListView.builder(
            padding: .only(bottom: bottomHeight),
            itemCount: recentPagesList.length,
            itemBuilder: (context, index) {
              final MushafPageMetaEntity mushafPageMetaModel = recentPagesList[index];
              return LastFavoritePageItem(
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
