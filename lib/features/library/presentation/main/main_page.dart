import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
  late final List<Widget> _mainPages = [
    SurahNamePage(scrollController: _scrollController),
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
    return Consumer<MainState>(
      builder: (context, mainState, _) {
        return Scaffold(
          extendBody: true,
          body: _mainPages[mainState.mainNavigatorIndex],
          bottomNavigationBar: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
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
                    title: const Text('Суры'),
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.circle_rounded),
                    title: const Text('Джузы'),
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.pie_chart),
                    title: const Text('Хизбы'),
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.settings_rounded),
                    title: const Text('Настройки'),
                  ),
                ],
                currentIndex: mainState.mainNavigatorIndex,
                onTap: (int index) {
                  if (mainState.mainNavigatorIndex != index) {
                    mainState.mainNavigatorIndex = index;
                  } else {
                    _scrollToTop();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
