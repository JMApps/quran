import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_locale.dart';
import '../../../settings/state/locale_settings_state.dart';
import '../../domain/entities/surah_name_entity.dart';
import '../../domain/repositories/surah_name_repository.dart';

class SurahNameState extends ChangeNotifier {
  final SurahNameRepository _surahNameRepository;
  final LocaleSettingsState _localeSettingsState;

  SurahNameState(this._surahNameRepository, this._localeSettingsState) {
    _localeSettingsState.addListener(_onSettingsChanged);
  }

  List<SurahNameEntity> _allSurahs = const [];
  final Map<int, SurahNameEntity> _surahMap = {};

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  List<SurahNameEntity> get allSurahs => List.unmodifiable(_allSurahs);

  bool get isLoading => _isLoading;

  Object? get error => _error;

  SurahNameEntity? getSurahByNumber({required int surahNumber}) {
    return _surahMap[surahNumber];
  }

  String getSurahNameWithAyah({required String surah, required String ayah, required String verseKey}) {
    final parts = verseKey.split(':');
    final surahNumber = int.parse(parts[0]);
    final ayahNumber = int.parse(parts[1]);
    final surahModel = _surahMap[surahNumber];
    if (surahModel == null) {
      return '$surah $surahNumber, $ayah $ayahNumber';
    }
    return '$surah ${surahModel.nameTranscription}, $ayah $ayahNumber';
  }

  Future<void> loadAllSurahNames() => _loadData(force: false);

  Future<void> _loadData({required bool force}) async {
    if (_isLoading) return;
    if (!force && _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allSurahs = await _surahNameRepository.getAllSurahs(languageCode: AppLocale.appLocales[_localeSettingsState.appLocaleIndex].languageCode);
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

  Future<void> refreshAllSurahs() => _loadData(force: true);

  void _onSettingsChanged() {
    refreshAllSurahs();
    notifyListeners();
  }

  @override
  void dispose() {
    _localeSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
