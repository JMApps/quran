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

  List<LayoutEntity> getPageLines({required int pageNumber}) => _pagesLineCache[pageNumber] ?? const [];
  bool isLinesLoaded({required int pageNumber}) => _pagesLineCache.containsKey(pageNumber);
  Object? isLinesError({required int pageNumber}) => _errorMap[pageNumber];

  void loadSelectPageLines({required int pageNumber}) {
    _loadPageLines(pageNumber: pageNumber);
  }

  void prefetchAround({required int pageNumber}) {
    if (pageNumber > 1) {
      _loadPageLines(pageNumber: pageNumber - 1);
    }
    if (pageNumber < AppConstants.totalPagesCount) {
      _loadPageLines(pageNumber: pageNumber + 1);
    }
  }

  Future<void> _loadPageLines({required int pageNumber}) async {
    if (_pagesLineCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _pageLineRepository.getPageLines(pageNumber: pageNumber);
      _pagesLineCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  void clear() {
    _pagesLineCache.clear();
    notifyListeners();
  }
}

