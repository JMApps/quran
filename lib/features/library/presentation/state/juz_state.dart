import 'package:flutter/foundation.dart';

import '../../domain/entities/juz_entity.dart';
import '../../domain/usecases/juz_use_case.dart';

class JuzState extends ChangeNotifier {
  final JuzUseCase _juzUseCase;

  JuzState(this._juzUseCase) {
    loadAllJuzs();
  }

  List<JuzEntity> _allJuzs = const [];
  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<JuzEntity> get allJuzs => List.unmodifiable(_allJuzs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> loadAllJuzs() async {
    if (_isLoaded || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allJuzs = await _juzUseCase.getAllJuzs();
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  JuzEntity? getJuzByPage(int pageNumber) {
    JuzEntity? result;

    for (final juz in _allJuzs) {
      if (juz.startPageNumber <= pageNumber) {
        result = juz;
      } else {
        break;
      }
    }

    return result;
  }
}
