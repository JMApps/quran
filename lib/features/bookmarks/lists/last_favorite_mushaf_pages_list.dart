import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../items/last_favorite_mushaf_page_item.dart';

class LastFavoriteMushafPagesList extends StatelessWidget {
  const LastFavoriteMushafPagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        final lastFavoriteList = mushafPageMetaState.lastOpenedPages();

        if (lastFavoriteList.isEmpty) {
          return Container(
            padding: AppStyles.mainPadding,
            height: 200,
            child: const Center(
              child: Text(AppStrings.lastMushafPagesEmpty),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: lastFavoriteList.length,
          itemBuilder: (context, index) {
            final MushafPageMetaEntity mushafPageMetaModel = lastFavoriteList[index];
            return LastFavoriteMushafPageItem(
              mushafPageMetaModel: mushafPageMetaModel,
              index: index,
            );
          },
        );
      },
    );
  }
}
