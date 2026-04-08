import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/usecases/ayah_by_ayah_use_case.dart';

class AyahByAyahState extends ChangeNotifier {
  final AyahByAyahUseCase _ayahByAyahUseCase;

  AyahByAyahState(this._ayahByAyahUseCase);

  final Map<String, List<AyahByAyahEntity>> _pagesCache = {};
  final Map<String, bool> _loadingMap = {};
  final Map<String, Object?> _errorMap = {};
  final Set<String> _inFlight = {};

  String _makeKey({required int pageNumber, required String tableName}) {
    return '$tableName:$pageNumber';
  }

  List<AyahByAyahEntity> getPageAyahs({required int pageNumber, required String tableName}) {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);
    return _pagesCache[key] ?? const [];
  }

  bool isPageLoaded({required int pageNumber, required String tableName}) {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);
    return _pagesCache.containsKey(key);
  }

  bool isPageLoading({required int pageNumber, required String tableName}) {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);
    return _loadingMap[key] ?? false;
  }

  Object? getPageError({required int pageNumber, required String tableName}) {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);
    return _errorMap[key];
  }

  Future<void> loadPageAyahs({required int pageNumber, required String tableName, bool prefetchNext = true}) async {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);

    if (_pagesCache.containsKey(key)) return;
    if (_inFlight.contains(key)) return;

    _inFlight.add(key);
    _loadingMap[key] = true;
    _errorMap[key] = null;
    notifyListeners();

    try {
      final result = await _ayahByAyahUseCase.getAyahsByPage(pageNumber: pageNumber, tableName: tableName);

      _pagesCache[key] = result;
    } catch (e) {
      _errorMap[key] = e;
    } finally {
      _inFlight.remove(key);
      _loadingMap[key] = false;
      notifyListeners();
    }

    if (prefetchNext && pageNumber < AppStrings.totalPages) {
      _prefetchPage(pageNumber: pageNumber + 1, tableName: tableName);
    }
  }

  Future<void> _prefetchPage({required int pageNumber, required String tableName}) async {
    final key = _makeKey(pageNumber: pageNumber, tableName: tableName);

    if (pageNumber > AppStrings.totalPages) return;
    if (_pagesCache.containsKey(key)) return;
    if (_inFlight.contains(key)) return;

    _inFlight.add(key);
    _errorMap.remove(key);

    try {
      final result = await _ayahByAyahUseCase.getAyahsByPage(pageNumber: pageNumber, tableName: tableName);

      _pagesCache[key] = result;
    } catch (_) {
      //
    } finally {
      _inFlight.remove(key);
    }
  }
  
  Future<List<AyahByAyahEntity>> searchAyahs({required String query, required String dataTable, required String ftsTable}) {
    return _ayahByAyahUseCase.getSearchAyah(query: query, dataTable: dataTable, ftsTable: ftsTable);
  }

  void clearCache() {
    _pagesCache.clear();
    _loadingMap.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }

  void clearCacheByTable(String tableName) {
    final prefix = '$tableName:';

    final keys = _pagesCache.keys.where((key) => key.startsWith(prefix)).toList(growable: false);

    for (final key in keys) {
      _pagesCache.remove(key);
      _loadingMap.remove(key);
      _errorMap.remove(key);
      _inFlight.remove(key);
    }

    notifyListeners();
  }
}