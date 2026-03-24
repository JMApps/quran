import 'package:flutter/foundation.dart';

import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/usecases/mushaf_page_meta_use_case.dart';

class MushafPageMetaState extends ChangeNotifier {
  final MushafPageMetaUseCase _mushafPageMetaUseCase;

  MushafPageMetaState(this._mushafPageMetaUseCase);

  List<MushafPageMetaEntity> _allPagesMeta = const [];
  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  Object? get error => _error;

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result =
      await _mushafPageMetaUseCase.getAllPagesMeta();

      _allPagesMeta = result;
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MushafPageMetaEntity? getPageMetaByPageNumber(int mushafPageIndex) {
    if (_allPagesMeta.isEmpty) return null;
    if (mushafPageIndex < 0 || mushafPageIndex >= _allPagesMeta.length) return null;

    return _allPagesMeta[mushafPageIndex];
  }

  List<MushafPageMetaEntity> loadFavoritePagesMeta(List<int> pageIds) {
    if (_allPagesMeta.isEmpty || pageIds.isEmpty) return const [];

    final List<MushafPageMetaEntity> result = [];

    for (final int pageId in pageIds) {
      final MushafPageMetaEntity? pageMeta = getPageMetaByPageNumber(pageId);
      if (pageMeta != null) {
        result.add(pageMeta);
      }
    }

    return result;
  }
}