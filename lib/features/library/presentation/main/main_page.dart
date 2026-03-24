import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/bookmarks/pages/favorite_mushaf_pages_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../settings/pages/app_settings_page.dart';
import '../hizb/pages/hizbs_page.dart';
import '../juz/pages/juzs_page.dart';
import '../state/main_state.dart';
import '../surahs/pages/surahs_name_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  late final List<Widget> _mainPages = [
    SurahNamePage(scrollController: _scrollController),
    FavoriteMushafPagesPage(scrollController: _scrollController),
    JuzsPage(scrollController: _scrollController),
    HizbsPage(scrollController: _scrollController),
    const AppSettingsPage(),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final navIndex = context.select<MainState, int>((s) => s.mainNavigatorIndex);
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
          key: ValueKey(navIndex),
          child: _mainPages[navIndex],
        ),
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                appColors.primary.withAlpha(0),
                appColors.primary.withAlpha(5),
                appColors.primary.withAlpha(15),
                appColors.primary.withAlpha(25),
                appColors.primary.withAlpha(55),
              ],
            ),
          ),
          child: Card(
            margin: AppStyles.mainPadding,
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
                  icon: const Icon(Icons.bookmark_rounded),
                  title: const Text(AppStrings.bookmarks),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.circle_rounded),
                  title: const Text(AppStrings.juzs),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.pie_chart),
                  title: const Text(AppStrings.hizbs),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.settings_rounded),
                  title: const Text(AppStrings.settings),
                ),
              ],
              currentIndex: navIndex,
              onTap: (int index) {
                if (navIndex != index) {
                  context.read<MainState>().mainNavigatorIndex = index;
                } else {
                  _scrollToTop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
