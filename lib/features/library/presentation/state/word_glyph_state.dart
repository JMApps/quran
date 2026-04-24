import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/strings/app_constants.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/entities/line_type.dart';
import '../../domain/repositories/word_glyph_repository.dart';

class WordGlyphState extends ChangeNotifier {
  WordGlyphState(this._repository);

  final WordGlyphRepository _repository;

  final Map<int, List<LayoutEntity>> _cache = {};
  final Map<int, Object?> _errors = {};
  final Set<int> _loading = {};

  List<LayoutEntity> getPageLines(int page) => _cache[page] ?? const [];

  bool isLoaded(int page) => _cache.containsKey(page);

  bool isLoading(int page) => _loading.contains(page);

  Object? getError(int page) => _errors[page];

  Future<void> loadPage(int page) async {
    if (_cache.containsKey(page)) return;
    if (_loading.contains(page)) return;

    _loading.add(page);
    notifyListeners();

    try {
      _cache[page] = await _repository.getMushafPageData(pageNumber: page);
      _errors.remove(page);
    } catch (e) {
      _errors[page] = e;
    } finally {
      _loading.remove(page);
      notifyListeners();
    }
  }

  void prefetchAround(int page) {
    if (page > 1) _prefetch(page - 1);
    if (page < AppConstants.totalPagesCount) _prefetch(page + 1);
    trimCache(currentPage: page);
  }

  Future<void> _prefetch(int page) async {
    if (_cache.containsKey(page)) return;
    if (_loading.contains(page)) return;
    _loading.add(page);
    try {
      _cache[page] = await _repository.getMushafPageData(pageNumber: page);
      _errors.remove(page);
    } catch (_) {
      // молча
    } finally {
      _loading.remove(page);
      notifyListeners();
    }
  }

  void trimCache({required int currentPage, int keepBefore = 2, int keepAfter = 3}) {
    final minPage = currentPage - keepBefore;
    final maxPage = currentPage + keepAfter;
    _cache.removeWhere((page, _) => page < minPage || page > maxPage);
    _errors.removeWhere((page, _) => page < minPage || page > maxPage);
    _fitFontSizeCache.removeWhere((key, _) => key.page < minPage || key.page > maxPage);
  }

  // В WordGlyphState
  final Set<int> _prewarmedPages = {};

  /// Вызывается из UI когда страница стала видимой и стабильной
  void onPageSettled(int currentPage) {
    _prewarmNeighbor(currentPage + 1);
    _prewarmNeighbor(currentPage - 1);
  }

  Future<void> _prewarmNeighbor(int page) async {
    if (page < 1 || page > AppConstants.totalPagesCount) return;
    if (_prewarmedPages.contains(page)) return;
    final lines = _cache[page];
    if (lines == null) return;

    _prewarmedPages.add(page);

    // Берём только ОДНУ строку-сэмпл, не всю страницу.
    // На слабом GPU этого достаточно чтобы прогреть atlas для шрифта.
    final ayahLine = lines.firstWhere(
      (l) => l.lineType == LineType.ayah,
      orElse: () => lines.first,
    );
    final text = ayahLine.words
        .map((w) => w.glyph)
        .where((g) => g.isNotEmpty)
        .take(5) // только первые 5 слов, не всю строку
        .join('\u200A');
    if (text.isEmpty) return;

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontFamily: 'P$page', fontSize: 50),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      painter.paint(canvas, Offset.zero);

      final width = painter.width.ceil().clamp(1, 512); // мельче картинка
      final height = painter.height.ceil().clamp(1, 128);
      painter.dispose();

      final picture = recorder.endRecording();
      final image = await picture.toImage(width, height);
      image.dispose();
      picture.dispose();
    } catch (e) {
      debugPrint('Prewarm failed for page $page: $e');
    }
  }

  final Map<_FitKey, double> _fitFontSizeCache = {};

  double getFitFontSize({
    required int page,
    required double availableWidth,
  }) {
    // Округляем ширину до целых пикселей — избавляемся от дробных float'ов
    final widthKey = availableWidth.round();
    final key = _FitKey(page, widthKey);

    final cached = _fitFontSizeCache[key];
    if (cached != null) return cached;

    final lines = _cache[page];
    if (lines == null) return 26.0; // разумный fallback

    final result = _calculateFitFontSize(
      layoutsPage: lines,
      availableWidth: availableWidth,
      pageNumber: page,
    );
    _fitFontSizeCache[key] = result;
    return result;
  }

  double _calculateFitFontSize({
    required List<LayoutEntity> layoutsPage,
    required double availableWidth,
    required int pageNumber,
  }) {
    // Пробный размер — любой ненулевой, скажем 40px
    const probeFontSize = 40.0;

    // Ищем самую широкую строку типа ayah (не surahName/basmallah — у них своя логика)
    double maxMeasuredWidth = 0;

    for (final layout in layoutsPage) {
      if (layout.lineType != LineType.ayah) continue;

      final text = layout.words
          .map((w) => w.glyph)
          .where((g) => g.isNotEmpty)
          .join('\u200A');
      if (text.isEmpty) continue;

      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'P$pageNumber',
            fontSize: probeFontSize,
            height: 1.9,
          ),
        ),
        textDirection: TextDirection.rtl,
        maxLines: 1,
      )..layout();

      if (painter.width > maxMeasuredWidth) {
        maxMeasuredWidth = painter.width;
      }
      painter.dispose();
    }

    if (maxMeasuredWidth == 0) return probeFontSize;

    // Пропорция: если строка шириной maxMeasuredWidth на probeFontSize,
    // то на availableWidth она должна быть с таким fontSize:
    final scaleFactor = availableWidth / maxMeasuredWidth;
    return probeFontSize * scaleFactor;
  }

  void clear() {
    _cache.clear();
    _errors.clear();
    _loading.clear();
    notifyListeners();
  }
}

class _FitKey {
  final int page;
  final int width;
  const _FitKey(this.page, this.width);

  @override
  bool operator ==(Object other) =>
      other is _FitKey && other.page == page && other.width == width;

  @override
  int get hashCode => Object.hash(page, width);
}
