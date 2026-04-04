import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/strings/app_keys.dart';
import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/usecases/mushaf_page_meta_use_case.dart';

class MushafPageMetaState extends ChangeNotifier {
  MushafPageMetaState(this._mushafPageMetaUseCase) {
    _loadPersistedSettings();
  }

  static const int _maxLastOpenedPages = 3;

  final MushafPageMetaUseCase _mushafPageMetaUseCase;
  final Box<dynamic> _favoriteSettingsBox =
  Hive.box(AppKeys.mushafFavoriteSettingsBox);

  List<MushafPageMetaEntity> _allPagesMeta = const [];
  Map<int, MushafPageMetaEntity> _pagesMetaByPage = const {};

  List<int> _lastMushafPageIds = [];
  List<int> _favoriteMushafPageIds = [];

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool _translationState = false;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  Object? get error => _error;
  bool get translationState => _translationState;

  List<MushafPageMetaEntity> get allPagesMeta => List.unmodifiable(_allPagesMeta);
  List<int> get lastMushafPageIds => List.unmodifiable(_lastMushafPageIds);
  List<int> get favoriteMushafPageIds => List.unmodifiable(_favoriteMushafPageIds);

  set translationState(bool value) {
    if (_translationState == value) return;
    _translationState = value;
    notifyListeners();
  }

  void _loadPersistedSettings() {
    final dynamic savedLastOpenedRaw = _favoriteSettingsBox.get(
      AppKeys.keyLastOpenedPages,
      defaultValue: <int>[1],
    );

    final dynamic savedFavoriteRaw = _favoriteSettingsBox.get(
      AppKeys.keyFavoritePages,
      defaultValue: <int>[293],
    );

    final List<int> parsedLastOpened = _parsePageList(savedLastOpenedRaw).take(_maxLastOpenedPages).toList();

    final List<int> parsedFavorite =
    _parsePageList(savedFavoriteRaw).toSet().toList();

    _lastMushafPageIds = parsedLastOpened.isNotEmpty ? parsedLastOpened : <int>[1];
    _favoriteMushafPageIds = parsedFavorite;
  }

  List<int> _parsePageList(dynamic raw) {
    if (raw is! List) return [];

    return raw.whereType<int>().where(_isValidPage).toList();
  }

  Future<void> _saveFavoritePages() async {
    await _favoriteSettingsBox.put(
      AppKeys.keyFavoritePages,
      _favoriteMushafPageIds,
    );
  }

  Future<void> _saveLastOpenedPages() async {
    await _favoriteSettingsBox.put(
      AppKeys.keyLastOpenedPages,
      _lastMushafPageIds,
    );
  }

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result =
      await _mushafPageMetaUseCase.getAllPagesMeta();

      _allPagesMeta = List.unmodifiable(result);
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

  Future<void> reloadAllPagesMeta() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result =
      await _mushafPageMetaUseCase.getAllPagesMeta();

      _allPagesMeta = List.unmodifiable(result);
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

  MushafPageMetaEntity? getPageMetaByPage(int pageNumber) {
    if (!_isValidPage(pageNumber)) return null;
    return _pagesMetaByPage[pageNumber];
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

  List<MushafPageMetaEntity> lastOpenedPages() {
    return _loadPagesMeta(_lastMushafPageIds);
  }

  Future<void> addLastOpenedPage(int pageNumber) async {
    if (!_isValidPage(pageNumber)) return;

    _lastMushafPageIds.remove(pageNumber);
    _lastMushafPageIds.insert(0, pageNumber);

    while (_lastMushafPageIds.length > _maxLastOpenedPages) {
      _lastMushafPageIds.removeLast();
    }

    await _saveLastOpenedPages();
    notifyListeners();
  }

  List<MushafPageMetaEntity> favoritePages() {
    return _loadPagesMeta(_favoriteMushafPageIds);
  }

  Future<void> addFavoritePage({required int pageNumber}) async {
    if (!_isValidPage(pageNumber)) return;
    if (_favoriteMushafPageIds.contains(pageNumber)) return;

    _favoriteMushafPageIds = [..._favoriteMushafPageIds, pageNumber];
    await _saveFavoritePages();
    notifyListeners();
  }

  Future<void> removeFavoritePage({required int pageNumber}) async {
    if (!_favoriteMushafPageIds.contains(pageNumber)) return;

    _favoriteMushafPageIds =
        _favoriteMushafPageIds.where((id) => id != pageNumber).toList();

    await _saveFavoritePages();
    notifyListeners();
  }

  bool isFavoritePage(int pageNumber) {
    return _favoriteMushafPageIds.contains(pageNumber);
  }

  void clearMetaCache() {
    _allPagesMeta = const [];
    _pagesMetaByPage = const {};
    _isLoading = false;
    _isLoaded = false;
    _error = null;
    notifyListeners();
  }

  bool _isValidPage(int pageNumber) {
    return pageNumber >= 1 && pageNumber <= AppStrings.totalPages;
  }
}