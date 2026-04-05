import 'package:flutter/foundation.dart';

import '../../domain/entities/juz_entity.dart';
import '../../domain/usecases/juz_use_case.dart';

class JuzState extends ChangeNotifier {
  final JuzUseCase _juzUseCase;

  JuzState(this._juzUseCase);

  List<JuzEntity> _allJuzs = const [];
  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<JuzEntity> get allJuzs => List.unmodifiable(_allJuzs);

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  bool get hasError => _error != null;
  bool get hasData => _allJuzs.isNotEmpty;

  Object? get error => _error;

  Future<void> loadAllJuzs() async {
    if (_isLoading || _isLoaded) return;
    await _load(force: false);
  }

  Future<void> refreshAllJuzs() async {
    await _load(force: true);
  }

  Future<void> _load({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<JuzEntity> result = await _juzUseCase.getAllJuzs();
      _allJuzs = result;
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
    _allJuzs = const [];
    _isLoading = false;
    _isLoaded = false;
    _error = null;
    notifyListeners();
  }
}