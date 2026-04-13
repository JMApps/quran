import 'package:flutter/foundation.dart';

import '../../domain/entities/juz_entity.dart';
import '../../domain/repositories/juz_repository.dart';

class JuzState extends ChangeNotifier {
  final JuzRepository _juzRepository;

  JuzState(this._juzRepository);

  List<JuzEntity> _allJuzs = const [];
  final Map<int, JuzEntity> _juzMap = {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<JuzEntity> get allJuzs => List.unmodifiable(_allJuzs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  JuzEntity? getJuzById(int juzNumber) {
    return _juzMap[juzNumber];
  }

  Future<void> loadAllJuzs() => _loadData(force: false);

  Future<void> _loadData({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allJuzs = await _juzRepository.getAllJuzs();
      _juzMap..clear()..addEntries(_allJuzs.map((s) => MapEntry(s.juzNumber, s)));
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAllJuzs() => _loadData(force: true);
}
