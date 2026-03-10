import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_strings.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/usecases/surah_name_use_case.dart';

class SurahState extends ChangeNotifier {
  final SurahNameUseCase _surahNameUseCase;

  SurahState(this._surahNameUseCase);

  int _mushafPageIndex = 0;

  set mushafCurrentPageIndex(int pageIndex) {
    if (pageIndex == _mushafPageIndex) return;
    _mushafPageIndex = pageIndex;
    notifyListeners();
  }

  int get currentMushafPage => AppStrings.totalPages - _mushafPageIndex;

  bool _showAppBar = true;

  bool get showAppBar => _showAppBar;

  void toggleShowAppBar() {
    _showAppBar = !_showAppBar;
    notifyListeners();
  }

  List<SurahNameEntity> _allSurahs = const [];
  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<SurahNameEntity> get allSurahs => List.unmodifiable(_allSurahs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  Future<void> loadAllSurahs() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allSurahs = await _surahNameUseCase.getAllSurahs();
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
