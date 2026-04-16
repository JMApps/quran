import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/word_glyph_state.dart';
import 'package:quran/features/reader/items/word_glyph_detail_item.dart';

import '../../../core/strings/app_constants.dart';
import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList> with WidgetsBindingObserver {
  late final PageController _translationController;
  late final AyahByAyahState _ayahState;
  late final WordGlyphState _wordGlyphState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _translationController = PageController(
      initialPage: widget.currentPage - 1,
    );

    _ayahState = context.read<AyahByAyahState>();
    _wordGlyphState = context.read<WordGlyphState>();

    // Важно:
    // не вызываем notifyListeners-содержащие методы синхронно в initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _ayahState.loadPageAyahs(pageNumber: widget.currentPage);
      _ayahState.prefetchAround(widget.currentPage);

      _wordGlyphState.loadPage(widget.currentPage);
      _wordGlyphState.prefetchAround(widget.currentPage);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final currentPage = context.read<MainState>().currentPage;
      context.read<FavoritesState>().addLastOpenedPage(currentPage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationEnabled = context.select<PageMetaState, bool>(
          (s) => s.translationEnabled,
    );

    final currentPageNumber = context.select<MainState, int?>(
          (s) => s.currentPage,
    ) ?? widget.currentPage;

    final pageMetaModel = context.select<PageMetaState, PageMetaEntity?>(
          (s) => s.getPageMeta(currentPageNumber),
    );

    final surahNameModel = pageMetaModel == null
        ? null
        : context.select<SurahNameState, SurahNameEntity?>(
          (s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber),
    );

    return PageView.builder(
      controller: _translationController,
      reverse: true,
      physics: const ClampingScrollPhysics(),
      itemCount: AppConstants.totalPagesCount,
      onPageChanged: (pageIndex) {
        final pageNumber = pageIndex + 1;

        context.read<MainState>().onMainPageChanged(pageNumber);

        _ayahState.loadPageAyahs(pageNumber: pageNumber);
        _ayahState.prefetchAround(pageNumber);

        _wordGlyphState.loadPage(pageNumber);
        _wordGlyphState.prefetchAround(pageNumber);
      },
      itemBuilder: (context, index) {
        if (translationEnabled) {
          return SurahDetailItem(
            index: index,
          );
        }

        return Padding(
          padding: const EdgeInsets.only(
            top: 28,
            left: 14,
            bottom: 7,
            right: 14,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    surahNameModel == null
                        ? AppStrings.surah
                        : '${AppStrings.surah} ${surahNameModel.nameTranscription}',
                  ),
                  Text(
                    pageMetaModel == null
                        ? AppStrings.juz
                        : '${AppStrings.juz} ${pageMetaModel.juzNumber}',
                  ),
                ],
              ),
              Expanded(
                child: WordGlyphDetailItem(
                  index: index,
                ),
              ),
              Text(
                '$currentPageNumber',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}