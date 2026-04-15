import 'package:flutter/material.dart';

import '../../domain/entities/word_glyph_entity.dart';
import '../../domain/repositories/word_glyph_repository.dart';

class WordGlyphState extends ChangeNotifier {
  final WordGlyphRepository _wordGlyphRepository;

  WordGlyphState(this._wordGlyphRepository);

  final Map<int, List<WordGlyphEntity>> _pageWordsCache = {};
  final Set<int> _inFlight = {};

  List<WordGlyphEntity> getPageWords(int pageNumber) {
    return _pageWordsCache[pageNumber] ?? const [];
  }

  bool isPageLoaded(int pageNumber) => _pageWordsCache.containsKey(pageNumber);

  Future<void> loadPageWords(int pageNumber, {bool prefetchNext = true}) async {
    if (_pageWordsCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);
    // notifyListeners при старте убран: данных ещё нет, Selector вернёт тот же
    // const [] — перерисовки не будет, зато лишних проходов по дереву не будет.

    try {
      final result =
      await _wordGlyphRepository.getWordsByPage(pageNumber: pageNumber);
      _pageWordsCache[pageNumber] = result;
    } catch (e) {
      debugPrint('ERROR loadPageWords($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners(); // один вызов — когда данные реально появились
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
      final result =
      await _wordGlyphRepository.getWordsByPage(pageNumber: pageNumber);
      _pageWordsCache[pageNumber] = result;
    } catch (e) {
      debugPrint('PREFETCH ERROR loadPageWords($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  void trimCache({
    required int currentPage,
    int keepBefore = 1,
    int keepAfter = 2,
  }) {
    final minPage = currentPage - keepBefore;
    final maxPage = currentPage + keepAfter;

    final keysToRemove = _pageWordsCache.keys
        .where((page) => page < minPage || page > maxPage)
        .toList();

    for (final page in keysToRemove) {
      _pageWordsCache.remove(page);
      _inFlight.remove(page);
    }

    notifyListeners();
  }

  void clearCache() {
    _pageWordsCache.clear();
    _inFlight.clear();
    notifyListeners();
  }
}