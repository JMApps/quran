import 'package:flutter/services.dart';
import 'package:flutter/services.dart' as ui;

class MushafFontLoader {
  MushafFontLoader._();

  static final MushafFontLoader instance = MushafFontLoader._();

  final Map<int, Future<String>> _cache = {};

  Future<String> ensureLoaded(int pageNumber) {
    return _cache.putIfAbsent(pageNumber, () async {
      final family = 'mushaf_page_$pageNumber';

      final assetPath = 'assets/fontpages/p$pageNumber.ttf';

      final loader = ui.FontLoader(family);
      loader.addFont(rootBundle.load(assetPath));

      await loader.load();

      return family;
    });
  }
}