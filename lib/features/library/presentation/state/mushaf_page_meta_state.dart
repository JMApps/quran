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

  List<MushafPageMetaEntity> get allPagesMeta => List.unmodifiable(_allPagesMeta);
  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allPagesMeta = await _mushafPageMetaUseCase.getAllPagesMeta();
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MushafPageMetaEntity? getPageMetaByPageNumber(int pageNumber) {
    if (_allPagesMeta.isEmpty) return null;
    if (pageNumber < 1 || pageNumber > _allPagesMeta.length) return null;

    return _allPagesMeta[pageNumber - 1];
  }
}