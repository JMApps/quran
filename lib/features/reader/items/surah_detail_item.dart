import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/page_layout_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../lists/ayah_by_ayah_list.dart';
import '../widgets/mushaf_page_widget.dart';

/// Один элемент [PageView] — одна страница Мусхафа.
///
/// Стратегия загрузки:
/// - Все данные текущей страницы запускаются СРАЗУ в [initState] (fire-and-forget).
///   Provider.of(listen: false) работает в initState — откладывать не нужно.
///   Это устраняет лишний пустой кадр при скролле.
/// - Prefetch соседних страниц — через Future.microtask, тоже до первого build.
/// - [MushafPageWidget] не получает allSurahs — он его не использует.
/// - Selector<PageMetaState> вместо Consumer — ребилд только при смене
///   translationEnabled, не на каждый notifyListeners PageMetaState.
class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
    required this.ayahPosition,
    required this.isDirectionForward,
  });

  final int index;
  final int ayahPosition;

  /// Направление листания: true = вперёд по тексту (→ меньший номер в UI,
  /// т.к. PageView reverse: true). Используется для оптимизации prefetch.
  final bool isDirectionForward;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> with AutomaticKeepAliveClientMixin {
  late final int _pageNumber;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;

    // Загружаем данные сразу — без postFrameCallback.
    // State-классы сами защищены от дублирования через _inFlight.
    _loadCurrentPage();

    // Prefetch — microtask: раньше первого build, но не блокирует initState.
    Future.microtask(_prefetchSurroundingPages);
  }

  // ─────────────────────────────────────────────────────────────
  // Загрузка текущей страницы
  // ─────────────────────────────────────────────────────────────

  /// Fire-and-forget: все четыре запроса стартуют параллельно.
  /// Не await — UI не ждёт, данные придут и вызовут notifyListeners.
  void _loadCurrentPage() {
    Provider.of<MushafFontState>(context, listen: false)
        .onPageChanged(_pageNumber, isForward: widget.isDirectionForward);
    Provider.of<PageLayoutState>(context, listen: false)
        .loadPageLines(_pageNumber, prefetchNext: false);
    Provider.of<WordGlyphState>(context, listen: false)
        .loadPageWords(_pageNumber, prefetchNext: false);
    Provider.of<AyahByAyahState>(context, listen: false)
        .loadPageAyahs(pageNumber: _pageNumber, prefetchNext: false);
  }

  // ─────────────────────────────────────────────────────────────
  // Фоновый prefetch
  // ─────────────────────────────────────────────────────────────

  /// Bidirectional prefetch: 3 страницы по направлению движения,
  /// 2 страницы против (пользователь может вернуться).
  void _prefetchSurroundingPages() {
    if (!mounted) return;

    for (int delta = 1; delta <= 3; delta++) {
      _prefetchPage(
        widget.isDirectionForward ? _pageNumber + delta : _pageNumber - delta,
      );
    }
    for (int delta = 1; delta <= 2; delta++) {
      _prefetchPage(
        widget.isDirectionForward ? _pageNumber - delta : _pageNumber + delta,
      );
    }
  }

  void _prefetchPage(int page) {
    if (page < 1 || page > AppConstants.totalPagesCount) return;
    if (!mounted) return;

    Provider.of<MushafFontState>(context, listen: false)
        .onPageChanged(page, isForward: widget.isDirectionForward);
    Provider.of<PageLayoutState>(context, listen: false)
        .loadPageLines(page, prefetchNext: false);
    Provider.of<WordGlyphState>(context, listen: false)
        .loadPageWords(page, prefetchNext: false);
    Provider.of<AyahByAyahState>(context, listen: false)
        .loadPageAyahs(pageNumber: page, prefetchNext: false);
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Selector вместо Consumer — ребилд только при смене translationEnabled.
    final translationEnabled = context.select<PageMetaState, bool>(
          (s) => s.translationEnabled,
    );

    if (translationEnabled) {
      // allSurahs нужен только для режима перевода (AyahByAyahList).
      final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
            (s) => s.getPageAyahs(pageNumber: _pageNumber),
      );
      final allSurahs = context.select<SurahNameState, List<SurahNameEntity>>(
            (s) => s.allSurahs,
      );
      return AyahByAyahList(
        ayahsPage: ayahs,
        allSurahs: allSurahs,
        ayahPosition: widget.ayahPosition,
      );
    }

    // Режим мусхафа — allSurahs не нужен (MushafPageWidget его не использует).
    return MushafPageWidget(pageNumber: _pageNumber);
  }
}