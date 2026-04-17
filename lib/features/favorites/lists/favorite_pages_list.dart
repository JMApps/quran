import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../items/favorite_page_item.dart';

class FavoritePagesList extends StatelessWidget {
  const FavoritePagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 7;
    final SurahNameState surahNameState = context.read<SurahNameState>();
    return Consumer2<FavoritesState, PageMetaState>(
      builder: (context, bookmarksState, pageMetaState, _) {
        if (pageMetaState.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (pageMetaState.error != null) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorPageFavoritesList}\n${pageMetaState.error}',
                style: AppStyles.mainTextStyle18,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final favoritePagesList = pageMetaState.resolvePages(bookmarksState.favoritePageIds);

        if (favoritePagesList.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                AppStrings.favoritePagesEmpty,
                style: AppStyles.mainTextStyle18,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: bottomHeight),
            itemCount: favoritePagesList.length,
            itemBuilder: (context, index) {
              final PageMetaEntity pageMetaModel = favoritePagesList[index];
              final SurahNameEntity? surahInfo = surahNameState.getSurahByNumber(surahNumber: pageMetaModel.surahNumber);
              return FavoritePageItem(
                mushafPageMetaModel: pageMetaModel,
                index: index,
                surahNameTranscription: surahInfo!.nameTranscription,
              );
            },
          ),
        );
      },
    );
  }
}