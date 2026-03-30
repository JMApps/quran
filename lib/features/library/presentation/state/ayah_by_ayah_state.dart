import 'package:flutter/foundation.dart';

import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/usecases/ayah_by_ayah_use_case.dart';

class AyahByAyahState extends ChangeNotifier {
  final AyahByAyahUseCase _useCase;

  AyahByAyahState(this._useCase);

  final Map<int, List<AyahByAyahEntity>> _pagesCache = {};

  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  /// Получить аяты страницы (из кеша)
  List<AyahByAyahEntity> getPageAyahs(int pageNumber) {
    return _pagesCache[pageNumber] ?? const [];
  }

  /// Проверка: загружена ли страница
  bool isPageLoaded(int pageNumber) {
    return _pagesCache.containsKey(pageNumber);
  }

  /// Загрузка аятов страницы
  Future<void> loadPageAyahs(int pageNumber) async {
    // защита от повторной загрузки
    if (_pagesCache.containsKey(pageNumber)) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _useCase.getAyahsByPage(pageNumber);

      _pagesCache[pageNumber] = result;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Очистка кеша (например при смене перевода)
  void clearCache() {
    _pagesCache.clear();
    notifyListeners();
  }
}