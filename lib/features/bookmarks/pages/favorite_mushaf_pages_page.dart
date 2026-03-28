import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../lists/favorite_mushaf_pages_list.dart';
import '../lists/last_favorite_mushaf_pages_list.dart';

class FavoriteMushafPagesPage extends StatelessWidget {
  const FavoriteMushafPagesPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.bookmarks),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              ListTile(
                visualDensity: VisualDensity.comfortable,
                tileColor: appColors.secondaryContainer,
                title: const Text(AppStrings.lastMushafPages),
              ),
              const LastFavoriteMushafPagesList(),
              ListTile(
                visualDensity: VisualDensity.comfortable,
                tileColor: appColors.secondaryContainer,
                title: const Text(AppStrings.favoriteMushafPages),
              ),
              const FavoriteMushafPagesList(),
            ],
          ),
        ),
      ),
    );
  }
}
