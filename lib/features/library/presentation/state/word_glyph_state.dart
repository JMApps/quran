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

  void clear() {
    _cache.clear();
    _errors.clear();
    _loading.clear();
    notifyListeners();
  }
}
