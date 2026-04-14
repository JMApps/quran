import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_meta_state.dart';
import '../../library/presentation/state/favorites_state.dart';
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
    Future.microtask(() => _load());
  }

  @override
  void didUpdateWidget(FavoriteAyahsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tableName != widget.tableName) {
      Future.microtask(() => _load());
    }
  }

  Future<void> _load() async {
    if (!mounted) return;
    final bookmarksState = Provider.of<FavoritesState>(context, listen: false);
    await Provider.of<AyahMetaState>(context, listen: false).reloadIfTableChanged(
      tableName: widget.tableName,
      ayahIds: bookmarksState.favoriteAyahIds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = kBottomNavigationBarHeight + 14;

    return Consumer2<FavoritesState, AyahMetaState>(
      builder: (context, bookmarksState, ayahMetaState, _) {
        if (ayahMetaState.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (ayahMetaState.error != null) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorAyahFavoritesList}\n${ayahMetaState.error}',
                style: AppStyles.mainTextStyle18,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final favoriteAyahsList = ayahMetaState.resolveAyahs(bookmarksState.favoriteAyahIds);

        if (favoriteAyahsList.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                AppStrings.favoriteAyahsEmpty,
                style: AppStyles.mainTextStyle18,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: bottomHeight),
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