import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_constants.dart';
import '../../domain/entities/layout_entity.dart';
import '../../domain/repositories/word_glyph_repository.dart';

class WordGlyphState extends ChangeNotifier {
  final WordGlyphRepository _repository;

  WordGlyphState(this._repository);

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
      final data = await _repository.getMushafPageData(pageNumber: page);
      _cache[page] = data;
      _errors.remove(page);
    } catch (e) {
      _errors[page] = e;
    } finally {
      _loading.remove(page);
      notifyListeners();
    }
  }

  void prefetchAround(int page) {
    if (page > 1) {
      _prefetch(page - 1);
    }
    if (page < AppConstants.totalPagesCount) {
      _prefetch(page + 1);
    }
  }

  Future<void> _prefetch(int page) async {
    if (_cache.containsKey(page)) return;
    if (_loading.contains(page)) return;

    _loading.add(page);

    try {
      final data = await _repository.getMushafPageData(pageNumber: page);
      _cache[page] = data;
      _errors.remove(page);
    } catch (_) {
      // игнорируем ошибки префетча
    } finally {
      _loading.remove(page);
      notifyListeners();
    }
  }

  void clear() {
    _cache.clear();
    _errors.clear();
    _loading.clear();
    notifyListeners();
  }
}