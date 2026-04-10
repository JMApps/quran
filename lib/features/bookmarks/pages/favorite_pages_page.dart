import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/translation_type.dart';
import '../../settings/state/app_settings_state.dart';
import '../lists/favorite_ayahs_list.dart';
import '../lists/favorite_pages_list.dart';
import '../lists/last_favorite_pages_list.dart';

class FavoritePagesPage extends StatelessWidget {
  const FavoritePagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettingsState = context.watch<AppSettingsState>();
    final locale = Localizations.localeOf(context).languageCode;
    final tableName = AppStrings.resolveTranslation(
      locale: locale,
      userSelected: appSettingsState.translationType == TranslationType.defaultTranslation ? null : appSettingsState.translationType).table;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(AppStrings.bookmarks),
          bottom: const TabBar(
            labelStyle: AppStyles.mainTextStyle16,
            tabs: [
              Tab(text: AppStrings.recent),
              Tab(text: AppStrings.pages),
              Tab(text: AppStrings.ayahs),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const LastFavoritePagesList(),
            const FavoritePagesList(),
            FavoriteAyahsList(tableName: tableName),
          ],
        ),
      ),
    );
  }
}
