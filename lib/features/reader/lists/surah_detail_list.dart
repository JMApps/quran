import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_library/quran.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.pageNumber,
    required this.ayahPosition,
  });

  final int pageNumber;
  final int ayahPosition;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList>
    with WidgetsBindingObserver {
  late final FavoritesState _favoritesState;
  late final AyahByAyahState _ayahState;

  late final PageController _mushafController;
  late final PageController _translationController;

  bool _isInternalJump = false;

  int get _currentPage => context.read<MainState>().currentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _favoritesState = context.read<FavoritesState>();
    _ayahState = context.read<AyahByAyahState>();

    final initialIndex = _currentPage - 1;

    _mushafController = PageController(initialPage: initialIndex);
    _translationController = PageController(initialPage: initialIndex);

    _ayahState.loadPageAyahs(pageNumber: _currentPage);
    _ayahState.prefetchAround(_currentPage);
  }

  Future<void> _handlePageChanged(
      int index, {
        required bool fromTranslation,
      }) async {
    if (_isInternalJump) return;

    final pageNumber = index + 1;
    final mainState = context.read<MainState>();

    if (mainState.currentPage != pageNumber) {
      mainState.setCurrentPage(pageNumber);
    }

    _ayahState.loadPageAyahs(pageNumber: pageNumber);
    _ayahState.prefetchAround(pageNumber);

    final targetController =
    fromTranslation ? _mushafController : _translationController;

    if (!targetController.hasClients) return;

    final targetIndex =
        targetController.page?.round() ?? targetController.initialPage;

    if (targetIndex == index) return;

    _isInternalJump = true;
    try {
      targetController.jumpToPage(index);
    } finally {
      _isInternalJump = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _favoritesState.addLastOpenedPage(_currentPage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mushafController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationEnabled = context.select<PageMetaState, bool>((s) => s.translationEnabled);
    return Stack(
      children: [
        IgnorePointer(
          ignoring: translationEnabled,
          child: Opacity(
            opacity: translationEnabled ? 0 : 1,
            child: QuranLibraryScreen(
              parentContext: context,
              useDefaultAppBar: false,
              isShowAudioSlider: false,
              showAyahBookmarkedIcon: false,
              isShowTabBar: false,
              topBarStyle: null,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !translationEnabled,
          child: Opacity(
            opacity: translationEnabled ? 1 : 0,
            child: PageView.builder(
              controller: _translationController,
              reverse: true,
              itemCount: AppConstants.totalPagesCount,
              onPageChanged: (pageNumber) {
                _handlePageChanged(pageNumber, fromTranslation: true);
              },
              itemBuilder: (context, index) {
                return SurahDetailItem(
                  index: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}