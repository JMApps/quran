import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../items/translation_ayah_detail_item.dart';
import '../items/word_glyph_detail_item.dart';
import '../state/ayah_by_ayah_state.dart';
import '../state/mushaf_page_number_state.dart';
import '../state/translation_mode_state.dart';
import '../state/word_glyph_state.dart';

class MushafPageDetailList extends StatefulWidget {
  const MushafPageDetailList({
    super.key,
    required this.currentPageNumber,
    required this.translationController,
  });

  final int currentPageNumber;
  final PageController translationController;

  @override
  State<MushafPageDetailList> createState() => _MushafPageDetailListState();
}

class _MushafPageDetailListState extends State<MushafPageDetailList> with WidgetsBindingObserver {
  late final WordGlyphState _wordGlyphState;
  late final AyahByAyahState _ayahState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _wordGlyphState = context.read<WordGlyphState>();
    _ayahState = context.read<AyahByAyahState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _wordGlyphState.prefetchAround(pageNumber: widget.currentPageNumber);
      _ayahState.prefetchAround(pageNumber: widget.currentPageNumber);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) return;
    context.read<FavoritesState>().addLastOpenedPage(
      context.read<MushafPageNumberState>().currentPageNumber,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationMode = context.select<TranslationModeState, bool>((s) => s.translationMode);
    return PageView.builder(
      controller: widget.translationController,
      allowImplicitScrolling: false,
      clipBehavior: Clip.hardEdge,
      physics: const ClampingScrollPhysics(),
      reverse: true,
      dragStartBehavior: .down,
      itemCount: AppConstants.totalPagesCount,
      onPageChanged: (index) {
        final currentPageNumber = index + 1;
        context.read<MushafPageNumberState>().currentPageNumber = currentPageNumber;
        _wordGlyphState.prefetchAround(pageNumber: currentPageNumber);
        _ayahState.prefetchAround(pageNumber: currentPageNumber);
      },
      itemBuilder: (context, index) => translationMode ? TranslationAyahDetailItem(index: index) : WordGlyphDetailItem(index: index),
    );
  }
}
