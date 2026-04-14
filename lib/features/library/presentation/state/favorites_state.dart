import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/strings/app_constants.dart';
import '../../../../core/strings/app_keys.dart';

class FavoritesState extends ChangeNotifier {
  FavoritesState() {
    _loadPersistedSettings();
  }

  final Box<dynamic> _favoriteSettingsBox = Hive.box(AppKeys.favoriteSettingsBox);

  List<int> _lastPageIds = [];
  List<int> _favoritePageIds = [];
  List<int> _favoriteAyahIds = [];

  List<int> get lastPageIds => List.unmodifiable(_lastPageIds);
  List<int> get favoritePageIds => List.unmodifiable(_favoritePageIds);
  List<int> get favoriteAyahIds => List.unmodifiable(_favoriteAyahIds);

  bool isFavoritePage(int pageNumber) => _favoritePageIds.contains(pageNumber);
  bool isFavoriteAyah(int ayahId) => _favoriteAyahIds.contains(ayahId);

  void _loadPersistedSettings() {
    final List<int> rawLastPages = _favoriteSettingsBox.get(
      AppKeys.keyLastOpenedPages,
      defaultValue: <int>[],
    );
    final List<int> rawFavPages = _favoriteSettingsBox.get(
      AppKeys.keyFavoritePages,
      defaultValue: <int>[],
    );
    final List<int> rawFavAyahs = _favoriteSettingsBox.get(
      AppKeys.keyFavoriteAyahs,
      defaultValue: <int>[],
    );

    _lastPageIds = (rawLastPages as List).cast<int>().take(AppConstants.maxLastOpenedPages).toList();
    _favoritePageIds = (rawFavPages as List).cast<int>().toSet().toList();
    _favoriteAyahIds = (rawFavAyahs as List).cast<int>().toSet().toList();
  }

  Future<void> _persistLastPages() => _favoriteSettingsBox.put(AppKeys.keyLastOpenedPages, _lastPageIds);

  Future<void> _persistFavoritePages() => _favoriteSettingsBox.put(AppKeys.keyFavoritePages, _favoritePageIds);

  Future<void> _persistFavoriteAyahs() => _favoriteSettingsBox.put(AppKeys.keyFavoriteAyahs, _favoriteAyahIds);


  Future<void> addLastOpenedPage(int pageNumber) async {
    _lastPageIds.remove(pageNumber);
    _lastPageIds.insert(0, pageNumber);

    if (_lastPageIds.length > AppConstants.maxLastOpenedPages) {
      _lastPageIds = _lastPageIds.take(AppConstants.maxLastOpenedPages).toList();
    }
    await _persistLastPages();
    notifyListeners();
  }


  Future<void> toggleFavoritePage({required int pageNumber}) async {
    isFavoritePage(pageNumber) ? await _removeFavoritePage(pageNumber) : await _addFavoritePage(pageNumber);
  }

  Future<void> _addFavoritePage(int pageNumber) async {
    if (_favoritePageIds.contains(pageNumber)) return;
    _favoritePageIds = [pageNumber, ..._favoritePageIds];
    await _persistFavoritePages();
    notifyListeners();
  }

  Future<void> _removeFavoritePage(int pageNumber) async {
    if (!_favoritePageIds.contains(pageNumber)) return;
    _favoritePageIds = _favoritePageIds.where((id) => id != pageNumber).toList();
    await _persistFavoritePages();
    notifyListeners();
  }

  Future<void> toggleFavoriteAyah({required int ayahId}) async {
    isFavoriteAyah(ayahId) ? await _removeFavoriteAyah(ayahId) : await _addFavoriteAyah(ayahId);
  }

  Future<void> _addFavoriteAyah(int ayahId) async {
    if (_favoriteAyahIds.contains(ayahId)) return;
    _favoriteAyahIds = [ayahId, ..._favoriteAyahIds];
    await _persistFavoriteAyahs();
    notifyListeners();
  }

  Future<void> _removeFavoriteAyah(int ayahId) async {
    if (!_favoriteAyahIds.contains(ayahId)) return;
    _favoriteAyahIds = _favoriteAyahIds.where((id) => id != ayahId).toList();
    await _persistFavoriteAyahs();
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    await _favoriteSettingsBox.clear();
    _lastPageIds = [];
    _favoritePageIds = [];
    _favoriteAyahIds = [];
    notifyListeners();
  }
}