import 'package:flutter/foundation.dart';

import '../../domain/entities/layout_entity.dart';
import '../../domain/repositories/layout_repository.dart';

class PageLayoutState extends ChangeNotifier {
  final LayoutRepository _pageLayoutRepository;

  PageLayoutState(this._pageLayoutRepository);

  final Map<int, List<LayoutEntity>> _pagesCache = {};
  final Map<int, Object?> _errorMap = {};
  final Set<int> _inFlight = {};

  List<LayoutEntity> getPageLines(int pageNumber) {
    return _pagesCache[pageNumber] ?? const [];
  }

  bool isPageLoaded(int pageNumber) => _pagesCache.containsKey(pageNumber);

  Object? getPageError(int pageNumber) => _errorMap[pageNumber];

  Future<void> loadPageLines(int pageNumber, {bool prefetchNext = true}) async {
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);
    // notifyListeners при старте убран: данных ещё нет, Selector вернёт тот же
    // const [] — перерисовки не будет, зато лишних проходов по дереву не будет.

    try {
      final result = await _pageLayoutRepository.getLinesByPage(
        pageNumber: pageNumber,
      );
      _pagesCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
      debugPrint('ERROR loadPageLines($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners(); // один вызов — когда данные реально появились
    }

    if (prefetchNext) {
      _prefetchPage(pageNumber + 1);
    }
  }

  Future<void> _prefetchPage(int pageNumber) async {
    if (pageNumber < 1) return;
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _pageLayoutRepository.getLinesByPage(
        pageNumber: pageNumber,
      );
      _pagesCache[pageNumber] = result;
    } catch (e) {
      debugPrint('PREFETCH ERROR loadPageLines($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
      // Prefetch тоже уведомляет — виджет соседней страницы ждёт данных.
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

    final keysToRemove = _pagesCache.keys
        .where((page) => page < minPage || page > maxPage)
        .toList();

    for (final page in keysToRemove) {
      _pagesCache.remove(page);
      _errorMap.remove(page);
      _inFlight.remove(page);
    }

    notifyListeners();
  }

  void clearCache() {
    _pagesCache.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }
}