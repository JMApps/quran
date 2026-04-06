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
  final Box<dynamic> _favoriteSettingsBox = Hive.box(AppKeys.mushafFavoriteSettingsBox);

  Map<int, MushafPageMetaEntity> _pagesMetaByPage = const {};

  Map<int, AyahByAyahEntity> _ayahMetaById = const {};

  List<int> _lastPageIds = [];
  List<int> _favoritePageIds = [];
  List<int> _favoriteAyahIds = [];

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool _isLoadingAyahs = false;
  bool _isLoadedAyahs = false;
  Object? _errorAyahsList;

  bool _translationState = false;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  Object? get error => _error;

  bool get isLoadingAyahs => _isLoadingAyahs;
  bool get isLoadedAyahs => _isLoadedAyahs;
  Object? get errorAyahsList => _errorAyahsList;

  bool get translationState => _translationState;

  set translationState(bool value) {
    if (_translationState == value) return;
    _translationState = value;
    notifyListeners();
  }

  void _loadPersistedSettings() {
    final dynamic savedLastOpenedPageRaw = _favoriteSettingsBox.get(
      AppKeys.keyLastOpenedPages,
      defaultValue: <int>[1],
    );

    final dynamic savedFavoritePageRaw = _favoriteSettingsBox.get(
      AppKeys.keyFavoritePages,
      defaultValue: <int>[293],
    );

    final dynamic savedFavoriteAyahRaw = _favoriteSettingsBox.get(
      AppKeys.keyFavoriteAyahs,
      defaultValue: <int>[262],
    );

    final List<int> parsedLastOpenedPages = savedLastOpenedPageRaw.take(_maxLastOpenedPages).toList();
    final List<int> parsedFavoritePages = savedFavoritePageRaw.toSet().toList();
    final List<int> parsedFavoriteAyahs = savedFavoriteAyahRaw.toSet().toList();

    _lastPageIds = parsedLastOpenedPages;
    _favoritePageIds = parsedFavoritePages;
    _favoriteAyahIds = parsedFavoriteAyahs;
  }

  Future<void> _saveLastOpenedPages() async {
    await _favoriteSettingsBox.put(
      AppKeys.keyLastOpenedPages,
      _lastPageIds,
    );
  }

  Future<void> _saveFavoritePages() async {
    await _favoriteSettingsBox.put(
      AppKeys.keyFavoritePages,
      _favoritePageIds,
    );
  }

  Future<void> _saveFavoriteAyahs() async {
    await _favoriteSettingsBox.put(
      AppKeys.keyFavoriteAyahs,
      _favoriteAyahIds,
    );
  }

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result = await _mushafPageMetaUseCase.getAllPagesMeta();

      _pagesMetaByPage = {
        for (final item in result) item.pageNumber: item,
      };
      _isLoaded = true;
    } catch (e) {
      _error = e;
      _isLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavoriteAyahsMeta({required String tableName}) async {
    if (_isLoadingAyahs || _isLoadedAyahs) return;

    _isLoadingAyahs = true;
    _errorAyahsList = null;
    notifyListeners();

    try {
      final List<AyahByAyahEntity> result = await _ayahByAyahUseCase.getAyahsByIds(tableName: tableName, ayahIds: _favoriteAyahIds);

      _ayahMetaById = {
        for (final item in result) item.ayahId: item,
      };
      _isLoadedAyahs = true;
    } catch (e) {
      _errorAyahsList = e;
      _isLoadedAyahs = false;
    } finally {
      _isLoadingAyahs = false;
      notifyListeners();
    }
  }

  MushafPageMetaEntity? getPageMetaByPage(int pageNumber) {
    return _pagesMetaByPage[pageNumber];
  }

  List<MushafPageMetaEntity> lastOpenedPages() {
    return _loadPagesMeta(_lastPageIds);
  }

  List<MushafPageMetaEntity> _loadPagesMeta(List<int> pageIds) {
    if (_pagesMetaByPage.isEmpty || pageIds.isEmpty) return const [];
    final List<MushafPageMetaEntity> result = [];

    for (final pageNumber in pageIds) {
      final pageMeta = _pagesMetaByPage[pageNumber];
      if (pageMeta != null) {
        result.add(pageMeta);
      }
    }

    return List.unmodifiable(result);
  }

  List<AyahByAyahEntity> _loadAyahsMeta(List<int> ayahsIds) {
    if (_ayahMetaById.isEmpty || ayahsIds.isEmpty) return const [];
    final List<AyahByAyahEntity> result = [];

    for (final ayahId in ayahsIds) {
      final ayahMeta = _ayahMetaById[ayahId];
      if (ayahMeta != null) {
        result.add(ayahMeta);
      }
    }

    return List.unmodifiable(result);
  }

  Future<void> addLastOpenedPage(int pageNumber) async {
    _lastPageIds.remove(pageNumber);
    _lastPageIds.insert(0, pageNumber);
    while (_lastPageIds.length > _maxLastOpenedPages) {
      _lastPageIds.removeLast();
    }

    await _saveLastOpenedPages();
    notifyListeners();
  }

  List<MushafPageMetaEntity> favoritePages() {
    return _loadPagesMeta(_favoritePageIds);
  }

  List<AyahByAyahEntity> favoriteAyahs() {
    return _loadAyahsMeta(_favoriteAyahIds);
  }

  bool isFavoritePage(int pageNumber) {
    return _favoritePageIds.contains(pageNumber);
  }

  bool isFavoriteAyah(int ayahId) {
    return _favoriteAyahIds.contains(ayahId);
  }

  Future<void> clearAllSettings() async {
    await _favoriteSettingsBox.clear();

    _lastPageIds = [];
    _favoritePageIds = [];
    _favoriteAyahIds = [];

    notifyListeners();
  }

  Future<void> toggleFavoritePage({required int pageNumber}) async {
    if (isFavoritePage(pageNumber)) {
      await _removeFavoritePage(pageNumber: pageNumber);
    } else {
      await _addFavoritePage(pageNumber: pageNumber);
    }
  }

  Future<void> toggleFavoriteAyah({required int ayahId}) async {
    if (isFavoriteAyah(ayahId)) {
      await _removeFavoriteAyah(ayahId: ayahId);
    } else {
      await _addFavoriteAyah(ayahId: ayahId);
    }
  }

  Future<void> _addFavoritePage({required int pageNumber}) async {
    if (_favoritePageIds.contains(pageNumber)) return;
    _favoritePageIds = [..._favoritePageIds, pageNumber];
    await _saveFavoritePages();
    notifyListeners();
  }

  Future<void> _addFavoriteAyah({required int ayahId}) async {
    if (_favoriteAyahIds.contains(ayahId)) return;
    _favoriteAyahIds = [..._favoriteAyahIds, ayahId];
    await _saveFavoriteAyahs();
    notifyListeners();
  }

  Future<void> _removeFavoritePage({required int pageNumber}) async {
    if (!_favoritePageIds.contains(pageNumber)) return;
    _favoritePageIds = _favoritePageIds.where((id) => id != pageNumber).toList();
    await _saveFavoritePages();
    notifyListeners();
  }

  Future<void> _removeFavoriteAyah({required int ayahId}) async {
    if (!_favoriteAyahIds.contains(ayahId)) return;
    _favoriteAyahIds = _favoriteAyahIds.where((id) => id != ayahId).toList();
    await _saveFavoriteAyahs();
    notifyListeners();
  }
}