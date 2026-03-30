import 'package:flutter/foundation.dart';

import '../../domain/entities/layout_entity.dart';
import '../../domain/usecases/layout_use_case.dart';

class PageLayoutState extends ChangeNotifier {
  final LayoutUseCase _pageLayoutUseCase;

  PageLayoutState(this._pageLayoutUseCase);

  final Map<int, List<LayoutEntity>> _pagesCache = {};
  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  List<LayoutEntity> getPageLines(int pageNumber) {
    return _pagesCache[pageNumber] ?? const [];
  }

  Future<void> loadPageLines(int pageNumber) async {
    if (_pagesCache.containsKey(pageNumber)) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _pageLayoutUseCase.getLinesByPage(pageNumber: pageNumber);
      _pagesCache[pageNumber] = result;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}