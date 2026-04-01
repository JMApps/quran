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
    if (_pagesCache.containsKey(pageNumber)) {
      print('Page $pageNumber already cached: ${_pagesCache[pageNumber]!.length}');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _pageLayoutUseCase.getLinesByPage(pageNumber: pageNumber);
      print('Loaded page $pageNumber: ${result.length} lines');
      for (final line in result.take(3)) {
        print('STATE LINE => ${line.lineNumber} | "${line.lineText}" | "${line.surahNameText}"');
      }
      _pagesCache[pageNumber] = result;
    } catch (e) {
      _error = e;
      print('ERROR loadPageLines($pageNumber): $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}