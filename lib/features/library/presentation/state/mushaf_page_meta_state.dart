import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/strings/app_keys.dart';
import '../../domain/entities/ayah_by_ayah_entity.dart';
import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/usecases/ayah_by_ayah_use_case.dart';
import '../../domain/usecases/mushaf_page_meta_use_case.dart';

class MushafPageMetaState extends ChangeNotifier {
  MushafPageMetaState(this._mushafPageMetaUseCase, this._ayahByAyahUseCase) {
    _loadPersistedSettings();
  }

  static const int _maxLastOpenedPages = 5;

  final MushafPageMetaUseCase _mushafPageMetaUseCase;
  final AyahByAyahUseCase _ayahByAyahUseCase;
  final Box<dynamic> _settingsBox = Hive.box(AppKeys.mushafFavoriteSettingsBox);

  Map<int, MushafPageMetaEntity> _pagesMetaByPage = const {};
  Map<int, AyahByAyahEntity> _ayahMetaById = const {};
  String? _ayahTableName;

  List<int> _lastPageIds = [];
  List<int> _favoritePageIds = [];
  List<int> _favoriteAyahIds = [];

  bool _isLoadingPages = false;
  bool _isLoadedPages = false;
  Object? _errorPages;

  bool _isLoadingAyahs = false;
  bool _isLoadedAyahs = false;
  Object? _errorAyahs;

  bool _translationEnabled = false;

  bool get isLoadingPages => _isLoadingPages;
  Object? get errorPages => _errorPages;

  bool get isLoadingAyahs => _isLoadingAyahs;
  Object? get errorAyahsList => _errorAyahs;

  bool get translationEnabled => _translationEnabled;

  set translationEnabled(bool value) {
    if (_translationEnabled == value) return;
    _translationEnabled = value;
    notifyListeners();
  }

  void _loadPersistedSettings() {
    final dynamic rawLastPages = _settingsBox.get(
      AppKeys.keyLastOpenedPages,
      defaultValue: <int>[1],
    );
    final dynamic rawFavPages = _settingsBox.get(
      AppKeys.keyFavoritePages,
      defaultValue: <int>[293],
    );
    final dynamic rawFavAyahs = _settingsBox.get(
      AppKeys.keyFavoriteAyahs,
      defaultValue: <int>[262],
    );

    _lastPageIds = (rawLastPages as List).cast<int>().take(_maxLastOpenedPages).toList();
    _favoritePageIds = (rawFavPages as List).cast<int>().toSet().toList();
    _favoriteAyahIds = (rawFavAyahs as List).cast<int>().toSet().toList();
  }

  Future<void> _persistLastPages() => _settingsBox.put(AppKeys.keyLastOpenedPages, _lastPageIds);

  Future<void> _persistFavoritePages() => _settingsBox.put(AppKeys.keyFavoritePages, _favoritePageIds);

  Future<void> _persistFavoriteAyahs() => _settingsBox.put(AppKeys.keyFavoriteAyahs, _favoriteAyahIds);

  Future<void> clearAllSettings() async {
    await _settingsBox.clear();
    _lastPageIds = [];
    _favoritePageIds = [];
    _favoriteAyahIds = [];
    notifyListeners();
  }

  Future<void> loadAllPagesMeta() async {
    if (_isLoadingPages || _isLoadedPages) return;

    _isLoadingPages = true;
    _errorPages = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result =
      await _mushafPageMetaUseCase.getAllPagesMeta();

      _pagesMetaByPage = {
        for (final item in result) item.pageNumber: item,
      };
      _isLoadedPages = true;
    } catch (e) {
      _errorPages = e;
      _isLoadedPages = false;
    } finally {
      _isLoadingPages = false;
      notifyListeners();
    }
  }

  Future<void> loadFavoriteAyahsMeta({required String tableName}) async {
    if (_isLoadingAyahs || _isLoadedAyahs) return;

    _ayahTableName = tableName;
    _isLoadingAyahs = true;
    _errorAyahs = null;
    notifyListeners();

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahUseCase.getAyahsByIds(
        tableName: tableName,
        ayahIds: _favoriteAyahIds,
      );

      _ayahMetaById = {
        for (final item in result) item.ayahId: item,
      };
      _isLoadedAyahs = true;
    } catch (e) {
      _errorAyahs = e;
      _isLoadedAyahs = false;
    } finally {
      _isLoadingAyahs = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAndCacheAyah(int ayahId) async {
    if (_ayahTableName == null) return;

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahUseCase.getAyahsByIds(
        tableName: _ayahTableName!,
        ayahIds: [ayahId],
      );

      if (result.isEmpty) return;

      _ayahMetaById = {
        ..._ayahMetaById,
        for (final item in result) item.ayahId: item,
      };
    } catch (_) {
      // Аят не отобразится до следующей полной загрузки — допустимо.
    }
  }

  MushafPageMetaEntity? getPageMetaByPage(int pageNumber) => _pagesMetaByPage[pageNumber];

  List<MushafPageMetaEntity> lastOpenedPages() => _resolvePagesMeta(_lastPageIds);

  List<MushafPageMetaEntity> favoritePages() => _resolvePagesMeta(_favoritePageIds);

  List<MushafPageMetaEntity> _resolvePagesMeta(List<int> pageIds) {
    if (_pagesMetaByPage.isEmpty || pageIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in pageIds)
        if (_pagesMetaByPage.containsKey(id)) _pagesMetaByPage[id]!,
    ]);
  }

  List<AyahByAyahEntity> favoriteAyahs() => _resolveAyahsMeta(_favoriteAyahIds);

  List<AyahByAyahEntity> _resolveAyahsMeta(List<int> ayahIds) {
    if (_ayahMetaById.isEmpty || ayahIds.isEmpty) return const [];

    return List.unmodifiable([
      for (final id in ayahIds)
        if (_ayahMetaById.containsKey(id)) _ayahMetaById[id]!,
    ]);
  }
  bool isFavoritePage(int pageNumber) => _favoritePageIds.contains(pageNumber);

  bool isFavoriteAyah(int ayahId) => _favoriteAyahIds.contains(ayahId);

  Future<void> toggleFavoritePage({required int pageNumber}) async {
    if (isFavoritePage(pageNumber)) {
      await _removeFavoritePage(pageNumber);
    } else {
      await _addFavoritePage(pageNumber);
    }
  }

  Future<void> toggleFavoriteAyah({required int ayahId}) async {
    if (isFavoriteAyah(ayahId)) {
      await _removeFavoriteAyah(ayahId);
    } else {
      await _addFavoriteAyah(ayahId);
    }
  }

  Future<void> _addFavoritePage(int pageNumber) async {
    if (_favoritePageIds.contains(pageNumber)) return;

    _favoritePageIds = [pageNumber, ..._favoritePageIds];
    await _persistFavoritePages();
    notifyListeners();
  }

  Future<void> _addFavoriteAyah(int ayahId) async {
    if (_favoriteAyahIds.contains(ayahId)) return;

    _favoriteAyahIds = [ayahId, ..._favoriteAyahIds];
    await _persistFavoriteAyahs();

    if (_isLoadedAyahs && !_ayahMetaById.containsKey(ayahId)) {
      await _fetchAndCacheAyah(ayahId);
    }

    notifyListeners();
  }

  Future<void> _removeFavoritePage(int pageNumber) async {
    if (!_favoritePageIds.contains(pageNumber)) return;

    _favoritePageIds = _favoritePageIds.where((id) => id != pageNumber).toList();
    await _persistFavoritePages();
    notifyListeners();
  }

  Future<void> _removeFavoriteAyah(int ayahId) async {
    if (!_favoriteAyahIds.contains(ayahId)) return;

    _favoriteAyahIds = _favoriteAyahIds.where((id) => id != ayahId).toList();
    _ayahMetaById = Map.unmodifiable(
      Map.from(_ayahMetaById)..remove(ayahId),
    );
    await _persistFavoriteAyahs();
    notifyListeners();
  }

  Future<void> addLastOpenedPage(int pageNumber) async {
    _lastPageIds..remove(pageNumber)..insert(0, pageNumber);

    while (_lastPageIds.length > _maxLastOpenedPages) {
      _lastPageIds.removeLast();
    }

    await _persistLastPages();
    notifyListeners();
  }

  Future<void> reloadFavoriteAyahsMeta({required String tableName}) async {
    if (_ayahTableName == tableName && _isLoadedAyahs) return;

    _isLoadedAyahs = false;
    _isLoadingAyahs = false;
    _ayahMetaById = const {};
    _ayahTableName = null;

    await loadFavoriteAyahsMeta(tableName: tableName);
  }
}