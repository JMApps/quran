import 'package:flutter/services.dart';

class MushafFontLoader {
  MushafFontLoader._();
  static final MushafFontLoader instance = MushafFontLoader._();

  final Set<int> _loadedPages = <int>{};
  final Map<int, Future<void>> _inFlight = <int, Future<void>>{};

  String familyForPage(int pageNumber) => 'p$pageNumber';

  Future<void> loadPageFont(int pageNumber) {
    if (_loadedPages.contains(pageNumber)) return Future.value();

    final existing = _inFlight[pageNumber];
    if (existing != null) return existing;

    final future = _load(pageNumber);
    _inFlight[pageNumber] = future;
    return future;
  }

  Future<void> _load(int pageNumber) async {
    try {
      final family = familyForPage(pageNumber);
      final loader = FontLoader(family);

      final data = await rootBundle.load('assets/fontpages/p$pageNumber.ttf');
      loader.addFont(Future.value(data));

      await loader.load();
      _loadedPages.add(pageNumber);
    } finally {
      _inFlight.remove(pageNumber);
    }
  }
}