import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../items/mushaf_translation_list_item.dart';
import '../items/word_glyph_detail_item.dart';

class MushafPageDetailList extends StatefulWidget {
  const MushafPageDetailList({
    super.key,
    required this.currentPage,
    required this.translationController,
  });

  final int currentPage;
  final PageController translationController;

  @override
  State<MushafPageDetailList> createState() => _MushafPageDetailListState();
}

class _MushafPageDetailListState extends State<MushafPageDetailList> with WidgetsBindingObserver {
  late final AyahByAyahState _ayahState;
  late final WordGlyphState _wordGlyphState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _ayahState = context.read<AyahByAyahState>();
    _wordGlyphState = context.read<WordGlyphState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _ayahState.prefetchAround(widget.currentPage);
      _wordGlyphState.prefetchAround(widget.currentPage);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      final currentPage = context.read<MainState>().currentPage;
      context.read<FavoritesState>().addLastOpenedPage(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationEnabled = context.select<PageMetaState, bool>((s) => s.translationEnabled);
    return PageView.builder(
      controller: widget.translationController,
      reverse: true,
      allowImplicitScrolling: true,
      itemCount: AppConstants.totalPagesCount,
      onPageChanged: (pageIndex) {
        final pageNumber = pageIndex + 1;
        context.read<MainState>().onMainPageChanged(pageNumber);
        _ayahState.prefetchAround(pageNumber);
        _wordGlyphState.prefetchAround(pageNumber);
      },
      itemBuilder: (context, index) {
        if (!translationEnabled) {
          return WordGlyphDetailItem(
            index: index,
          );
        } else {
          return MushafTranslationListItem(
            index: index,
          );
        }
      },
    );
  }
}