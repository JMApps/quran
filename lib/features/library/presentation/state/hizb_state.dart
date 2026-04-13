import 'package:flutter/material.dart';

import '../../domain/entities/hizb_entity.dart';
import '../../domain/repositories/hizb_repository.dart';

class HizbState extends ChangeNotifier {
  final HizbRepository _hizbRepository;

  HizbState(this._hizbRepository);

  List<HizbEntity> _allHizbs = const [];
  final Map<int, HizbEntity> _hizbMap = {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<HizbEntity> get allHizbs => List.unmodifiable(_allHizbs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  HizbEntity? getHizbById(int hizbNumber) {
    return _hizbMap[hizbNumber];
  }

  Future<void> loadAllHizbs() => _loadData(force: false);

  Future<void> _loadData({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allHizbs = await _hizbRepository.getAllHizbs();
      _hizbMap..clear()..addEntries(_allHizbs.map((s) => MapEntry(s.hizbNumber, s)));
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllHizbs() => _loadData(force: true);
}
