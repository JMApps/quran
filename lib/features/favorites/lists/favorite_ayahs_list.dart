import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_meta_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../items/favorite_ayah_item.dart';

class FavoriteAyahsList extends StatefulWidget {
  const FavoriteAyahsList({super.key});

  @override
  State<FavoriteAyahsList> createState() => _FavoriteAyahsListState();
}

class _FavoriteAyahsListState extends State<FavoriteAyahsList> {
  late FavoritesState _favoritesState;

  @override
  void initState() {
    super.initState();
    _favoritesState = Provider.of<FavoritesState>(context, listen: false);
    _favoritesState.addListener(_onFavoritesChanged);
    Future.microtask(() => _load());
  }

  @override
  void dispose() {
    _favoritesState.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    final ayahIds = _favoritesState.favoriteAyahIds;

    await Provider.of<AyahMetaState>(context, listen: false).syncFavoriteAyahs(
      ayahIds: ayahIds,

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