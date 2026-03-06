import 'package:flutter/foundation.dart';

import '../../domain/entities/hizb_entity.dart';
import '../../domain/usecases/hizb_use_case.dart';

class HizbState extends ChangeNotifier {
  final HizbUseCase _hizbUseCase;

  HizbState(this._hizbUseCase);

  List<HizbEntity> _allHizbs = const [];
  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<HizbEntity> get allHizbs => List.unmodifiable(_allHizbs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> loadAllHizbs() async {
    if (_isLoaded || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allHizbs = await _hizbUseCase.getAllHizbs();
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  HizbEntity? getHizbByPage(int pageNumber) {
    for (final hizb in _allHizbs) {
      if (hizb.startPageNumber == pageNumber) {
        return hizb;
      }
    }
    return null;
  }
}
