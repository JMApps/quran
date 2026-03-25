import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../items/favorite_mushaf_page_item.dart';

class FavoriteMushafPagesList extends StatelessWidget {
  const FavoriteMushafPagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 20;
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        final favoriteList = mushafPageMetaState.favoritePages();

        if (favoriteList.isEmpty) {
          return Container(
            padding: AppStyles.mainPadding,
            height: 200,
            child: const Center(
              child: Text(AppStrings.favoriteMushafPagesEmpty),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottomHeight),
          reverse: true,
          itemCount: favoriteList.length,
          itemBuilder: (context, index) {
            final MushafPageMetaEntity mushafPageMetaModel = favoriteList[index];
            return FavoriteMushafPageItem(
              mushafPageMetaModel: mushafPageMetaModel,
              index: index,
            );
          },
        );
      },
    );
  }
}
