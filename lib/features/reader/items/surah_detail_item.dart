import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../library/presentation/state/page_layout_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../lists/ayah_by_ayah_list.dart';
import '../widgets/mushaf_page_widget.dart';

/// Один элемент [PageView] — одна страница Мусхафа.
///
/// Стратегия загрузки:
/// - Шрифт, layout и words текущей страницы стартуют ПАРАЛЛЕЛЬНО ([Future.wait]).
/// - Ayahs (для режима перевода) — тоже параллельно с остальными.
/// - После загрузки текущей страницы — bidirectional prefetch: вперёд ±3,
///   назад ±2 (не блокирует UI, fire-and-forget).
/// - Кэши всех State'ов подрезаются после каждой загрузки.
class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
    required this.tableName,
    required this.ayahPosition,
    required this.isDirectionForward,
  });

  final int index;
  final String tableName;
  final int ayahPosition;

  /// Направление листания: true = вперёд по тексту (→ меньший номер в UI,
  /// т.к. PageView reverse: true). Используется для оптимизации prefetch.
  final bool isDirectionForward;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  late final int _pageNumber;

  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Сначала убедимся, что список сур загружен.
      await Provider.of<SurahNameState>(context, listen: false).loadAllSurahNames();
      if (!mounted) return;

      // Параллельная загрузка текущей страницы.
      await _loadCurrentPageParallel();
      if (!mounted) return;

      // Фоновый prefetch — не ждём.
      _prefetchSurroundingPages();
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Загрузка текущей страницы
  // ─────────────────────────────────────────────────────────────

  /// Все данные страницы грузятся одновременно.
  /// Шрифт, layout, glyphs и ayahs не зависят друг от друга на уровне данных —
  /// нет смысла выстраивать их в цепочку.
  Future<void> _loadCurrentPageParallel() async {
    final fontState = Provider.of<MushafFontState>(context, listen: false);
    final layoutState = Provider.of<PageLayoutState>(context, listen: false);
    final glyphState = Provider.of<WordGlyphState>(context, listen: false);
    final ayahState = Provider.of<AyahByAyahState>(context, listen: false);

    await Future.wait([
      fontState.onPageChanged(
        _pageNumber,
        isForward: widget.isDirectionForward,
      ),
      layoutState.loadPageLines(_pageNumber, prefetchNext: false),
      glyphState.loadPageWords(_pageNumber, prefetchNext: false),
      ayahState.loadPageAyahs(
        pageNumber: _pageNumber,
        tableName: widget.tableName,
        prefetchNext: false,
      ),
    ], eagerError: false); // eagerError: false — не прерываем остальные при ошибке одного
  }

  // ─────────────────────────────────────────────────────────────
  // Фоновый prefetch
  // ─────────────────────────────────────────────────────────────

  /// Bidirectional prefetch: 3 страницы по направлению движения,
  /// 2 страницы против (пользователь может вернуться).
  ///
  /// Всё — fire and forget, не блокируем текущий рендер.
  void _prefetchSurroundingPages() {
    // Вперёд по направлению листания — 3 страницы.
    for (int delta = 1; delta <= 3; delta++) {
      final page = widget.isDirectionForward
          ? _pageNumber + delta
          : _pageNumber - delta;
      _prefetchPage(page);
    }

    // Назад (против направления) — 2 страницы.
    for (int delta = 1; delta <= 2; delta++) {
      final page = widget.isDirectionForward
          ? _pageNumber - delta
          : _pageNumber + delta;
      _prefetchPage(page);
    }
  }

  void _prefetchPage(int page) {
    if (page < 1 || page > AppStrings.totalPages) return;
    if (!mounted) return;

    final fontState = Provider.of<MushafFontState>(context, listen: false);
    final layoutState = Provider.of<PageLayoutState>(context, listen: false);
    final glyphState = Provider.of<WordGlyphState>(context, listen: false);
    final ayahState = Provider.of<AyahByAyahState>(context, listen: false);

    // Все данные страницы стартуют параллельно, не ждём.
    fontState.onPageChanged(page, isForward: widget.isDirectionForward);
    layoutState.loadPageLines(page, prefetchNext: false);
    glyphState.loadPageWords(page, prefetchNext: false);
    ayahState.loadPageAyahs(
      pageNumber: page,
      tableName: widget.tableName,
      prefetchNext: false,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
          (s) => s.getPageAyahs(
        pageNumber: _pageNumber,
        tableName: widget.tableName,
      ),
    );
    final allSurahs = context.select<SurahNameState, List<SurahNameEntity>>(
          (s) => s.allSurahs,
    );

    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        if (mushafPageMetaState.translationEnabled) {
          return AyahByAyahList(
            ayahsPage: ayahs,
            allSurahs: allSurahs,
            ayahPosition: widget.ayahPosition,
          );
        }
        return MushafPageWidget(pageNumber: _pageNumber);
      },
    );
  }
}