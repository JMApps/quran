import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../lists/favorite_ayahs_list.dart';
import '../lists/favorite_pages_list.dart';
import '../lists/last_favorite_pages_list.dart';

class FavoritePagesPage extends StatelessWidget {
  const FavoritePagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(AppStrings.bookmarks),
          bottom: const TabBar(
            labelStyle: AppStyles.mainTextStyle16,
            tabs: [
              Tab(
                text: AppStrings.recent,
              ),
              Tab(
                text: AppStrings.pages,
              ),
              Tab(
                text: AppStrings.ayahs,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LastFavoritePagesList(),
            FavoritePagesList(),
            FavoriteAyahsList(tableName: 'Table_of_translation_kuliev',),
          ],
        ),
      ),
    );
  }
}
