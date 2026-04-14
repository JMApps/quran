import 'package:flutter/foundation.dart';

import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/repositories/ayah_by_ayah_repository.dart';

class AyahMetaState extends ChangeNotifier {
  AyahMetaState(this._ayahByAyahRepository);

  final AyahByAyahRepository _ayahByAyahRepository;

  Map<int, AyahByAyahEntity> _ayahMetaById = const {};
  String? _loadedTableName;

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool get isLoading => _isLoading;
  Object? get error => _error;

  Future<void> loadAyahsMeta({required String tableName, required List<int> ayahIds}) async {
    if (_isLoading) return;
    if (_isLoaded && _loadedTableName == tableName) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahRepository.getAyahsByIds(
        tableName: tableName,
        ayahIds: ayahIds,
      );
      _ayahMetaById = {
        for (final item in result) item.ayahId: item,
      };
      _loadedTableName = tableName;
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadIfTableChanged({required String tableName, required List<int> ayahIds}) async {
    if (_loadedTableName == tableName && _isLoaded) return;
    _isLoaded = false;
    _loadedTableName = null;
    _ayahMetaById = const {};
    await loadAyahsMeta(tableName: tableName, ayahIds: ayahIds);
  }

  List<AyahByAyahEntity> resolveAyahs(List<int> ayahIds) {
    if (_ayahMetaById.isEmpty || ayahIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in ayahIds)
        if (_ayahMetaById.containsKey(id)) _ayahMetaById[id]!,
    ]);
  }

  Future<void> fetchAndCacheAyah({required int ayahId, required String tableName}) async {
    if (_ayahMetaById.containsKey(ayahId)) return;

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahRepository.getAyahsByIds(
        tableName: tableName,
        ayahIds: [ayahId],
      );
      if (result.isEmpty) return;
      _ayahMetaById = {
        ..._ayahMetaById,
        for (final item in result) item.ayahId: item,
      };
      notifyListeners();
    } catch (_) {}
  }
}