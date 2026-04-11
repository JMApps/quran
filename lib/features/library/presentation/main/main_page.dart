import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../bookmarks/pages/favorite_pages_page.dart';
import '../../../settings/pages/app_settings_page.dart';
import '../juz/pages/juzs_page.dart';
import '../state/main_state.dart';
import '../surahs/pages/surahs_name_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final List<Widget> _mainPages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _mainPages  = [
      SurahNamePage(scrollController: _scrollController),
      const FavoritePagesPage(),
      JuzsPage(scrollController: _scrollController),
      const AppSettingsPage(),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final currentNavigatorIndex = context.select<MainState, int>((s) => s.mainNavigatorIndex);
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentNavigatorIndex),
          child: _mainPages[currentNavigatorIndex],
        ),
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                appColors.primary.withAlpha(0),
                appColors.primary.withAlpha(15),
                appColors.primary.withAlpha(35),
                appColors.primary.withAlpha(55),
                appColors.primary.withAlpha(75),
              ],
            ),
          ),
          child: Card(
            margin: AppStyles.withoutTopPadding,
            shape: AppStyles.bigShape,
            child: SalomonBottomBar(
              itemShape: AppStyles.bigShape,
              selectedItemColor: appColors.primary,
              unselectedItemColor: appColors.onSurface.withAlpha(175),
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.line_style_rounded),
                  title: const Text(AppStrings.surahs),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.bookmark_border_rounded),
                  title: const Text(AppStrings.bookmarks),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.circle_rounded),
                  title: const Text(AppStrings.juzs),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  title: const Text(AppStrings.settings),
                ),
              ],
              currentIndex: currentNavigatorIndex,
              onTap: (int index) {
                if (currentNavigatorIndex != index) {
                  Provider.of<MainState>(context, listen: false).mainNavigatorIndex = index;
                } else {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutQuart,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
