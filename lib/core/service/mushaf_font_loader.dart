import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../strings/app_strings.dart';

/// Загрузчик шрифтов страниц Мусхафа.
///
/// Стратегия:
/// - Текущая страница загружается с максимальным приоритетом (awaited).
/// - Соседние страницы ([±kHighPriorityRange]) стартуют параллельно сразу,
///   не ожидая завершения текущей.
/// - Дальние страницы ([±kLowPriorityRange]) — «fire and forget» prefetch.
/// - Eviction удаляет самые дальние страницы, сохраняя [maxCachedFonts] в LRU.
/// - Примечание: Flutter не поддерживает выгрузку зарегистрированных шрифтов
///   из engine, поэтому eviction обновляет только внутренний учёт — шрифты
///   остаются в engine до завершения isolate. Размер кэша влияет на логику
///   повторных загрузок, но не на потребление native-памяти.
class MushafFontLoader {
  MushafFontLoader({
    this.maxCachedFonts = 20,
    this.highPriorityRange = 2,
    this.lowPriorityRange = 4,
  });

  /// Максимум страниц в LRU-учёте.
  final int maxCachedFonts;

  /// Страницы в радиусе [highPriorityRange] от текущей грузятся параллельно
  /// сразу, вместе с текущей.
  final int highPriorityRange;

  /// Страницы в радиусе [lowPriorityRange] (за пределами highPriorityRange)
  /// грузятся как фоновый prefetch.
  final int lowPriorityRange;

  static const String _fontAssetBase = 'assets/fontpages';

  /// LRU-учёт: последний элемент — самый свежий.
  final LinkedHashSet<int> _loadedPages = LinkedHashSet<int>();

  /// Страницы, чьи Future уже запущены (защита от дублирования).
  final Map<int, Future<void>> _inFlight = {};

  // ─────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────

  /// Возвращает имя font-family для страницы, если шрифт загружен.
  String fontFamilyForPage(int pageNumber) => 'p$pageNumber.ttf';

  /// Шрифт страницы уже загружен и зарегистрирован в engine.
  bool isFontLoaded(int pageNumber) => _loadedPages.contains(pageNumber);

  /// Основной метод: загружает текущую страницу + параллельный prefetch.
  ///
  /// Возвращается, когда шрифт [pageNumber] точно зарегистрирован.
  /// Соседние страницы грузятся в фоне без блокировки.
  Future<void> loadPageFont(int pageNumber, {bool isDirectionForward = true}) async {
    // 1. Текущую страницу — с ожиданием.
    await _loadSingle(pageNumber);

    // 2. Высокоприоритетные соседи — параллельно, без await.
    //    Стартуем все сразу, не ждём друг друга.
    _schedulePrefetch(
      pageNumber: pageNumber,
      isForward: isDirectionForward,
      range: highPriorityRange,
    );

    // 3. Дальний prefetch — тоже параллельно, в фоне.
    _schedulePrefetch(
      pageNumber: pageNumber,
      isForward: isDirectionForward,
      range: lowPriorityRange,
      startFrom: highPriorityRange + 1,
    );

    // 4. Eviction: убрать из LRU самые дальние страницы.
    _evictDistant(currentPage: pageNumber);
  }

  /// Загружает диапазон страниц параллельно.
  /// Используется при первом открытии ридера для быстрой preload-инициализации.
  Future<void> preloadRange(int startPage, int endPage) {
    final start = startPage.clamp(1, AppStrings.totalPages);
    final end = endPage.clamp(1, AppStrings.totalPages);
    if (start > end) return Future.value();

    // Все страницы диапазона стартуют одновременно.
    final futures = <Future<void>>[];
    for (int p = start; p <= end; p++) {
      futures.add(_loadSingle(p));
    }
    return Future.wait(futures, eagerError: false);
  }

  // ─────────────────────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────────────────────

  /// Запускает prefetch для страниц вокруг [pageNumber].
  ///
  /// [isForward] — направление листания (вперёд по тексту).
  /// При forward читатель скорее пойдёт на следующие страницы,
  /// поэтому их prefetch приоритетнее.
  void _schedulePrefetch({
    required int pageNumber,
    required bool isForward,
    required int range,
    int startFrom = 1,
  }) {
    for (int delta = startFrom; delta <= range; delta++) {
      // Направление вперёд грузим первыми (приоритет).
      final forward = isForward ? pageNumber + delta : pageNumber - delta;
      final backward = isForward ? pageNumber - delta : pageNumber + delta;

      if (_isValid(forward)) _loadSingle(forward); // fire and forget
      if (_isValid(backward)) _loadSingle(backward); // fire and forget
    }
  }

  /// Загружает один шрифт. Идемпотентен: повторные вызовы для той же
  /// страницы возвращают уже запущенный Future (deduplication).
  Future<void> _loadSingle(int pageNumber) {
    if (!_isValid(pageNumber)) return Future.value();

    // Уже загружен — обновить LRU-позицию и вернуться.
    if (_loadedPages.contains(pageNumber)) {
      _touchLru(pageNumber);
      return Future.value();
    }

    // Уже загружается — вернуть тот же Future.
    final existing = _inFlight[pageNumber];
    if (existing != null) return existing;

    // Запустить новую загрузку.
    final future = _doLoad(pageNumber);
    _inFlight[pageNumber] = future;
    return future;
  }

  Future<void> _doLoad(int pageNumber) async {
    try {
      final fontLoader = FontLoader(fontFamilyForPage(pageNumber));
      fontLoader.addFont(_readAsset(pageNumber));
      await fontLoader.load();
      _loadedPages.add(pageNumber);
    } catch (e) {
      debugPrint('MushafFontLoader: page $pageNumber failed — $e');
    } finally {
      _inFlight.remove(pageNumber);
    }
  }

  /// Читает байты шрифта из assets.
  /// rootBundle кэширует данные внутри себя, повторное чтение быстрое.
  Future<ByteData> _readAsset(int pageNumber) {
    return rootBundle.load('$_fontAssetBase/p$pageNumber.ttf');
  }

  /// Обновляет LRU-позицию уже загруженной страницы.
  void _touchLru(int pageNumber) {
    _loadedPages.remove(pageNumber);
    _loadedPages.add(pageNumber);
  }

  /// Удаляет из LRU-учёта самые дальние страницы,
  /// пока размер не станет ≤ [maxCachedFonts].
  void _evictDistant({required int currentPage}) {
    if (_loadedPages.length <= maxCachedFonts) return;

    // Собираем страницы, отсортированные по убыванию расстояния.
    final sorted = _loadedPages.toList()
      ..sort((a, b) =>
          (b - currentPage).abs().compareTo((a - currentPage).abs()));

    while (_loadedPages.length > maxCachedFonts && sorted.isNotEmpty) {
      _loadedPages.remove(sorted.removeAt(0));
    }
  }

  bool _isValid(int pageNumber) =>
      pageNumber >= 1 && pageNumber <= AppStrings.totalPages;
}