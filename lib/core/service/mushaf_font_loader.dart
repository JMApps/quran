import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../strings/app_strings.dart';

class MushafFontLoader {
  MushafFontLoader({this.maxCachedFonts = 10});

  final int maxCachedFonts;

  final LinkedHashSet<int> _loadedPages = LinkedHashSet<int>();

  final Set<int> _loadingPages = {};

  static const String _fontAssetBase = 'assets/fontpages';

  String fontFamilyForPage(int pageNumber) {
    return 'p$pageNumber.ttf';
  }

  String _fontAssetPath(int pageNumber) {
    return '$_fontAssetBase/p$pageNumber.ttf';
  }

  Future<void> loadPageFont(int pageNumber) async {
    await _loadSingleFont(pageNumber);

    if (pageNumber > 1) {
      _loadSingleFont(pageNumber - 1);
    }
    if (pageNumber < AppStrings.totalPages) {
      _loadSingleFont(pageNumber + 1);
    }

    _evictDistantFonts(pageNumber);
  }

  Future<void> _loadSingleFont(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > AppStrings.totalPages) return;
    if (_loadedPages.contains(pageNumber)) {
      _loadedPages.remove(pageNumber);
      _loadedPages.add(pageNumber);
      return;
    }
    if (_loadingPages.contains(pageNumber)) return;

    _loadingPages.add(pageNumber);

    try {
      final fontLoader = FontLoader(fontFamilyForPage(pageNumber));
      fontLoader.addFont(_loadFontData(pageNumber));
      await fontLoader.load();
      _loadedPages.add(pageNumber);
    } catch (e) {
      debugPrint('MushafFontLoader: Failed to load font for page $pageNumber: $e');
    } finally {
      _loadingPages.remove(pageNumber);
    }
  }

  Future<ByteData> _loadFontData(int pageNumber) async {
    final assetPath = _fontAssetPath(pageNumber);
    return rootBundle.load(assetPath);
  }

  void _evictDistantFonts(int currentPage) {
    while (_loadedPages.length > maxCachedFonts) {
      int? farthestPage;
      int maxDistance = -1;

      for (final page in _loadedPages) {
        final distance = (page - currentPage).abs();
        if (distance > maxDistance) {
          maxDistance = distance;
          farthestPage = page;
        }
      }

      if (farthestPage != null) {
        _loadedPages.remove(farthestPage);
      } else {
        break;
      }
    }
  }

  bool isFontLoaded(int pageNumber) => _loadedPages.contains(pageNumber);

  Future<void> preloadRange(int startPage, int endPage) async {
    final clamped = (
    start: startPage.clamp(1, AppStrings.totalPages),
    end: endPage.clamp(1, AppStrings.totalPages),
    );
    for (int p = clamped.start; p <= clamped.end; p++) {
      await _loadSingleFont(p);
    }
  }
}