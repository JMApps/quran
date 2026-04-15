import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_constants.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../settings/state/app_settings_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahByAyahState extends ChangeNotifier {
  final AyahByAyahRepository _ayahByAyahRepository;
  final AppSettingsState _appSettingsState;

  AyahByAyahState(this._ayahByAyahRepository, this._appSettingsState) {
    _appSettingsState.addListener(_onSettingsChanged);
  }

  String get translationsColumn => AppStrings.ayahTranslations[_appSettingsState.translationNameIndex].column;

  void _onSettingsChanged() {
    clearCache();
  }

  final Map<String, List<AyahByAyahEntity>> _pagesCache = {};
  final Map<String, bool> _loadingMap = {};
  final Map<String, Object?> _errorMap = {};
  final Set<String> _inFlight = {};

  String _makeKey({required int pageNumber}) {
    return '$pageNumber';
  }

  List<AyahByAyahEntity> getPageAyahs({required int pageNumber}) {
    final key = _makeKey(pageNumber: pageNumber);
    return _pagesCache[key] ?? const [];
  }

  bool isPageLoaded({required int pageNumber}) {
    final key = _makeKey(pageNumber: pageNumber);
    return _pagesCache.containsKey(key);
  }

  bool isPageLoading({required int pageNumber}) {
    final key = _makeKey(pageNumber: pageNumber);
    return _loadingMap[key] ?? false;
  }

  Object? getPageError({required int pageNumber}) {
    final key = _makeKey(pageNumber: pageNumber);
    return _errorMap[key];
  }

  Future<void> loadPageAyahs({required int pageNumber, bool prefetchNext = true}) async {
    final key = _makeKey(pageNumber: pageNumber);

    if (_pagesCache.containsKey(key)) return;
    if (_inFlight.contains(key)) return;

    _inFlight.add(key);
    _loadingMap[key] = true;
    _errorMap[key] = null;
    notifyListeners();

    try {
      final result = await _ayahByAyahRepository.getAyahsByPage(pageNumber: pageNumber, translationColumn: translationsColumn);

      _pagesCache[key] = result;
    } catch (e) {
      _errorMap[key] = e;
    } finally {
      _inFlight.remove(key);
      _loadingMap[key] = false;
      notifyListeners();
    }

    if (prefetchNext && pageNumber < AppConstants.totalPagesCount) {
      _prefetchPage(pageNumber: pageNumber + 1);
    }
  }

  Future<void> _prefetchPage({required int pageNumber}) async {
    final key = _makeKey(pageNumber: pageNumber);

    if (pageNumber > AppConstants.totalPagesCount) return;
    if (_pagesCache.containsKey(key)) return;
    if (_inFlight.contains(key)) return;

    _inFlight.add(key);
    _errorMap.remove(key);

    try {
      final result = await _ayahByAyahRepository.getAyahsByPage(pageNumber: pageNumber, translationColumn: translationsColumn);
      _pagesCache[key] = result;
    } catch (_) {
      //
    } finally {
      _inFlight.remove(key);
    }
  }
  
  Future<List<AyahByAyahEntity>> searchAyahs({required String query}) {
    return _ayahByAyahRepository.getSearchAyah(query: query, translationColumn: translationsColumn);
  }

  void clearCache() {
    _pagesCache.clear();
    _loadingMap.clear();
    _errorMap.clear();
    _inFlight.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _appSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}