import 'package:flutter/services.dart';

class MushafFontLoader {
  MushafFontLoader._();
  static final MushafFontLoader instance = MushafFontLoader._();

  final Set<int> _loadedPages = <int>{};
  final Map<int, Future<void>> _inFlight = <int, Future<void>>{};

  void _validatePage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > 604) {
      throw RangeError(
        'pageNumber must be between 1 and 604, got $pageNumber',
      );
    }
  }

  String familyForPage(int pageNumber) {
    _validatePage(pageNumber);
    return 'QCF_P${pageNumber.toString().padLeft(3, '0')}';
  }

  String assetPathForPage(int pageNumber) {
    _validatePage(pageNumber);
    final fileNumber = 4000 + pageNumber;
    return 'assets/fontpages/QCF${fileNumber}_X-Regular.woff';
  }

  Future<void> loadPageFont(int pageNumber) {
    _validatePage(pageNumber);

    if (_loadedPages.contains(pageNumber)) {
      return Future.value();
    }

    final existing = _inFlight[pageNumber];
    if (existing != null) {
      return existing;
    }

    final future = _load(pageNumber);
    _inFlight[pageNumber] = future;
    return future;
  }

  Future<void> _load(int pageNumber) async {
    try {
      final loader = FontLoader(familyForPage(pageNumber));
      final data = await rootBundle.load(assetPathForPage(pageNumber));

      loader.addFont(Future<ByteData>.value(data));
      await loader.load();

      _loadedPages.add(pageNumber);
    } finally {
      _inFlight.remove(pageNumber);
    }
  }
}