import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../items/favorite_ayah_item.dart';

class FavoriteAyahsList extends StatefulWidget {
  const FavoriteAyahsList({
    super.key,
    required this.tableName,
  });

  final String tableName;

  @override
  State<FavoriteAyahsList> createState() => _FavoriteAyahsListState();
}

class _FavoriteAyahsListState extends State<FavoriteAyahsList> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      await context.read<MushafPageMetaState>().loadFavoriteAyahsMeta(
        tableName: widget.tableName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 21;
    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        final favoriteAyahsList = mushafPageMetaState.favoriteAyahs();

        if (mushafPageMetaState.isLoadingAyahs) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (mushafPageMetaState.errorAyahsList != null) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorAyahFavoritesList}\n${mushafPageMetaState.errorAyahsList}',
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        if (favoriteAyahsList.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                AppStrings.favoriteAyahsEmpty,
                style: AppStyles.mainTextStyle18,
                textAlign: .center,
              ),
            ),
          );
        }

        return Scrollbar(
          child: ListView.builder(
            padding: .only(bottom: bottomHeight),
            itemCount: favoriteAyahsList.length,
            itemBuilder: (context, index) {
              final AyahByAyahEntity ayahByAyahModel = favoriteAyahsList[index];
              return FavoriteAyahItem(
                ayahByAyahModel: ayahByAyahModel,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
