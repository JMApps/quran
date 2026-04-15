import 'package:flutter/foundation.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../settings/state/app_settings_state.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahMetaState extends ChangeNotifier {
  final AyahByAyahRepository _ayahByAyahRepository;
  final AppSettingsState _appSettingsState;

  AyahMetaState(this._ayahByAyahRepository, this._appSettingsState) {
    _appSettingsState.addListener(_onSettingsChanged);
  }

  String get translationsColumn => AppStrings.ayahTranslations[_appSettingsState.translationNameIndex].column;

  void _onSettingsChanged() {
    _ayahMetaById = const {};
    notifyListeners();
  }

  Map<int, AyahByAyahEntity> _ayahMetaById = const {};

  bool _isLoading = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> loadAyahsMeta({required List<int> ayahIds}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahRepository.getAyahsByIds(ayahIds: ayahIds, translationColumn: translationsColumn);
      _ayahMetaById = {
        for (final item in result) item.ayahId: item,
      };
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadIfTableChanged({required List<int> ayahIds}) async {
    _ayahMetaById = const {};
    await loadAyahsMeta(ayahIds: ayahIds);
  }

  List<AyahByAyahEntity> resolveAyahs(List<int> ayahIds) {
    if (_ayahMetaById.isEmpty || ayahIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in ayahIds)
        if (_ayahMetaById.containsKey(id)) _ayahMetaById[id]!,
    ]);
  }

  Future<void> syncFavoriteAyahs({required List<int> ayahIds}) async {
    if (ayahIds.isEmpty) {
      _ayahMetaById = const {};
      notifyListeners();
      return;
    }

    final ayahIdsSet = ayahIds.toSet();
    final hasStale = _ayahMetaById.keys.any((id) => !ayahIdsSet.contains(id));
    if (hasStale) {
      _ayahMetaById = {
        for (final entry in _ayahMetaById.entries)
          if (ayahIdsSet.contains(entry.key)) entry.key: entry.value,
      };
      notifyListeners();
    }

    final missingIds = ayahIds.where((id) => !_ayahMetaById.containsKey(id)).toList();
    if (missingIds.isEmpty) return;

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahRepository.getAyahsByIds(ayahIds: missingIds, translationColumn: translationsColumn);
      _ayahMetaById = {
        ..._ayahMetaById,
        for (final item in result) item.ayahId: item,
      };
      notifyListeners();
    } catch (e) {
      _error = e;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _appSettingsState.removeListener(_onSettingsChanged);
    super.dispose();
  }
}