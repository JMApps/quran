import 'package:flutter/foundation.dart';
import 'package:quran/core/strings/app_locale.dart';

import '../../../settings/state/app_settings_state.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  final SurahNameRepository _surahNameRepository;
  final AppSettingsState _appSettingsState;

  SurahNameState(this._surahNameRepository, this._appSettingsState) {
    _appSettingsState.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    refreshAllSurahs();
    notifyListeners();
  }

  int _pageNumber = 1;
  bool _showAppBar = true;

  List<SurahNameEntity> _allSurahs = const [];
  final Map<int, SurahNameEntity> _surahMap = {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  int get currentPage => _pageNumber;

  bool get showAppBar => _showAppBar;

  List<SurahNameEntity> get allSurahs => List.unmodifiable(_allSurahs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  void toggleShowAppBar() {
    _showAppBar = !_showAppBar;
    notifyListeners();
  }

  SurahNameEntity? getSurahById({required int surahNumber}) {
    return _surahMap[surahNumber];
  }

  String getSurahNameWithAyah({required String surah, required String ayah, required String verseKey}) {
    final parts = verseKey.split(':');
    final surahNumber = int.parse(parts[0]);
    final ayahNumber = int.parse(parts[1]);

    return '$surah ${_surahMap[surahNumber]!.nameTranscription}, $ayah $ayahNumber';
  }

  Future<void> loadAllSurahNames() => _loadData(force: false);

  Future<void> _loadData({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allSurahs = await _surahNameRepository.getAllSurahs(languageCode: AppLocale.appLocales[_appSettingsState.getAppLocaleIndex].languageCode);
      _surahMap..clear()..addEntries(_allSurahs.map((s) => MapEntry(s.surahNumber, s)));
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentPage(int page) {
    if (_pageNumber == page) return;
    _pageNumber = page;
    notifyListeners();
  }

  Future<void> refreshAllSurahs() => _loadData(force: true);

  @override
  void dispose() {
    _appSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
