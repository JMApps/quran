import 'package:flutter/material.dart';

import '../../domain/entities/word_glyph_entity.dart';
import '../../domain/usecases/word_glyph_use_case.dart';

class WordGlyphState extends ChangeNotifier {
  final WordGlyphUseCase _wordGlyphUseCase;

  WordGlyphState(this._wordGlyphUseCase);

  final Map<int, List<WordGlyphEntity>> _pageWordsCache = {};
  final Map<int, bool> _loadingMap = {};
  final Set<int> _inFlight = {};

  List<WordGlyphEntity> getPageWords(int pageNumber) {
    return _pageWordsCache[pageNumber] ?? const [];
  }

  Map<int, List<WordGlyphEntity>> getPageWordsByLine(int pageNumber) {
    final words = getPageWords(pageNumber);
    final Map<int, List<WordGlyphEntity>> wordsByLine = {};

    for (final word in words) {
      final lineNumber = word.lineNumber;
      wordsByLine.putIfAbsent(lineNumber, () => []);
      wordsByLine[lineNumber]!.add(word);
    }

    return wordsByLine;
  }

  bool isPageLoaded(int pageNumber) {
    return _pageWordsCache.containsKey(pageNumber);
  }

  Future<void> loadPageWords(int pageNumber, {bool prefetchNext = true}) async {
    if (_pageWordsCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);
    _loadingMap[pageNumber] = true;
    notifyListeners();

    try {
      final result = await _wordGlyphUseCase.getWordsByPage(pageNumber: pageNumber);
      _pageWordsCache[pageNumber] = result;
    } catch (e) {
      debugPrint('ERROR loadPageWords($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
      _loadingMap[pageNumber] = false;
      notifyListeners();
    }

    if (prefetchNext) {
      _prefetchPage(pageNumber + 1);
    }
  }

  Future<void> _prefetchPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > 604) return;
    if (_pageWordsCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _wordGlyphUseCase.getWordsByPage(pageNumber: pageNumber);
      _pageWordsCache[pageNumber] = result;
    } finally {
      _inFlight.remove(pageNumber);
    }
  }

  void trimCache({required int currentPage, int keepBefore = 1, int keepAfter = 2}) {
    final minPage = currentPage - keepBefore;
    final maxPage = currentPage + keepAfter;

    final keysToRemove = _pageWordsCache.keys.where((page) => page < minPage || page > maxPage).toList();

    for (final page in keysToRemove) {
      _pageWordsCache.remove(page);
      _loadingMap.remove(page);
      _inFlight.remove(page);
    }

    notifyListeners();
  }

  void clearCache() {
    _pageWordsCache.clear();
    _loadingMap.clear();
    _inFlight.clear();
    notifyListeners();
  }
}