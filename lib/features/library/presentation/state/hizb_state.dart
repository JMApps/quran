import 'package:flutter/material.dart';

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

  bool get isLoaded => _isLoaded;

  bool get hasError => _error != null;

  bool get hasData => _allHizbs.isNotEmpty;

  Object? get error => _error;

  Future<void> loadAllHizbs() async {
    if (_isLoading || _isLoaded) return;
    await _load(force: false);
  }

  Future<void> refreshAllHizbs() async {
    await _load(force: true);
  }

  Future<void> _load({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<HizbEntity> result = await _hizbUseCase.getAllHizbs();
      _allHizbs = result;
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _allHizbs = const [];
    _isLoading = false;
    _isLoaded = false;
    _error = null;
    notifyListeners();
  }
}
