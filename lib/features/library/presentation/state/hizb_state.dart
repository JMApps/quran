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

  Object? get error => _error;

  Future<void> loadAllHizbs() async {
    if (_isLoading || _isLoaded) return;

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
}
