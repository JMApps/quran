import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/repositories/word_glyph_repository.dart';

class WordGlyphState extends ChangeNotifier {
  WordGlyphState(this._pageLineRepository);

  final WordGlyphRepository _pageLineRepository;

  final Map<int, List<LayoutEntity>> _pagesLineCache = {};
  final Map<int, Object?> _errorMap = {};
  final Set<int> _inFlight = {};

  int? _activePageNumber;

  List<LayoutEntity> getPageLines({required int pageNumber}) {
    return _pagesLineCache[pageNumber] ?? const [];
  }

  bool isLinesLoaded({required int pageNumber}) {
    return _pagesLineCache.containsKey(pageNumber);
  }

  Object? isLinesError({required int pageNumber}) {
    return _errorMap[pageNumber];
  }

  void prefetchAround({required int pageNumber}) {
    if (pageNumber < 1 || pageNumber > AppConstants.totalPagesCount) return;

    _activePageNumber = pageNumber;

    _retainOnlyAround(pageNumber);

    for (final page in _pagesAround(pageNumber)) {
      unawaited(_loadPageLines(pageNumber: page));
    }
  }

  List<int> _pagesAround(int pageNumber) {
    final pages = <int>[
      pageNumber,
      pageNumber - 1,
      pageNumber + 1,
      pageNumber - 2,
      pageNumber + 2,
    ];

    return pages
        .where((p) => p >= 1 && p <= AppConstants.totalPagesCount)
        .toList(growable: false);
  }

  Future<void> _loadPageLines({required int pageNumber}) async {
    if (_pagesLineCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;
    _inFlight.add(pageNumber);
    try {
      final result = await _pageLineRepository.getPageLines(pageNumber: pageNumber);
      if (_pagesLineCache.length > 10) {
        _pagesLineCache.remove(_pagesLineCache.keys.first);
      }
      _pagesLineCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  bool _isInsideActiveWindow(int pageNumber) {
    final active = _activePageNumber;
    if (active == null) return true;

    return pageNumber >= active - 2 && pageNumber <= active + 2;
  }

  void _retainOnlyAround(int pageNumber) {
    final alive = _pagesAround(pageNumber).toSet();

    _pagesLineCache.removeWhere((page, _) => !alive.contains(page));
    _errorMap.removeWhere((page, _) => !alive.contains(page));
  }

  void clear() {
    _activePageNumber = null;
    _pagesLineCache.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }
}