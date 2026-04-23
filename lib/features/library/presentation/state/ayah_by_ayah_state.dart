import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_constants.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../settings/state/locale_settings_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahByAyahState extends ChangeNotifier {
  final AyahByAyahRepository _ayahByAyahRepository;
  final LocaleSettingsState _localeSettingsState;

  AyahByAyahState(this._ayahByAyahRepository, this._localeSettingsState) {
    _localeSettingsState.addListener(_onSettingsChanged);
  }

  String get translationsColumn => AppStrings.ayahTranslations[_localeSettingsState.translationNameIndex].column;

  void _onSettingsChanged() => clearCache();

  final Map<int, List<AyahByAyahEntity>> _pagesCache = {};
  final Map<int, Object?> _errorMap = {};
  final Set<int> _inFlight = {};

  List<AyahByAyahEntity> getPageAyahs({required int pageNumber}) => _pagesCache[pageNumber] ?? const [];

  bool isPageLoaded({required int pageNumber}) => _pagesCache.containsKey(pageNumber);

  Object? getPageError({required int pageNumber}) => _errorMap[pageNumber];

  Future<void> loadPageAyahs({required int pageNumber}) async {
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _ayahByAyahRepository.getAyahsByPage(
        pageNumber: pageNumber,
        translationColumn: translationsColumn,
      );
      _pagesCache[pageNumber] = result;
    } catch (e) {
      _errorMap[pageNumber] = e;
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  void prefetchAround(int pageNumber) {
    if (pageNumber > 1) {
      _prefetchPage(pageNumber: pageNumber - 1);
    }
    if (pageNumber < AppConstants.totalPagesCount) {
      _prefetchPage(pageNumber: pageNumber + 1);
    }
  }

  Future<void> _prefetchPage({required int pageNumber}) async {
    if (_pagesCache.containsKey(pageNumber)) return;
    if (_inFlight.contains(pageNumber)) return;

    _inFlight.add(pageNumber);

    try {
      final result = await _ayahByAyahRepository.getAyahsByPage(
        pageNumber: pageNumber,
        translationColumn: translationsColumn,
      );
      _pagesCache[pageNumber] = result;
    } catch (_) {
      // prefetch ошибки не пробрасываем
    } finally {
      _inFlight.remove(pageNumber);
      notifyListeners();
    }
  }

  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) {
    return _ayahByAyahRepository.getSearchAyah(
      query: query,
      translationColumn: translationsColumn,
    );
  }

  void clearCache() {
    _pagesCache.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _localeSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}