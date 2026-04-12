import 'package:flutter/foundation.dart';

import '../../../../core/service/mushaf_font_loader.dart';

/// State-обёртка над [MushafFontLoader].
///
/// Хранит направление листания для оптимального prefetch и вызывает
/// [notifyListeners] только тогда, когда шрифт текущей страницы
/// действительно стал доступен (т.е. страница должна перерисоваться).
class MushafFontState extends ChangeNotifier {
  MushafFontState()
      : _loader = MushafFontLoader(
    // Держим в LRU-учёте до 20 страниц.
    // Шрифты ±4 вокруг текущей будут уже готовы до того,
    // как пользователь до них доберётся.
    maxCachedFonts: 20,
    highPriorityRange: 2, // параллельный prefetch ±2
    lowPriorityRange: 4,  // фоновый prefetch ±4
  );

  final MushafFontLoader _loader;

  /// Направление последнего листания.
  /// true = вперёд по тексту Корана (уменьшение номера страницы в UI, т.к. reverse: true).
  bool _lastDirectionForward = true;

  // ─────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────

  /// Имя font-family для страницы, если шрифт уже загружен.
  /// Возвращает null, пока шрифт не готов.
  String? fontFamilyForPage(int pageNumber) {
    if (!_loader.isFontLoaded(pageNumber)) return null;
    return _loader.fontFamilyForPage(pageNumber);
  }

  /// Гарантирует, что шрифт [pageNumber] загружен.
  /// Вызывается из [MushafPageWidget] как fallback-проверка.
  /// После загрузки уведомляет слушателей, чтобы страница перерисовалась.
  Future<void> ensureFontLoaded(int pageNumber) async {
    if (_loader.isFontLoaded(pageNumber)) return;
    await _loader.loadPageFont(pageNumber, isDirectionForward: _lastDirectionForward);
    notifyListeners();
  }

  /// Вызывается при смене страницы в [SurahDetailList.onPageChanged].
  ///
  /// 1. Запоминает направление листания.
  /// 2. Запускает загрузку текущей страницы + параллельный prefetch.
  /// 3. Уведомляет слушателей, если шрифт текущей страницы стал готов.
  Future<void> onPageChanged(int pageNumber, {required bool isForward}) async {
    _lastDirectionForward = isForward;

    final wasLoaded = _loader.isFontLoaded(pageNumber);
    // loadPageFont: текущая страница — с ожиданием, prefetch — параллельно.
    await _loader.loadPageFont(pageNumber, isDirectionForward: isForward);
    if (!wasLoaded) notifyListeners();
  }

  /// Предзагружает диапазон страниц при открытии ридера.
  /// Все страницы грузятся параллельно.
  Future<void> preloadRange(int startPage, int endPage) async {
    await _loader.preloadRange(startPage, endPage);
    notifyListeners();
  }
}