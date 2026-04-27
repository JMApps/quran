import 'package:flutter/foundation.dart';

import '../../../core/strings/app_constants.dart';
import '../../../core/strings/app_strings.dart';
import '../../settings/state/locale_settings_state.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/repositories/ayah_by_ayah_repository.dart';

class AyahByAyahState extends ChangeNotifier {
  final AyahByAyahRepository _ayahByAyahRepository;
  final LocaleSettingsState _localeSettingsState;

  AyahByAyahState(this._ayahByAyahRepository, this._localeSettingsState) {
    _localeSettingsState.addListener(_onSettingsChanged);
  }

  String get translationsColumn => AppStrings.ayahTranslations[_localeSettingsState.translationNameIndex].column;

  void _onSettingsChanged() => _clearCache();

  final Map<int, List<AyahByAyahEntity>> _ayahsPageCache = {};
  final Map<int, Object?> _errorMap = {};
  final Set<int> _inFlight = {};

  List<AyahByAyahEntity> getPageAyahs({required int pageNumber}) => _ayahsPageCache[pageNumber] ?? const [];
  bool isPageLoaded({required int pageNumber}) => _ayahsPageCache.containsKey(pageNumber);
  Object? isPageError({required int pageNumber}) => _errorMap[pageNumber];

  void loadSelectPageAyahs({required int pageNumber}) {
    _loadPageAyahs(pageNumber: pageNumber);
  }

  void prefetchAround({required int pageNumber}) {
    if (pageNumber > 1) {
      _loadPageAyahs(pageNumber: pageNumber - 1);
    }
    if (pageNumber < AppConstants.totalPagesCount) {
      _loadPageAyahs(pageNumber: pageNumber + 1);
    }
  }

  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) {
    return _ayahByAyahRepository.getSearchAyah(
      query: query,
      translationColumn: translationsColumn,
    );
  }

  void _clearCache() {
    _ayahsPageCache.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }

  Future<void> _loadPageAyahs({required int pageNumber}) async {
    if (_ayahsPageCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _ayahByAyahRepository.getAyahsByPage(
        pageNumber: pageNumber,
        translationColumn: translationsColumn,
      );
      _ayahsPageCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _localeSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}