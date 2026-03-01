import 'package:flutter/material.dart';

import '../../domain/entities/surah_detail_vm.dart';
import '../../domain/usecases/get_page_word_use_case.dart';

class MushafReaderState extends ChangeNotifier {
  final GetMushafPageUseCase _getPage;

  MushafReaderState(this._getPage);

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  // небольшой кэш страниц
  final Map<int, SurahDetailPageVm> _cache = {};
  SurahDetailPageVm? getPageFromCache(int page) => _cache[page];

  Future<void> loadPage(int pageNumber) async {
    _currentPage = pageNumber;

    // если есть в кэше — просто notify и сделай prefetch
    if (_cache.containsKey(pageNumber)) {
      _error = null;
      notifyListeners();
      _prefetchAround(pageNumber);
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final page = await _getPage.execute(pageNumber: pageNumber);
      _cache[pageNumber] = page;
      _trimCache(keepCenter: pageNumber, radius: 3);
      _loading = false;
      notifyListeners();

      _prefetchAround(pageNumber);
    } catch (e) {
      _loading = false;
      _error = e;
      notifyListeners();
    }
  }

  Future<void> _prefetchAround(int pageNumber) async {
    // аккуратно подтянуть соседние страницы
    final neighbors = [pageNumber - 1, pageNumber + 1];
    for (final p in neighbors) {
      if (p < 1 || p > 604) continue;
      if (_cache.containsKey(p)) continue;

      try {
        final page = await _getPage.execute(pageNumber: p);
        _cache[p] = page;
        _trimCache(keepCenter: pageNumber, radius: 3);
        notifyListeners();
      } catch (_) {
        // игнорируем prefetch ошибки
      }
    }
  }

  void _trimCache({required int keepCenter, required int radius}) {
    final min = keepCenter - radius;
    final max = keepCenter + radius;
    final keys = _cache.keys.toList();
    for (final k in keys) {
      if (k < min || k > max) _cache.remove(k);
    }
  }
}