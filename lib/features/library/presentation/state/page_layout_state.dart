import 'package:flutter/foundation.dart';

import '../../domain/entities/layout_entity.dart';
import '../../domain/usecases/layout_use_case.dart';

class PageLayoutState extends ChangeNotifier {
  final LayoutUseCase _pageLayoutUseCase;

  PageLayoutState(this._pageLayoutUseCase);

  final Map<int, List<LayoutEntity>> _pagesCache = {};
  final Map<int, bool> _loadingMap = {};
  final Map<int, Object?> _errorMap = {};
  final Set<int> _inFlight = {};

  List<LayoutEntity> getPageLines(int pageNumber) {
    return _pagesCache[pageNumber] ?? const [];
  }

  bool isPageLoaded(int pageNumber) {
    return _pagesCache.containsKey(pageNumber);
  }

  bool isPageLoading(int pageNumber) {
    return _loadingMap[pageNumber] ?? false;
  }

  Object? getPageError(int pageNumber) {
    return _errorMap[pageNumber];
  }

  Future<void> loadPageLines(
      int pageNumber, {
        bool prefetchNext = true,
      }) async {
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);
    _loadingMap[pageNumber] = true;
    _errorMap[pageNumber] = null;
    notifyListeners();

    try {
      final result = await _pageLayoutUseCase.getLinesByPage(
        pageNumber: pageNumber,
      );

      _pagesCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
      debugPrint('ERROR loadPageLines($pageNumber): $e');
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
    if (pageNumber < 1) return;
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _pageLayoutUseCase.getLinesByPage(
        pageNumber: pageNumber,
      );

      _pagesCache[pageNumber] = result;
    } catch (e) {
      debugPrint('PREFETCH ERROR loadPageLines($pageNumber): $e');
    } finally {
      _inFlight.remove(pageNumber);
    }
  }

  void trimCache({
    required int currentPage,
    int keepBefore = 1,
    int keepAfter = 2,
  }) {
    final minPage = currentPage - keepBefore;
    final maxPage = currentPage + keepAfter;

    final keysToRemove = _pagesCache.keys.where((page) => page < minPage || page > maxPage).toList();

    for (final page in keysToRemove) {
      _pagesCache.remove(page);
      _loadingMap.remove(page);
      _errorMap.remove(page);
      _inFlight.remove(page);
    }

    notifyListeners();
  }

  void clearCache() {
    _pagesCache.clear();
    _loadingMap.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }
}