import 'package:flutter/foundation.dart';

import '../../../../core/service/mushaf_font_loader.dart';

class MushafFontState extends ChangeNotifier {
  final MushafFontLoader _loader = MushafFontLoader(maxCachedFonts: 10);

  MushafFontLoader get loader => _loader;

  Future<void> ensureFontLoaded(int pageNumber) async {
    if (_loader.isFontLoaded(pageNumber)) return;
    await _loader.loadPageFont(pageNumber);
    notifyListeners();
  }

  Future<void> onPageChanged(int pageNumber) async {
    await _loader.loadPageFont(pageNumber);
    notifyListeners();
  }

  String? fontFamilyForPage(int pageNumber) {
    if (!_loader.isFontLoaded(pageNumber)) return null;
    return _loader.fontFamilyForPage(pageNumber);
  }

  Future<void> preloadRange(int startPage, int endPage) async {
    _loader.preloadRange(startPage, endPage);
  }
}