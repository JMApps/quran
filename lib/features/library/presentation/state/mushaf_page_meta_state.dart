import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/theme/app_keys.dart';
import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../../domain/usecases/mushaf_page_meta_use_case.dart';

class MushafPageMetaState extends ChangeNotifier {
  MushafPageMetaState(this._mushafPageMetaUseCase) {
    _loadPersistedSettings();
  }

  final MushafPageMetaUseCase _mushafPageMetaUseCase;

  final Box _settingsBox = Hive.box(AppKeys.mushafFavoriteSettingsBox);

  List<MushafPageMetaEntity> _allPagesMeta = const [];
  List<int> _lastMushafPageIds = [];
  List<int> _favoriteMushafPageIds = [];

  bool _isLoading = false;
  bool _isLoaded = false;
  Object? _error;

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  Object? get error => _error;

  void _loadPersistedSettings() {
    final List<dynamic>? savedLastOpened = _settingsBox.get(AppKeys.lastOpenedPagesKey) as List<dynamic>?;
    final List<dynamic>? savedFavorite = _settingsBox.get(AppKeys.favoritePagesKey) as List<dynamic>?;

    if (savedLastOpened != null) {
      final List<int> parsedLastOpened = savedLastOpened.whereType<int>().where(_isValidPage).take(3).toList();

      if (parsedLastOpened.isNotEmpty) {
        _lastMushafPageIds = parsedLastOpened;
      }
    }

    if (savedFavorite != null) {
      final List<int> parsedFavorite = savedFavorite.whereType<int>().where(_isValidPage).toSet().toList();

      if (parsedFavorite.isNotEmpty) {
        _favoriteMushafPageIds = parsedFavorite;
      } else {
        _favoriteMushafPageIds = [];
      }
    } else {
      _favoriteMushafPageIds = [];
    }
  }

  Future<void> _saveFavoritePages() async {
    await _settingsBox.put(AppKeys.favoritePagesKey, _favoriteMushafPageIds);
  }

  Future<void> loadAllPagesMeta() async {
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<MushafPageMetaEntity> result =
      await _mushafPageMetaUseCase.getAllPagesMeta();

      _allPagesMeta = result;
      _isLoaded = true;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MushafPageMetaEntity? getPageMetaByPage(int page) {
    if (_allPagesMeta.isEmpty) return null;
    if (!_isValidPage(page)) return null;

    return _allPagesMeta[page - 1];
  }

  List<MushafPageMetaEntity> _loadPagesMeta(List<int> pageIds) {
    if (_allPagesMeta.isEmpty || pageIds.isEmpty) return const [];

    final List<MushafPageMetaEntity> result = [];

    for (final int pageNumber in pageIds) {
      final MushafPageMetaEntity? pageMeta = getPageMetaByPage(pageNumber);
      if (pageMeta != null) {
        result.add(pageMeta);
      }
    }

    return result;
  }

  List<MushafPageMetaEntity> lastOpenedPages() {
    return _loadPagesMeta(_lastMushafPageIds);
  }

  Future<void> addLastOpenedPage(int pageNumber) async {
    if (!_isValidPage(pageNumber)) return;

    _lastMushafPageIds.remove(pageNumber);
    _lastMushafPageIds.insert(0, pageNumber);

    if (_lastMushafPageIds.length > 3) {
      _lastMushafPageIds = _lastMushafPageIds.take(3).toList();
    }

    await _settingsBox.put(AppKeys.lastOpenedPagesKey, _lastMushafPageIds);
    notifyListeners();
  }

  List<MushafPageMetaEntity> favoritePages() {
    return _loadPagesMeta(_favoriteMushafPageIds);
  }

  Future<void> addFavoritePage({required int pageNumber}) async {
    if (!_isValidPage(pageNumber)) return;
    if (_favoriteMushafPageIds.contains(pageNumber)) return;

    _favoriteMushafPageIds.add(pageNumber);
    await _saveFavoritePages();
    notifyListeners();
  }

  Future<void> removeFavoritePage({required int pageNumber}) async {
    _favoriteMushafPageIds.remove(pageNumber);
    await _saveFavoritePages();
    notifyListeners();
  }

  bool isFavoritePage(int pageNumber) {
    return _favoriteMushafPageIds.contains(pageNumber);
  }

  bool _isValidPage(int pageNumber) {
    return pageNumber >= 1 && pageNumber <= 604;
  }
}