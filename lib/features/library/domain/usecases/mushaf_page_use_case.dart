import '../entities/ayah_word_entity.dart';
import '../entities/layout_entity.dart';
import '../entities/line_type.dart';
import '../entities/mushaf_page_entity.dart';
import 'ayah_word_use_case.dart';
import 'juz_use_case.dart';
import 'layout_use_case.dart';
import 'surah_name_use_case.dart';

class BuildMushafPageUseCase {
  final LayoutUseCase _layoutUseCase;
  final AyahWordUseCase _ayahWordUseCase;
  final SurahNameUseCase _surahNameUseCase;
  final JuzUseCase _juzUseCase;

  const BuildMushafPageUseCase(
      this._layoutUseCase,
      this._ayahWordUseCase,
      this._surahNameUseCase,
      this._juzUseCase,
      );

  Future<MushafPageEntity> execute({required int pageNumber}) async {
    final layouts = await _layoutUseCase.getLinesByPage(pageNumber: pageNumber);

    // 1) Подтягиваем все глифы страницы одним запросом (по min/max id из layout)
    final range = _calcWordRange(layouts);
    final List<AyahWordEntity> words = (range == null)
        ? const <AyahWordEntity>[]
        : await _ayahWordUseCase.getWordsByRange(
      fromId: range.$1,
      toId: range.$2,
    );

    // Быстрый доступ по id
    final Map<int, AyahWordEntity> wordsById = {
      for (final w in words) w.id: w
    };

    // 2) Кэш имен сур (чтобы не делать N запросов)
    final Map<int, String> surahNameCache = {};

    // 3) Номер суры для заголовка страницы (берем первый попавшийся в разметке)
    final int? pageSurahNumber = _pickFirstSurahNumber(layouts);

    // 4) Имя суры (перевод) для страницы
    String pageSurahName = '';
    if (pageSurahNumber != null) {
      pageSurahName = await _getSurahNameCached(
        surahNumber: pageSurahNumber,
        cache: surahNameCache,
      );
    }

    // 5) Номер джуза для страницы
    final juz = await _juzUseCase.getJuzByPage(pageNumber: pageNumber);
    final int pageJuzNumber = juz?.juzNumber ?? 0;

    // 6) Собираем строки
    final lines = <MushafLineEntity>[];

    for (final l in layouts) {
      switch (l.lineType) {
        case LineType.basmallah:
          lines.add(
            const MushafLineEntity(
              type: LineType.basmallah,
              text: '﷽',
              isCentered: true,
            ),
          );
          break;

        case LineType.surahName:
          final n = l.surahNumber;
          final surahName = (n == null)
              ? ''
              : await _getSurahNameCached(
            surahNumber: n,
            cache: surahNameCache,
          );

          lines.add(
            MushafLineEntity(
              type: LineType.surahName,
              text: surahName,
              isCentered: true,
            ),
          );
          break;

        case LineType.ayah:
          final text = _buildAyahLineText(
            firstWordId: l.firstWordId,
            lastWordId: l.lastWordId,
            wordsById: wordsById,
          );

          lines.add(
            MushafLineEntity(
              type: LineType.ayah,
              text: text,
              isCentered: l.isCentered,
            ),
          );
          break;
      }
    }

    // 7) Возвращаем страницу без хардкода
    return MushafPageEntity(
      pageNumber: pageNumber,
      surahName: pageSurahName,
      juzNumber: pageJuzNumber,
      lines: lines,
    );
  }

  // -----------------------------
  // Helpers
  // -----------------------------

  /// Возвращает (minId, maxId) для всей страницы.
  (int, int)? _calcWordRange(List<LayoutEntity> layouts) {
    int? minId;
    int? maxId;

    for (final l in layouts) {
      final a = l.firstWordId;
      final b = l.lastWordId;
      if (a == null || b == null) continue;

      final lo = a < b ? a : b;
      final hi = a < b ? b : a;

      minId = (minId == null) ? lo : (lo < minId ? lo : minId);
      maxId = (maxId == null) ? hi : (hi > maxId ? hi : maxId);
    }

    if (minId == null || maxId == null) return null;
    return (minId, maxId);
  }

  /// Выбирает "основную" суру страницы: сначала из строки `surahName`, затем любой `surahNumber`.
  int? _pickFirstSurahNumber(List<LayoutEntity> layouts) {
    for (final l in layouts) {
      if (l.lineType == LineType.surahName && l.surahNumber != null) {
        return l.surahNumber;
      }
    }
    for (final l in layouts) {
      if (l.surahNumber != null) return l.surahNumber;
    }
    return null;
  }

  /// Получить имя суры через кэш (1 запрос на номер суры максимум).
  Future<String> _getSurahNameCached({
    required int surahNumber,
    required Map<int, String> cache,
  }) async {
    final cached = cache[surahNumber];
    if (cached != null) return cached;

    final s =
    await _surahNameUseCase.getSurahByNumber(surahNumber: surahNumber);
    final name = s?.nameTranslation ?? '';
    cache[surahNumber] = name;
    return name;
  }

  /// Склеивает глифы в слова по (surah, ayah, word), пробелы ставит только между словами.
  String _buildAyahLineText({
    required int? firstWordId,
    required int? lastWordId,
    required Map<int, AyahWordEntity> wordsById,
  }) {
    if (firstWordId == null || lastWordId == null) return '';

    final int lo = firstWordId < lastWordId ? firstWordId : lastWordId;
    final int hi = firstWordId < lastWordId ? lastWordId : firstWordId;

    // Берём реальные записи по id в диапазоне и сортируем по id.
    final glyphs = wordsById.entries
        .where((e) => e.key >= lo && e.key <= hi)
        .map((e) => e.value)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (glyphs.isEmpty) return '';

    final out = StringBuffer();

    int? prevSurah;
    int? prevAyah;
    int? prevWord;

    for (final g in glyphs) {
      final sameWord =
          (prevSurah == g.surah) && (prevAyah == g.ayah) && (prevWord == g.word);

      if (!sameWord && out.isNotEmpty) {
        out.write(' ');
      }

      out.write(g.text);

      prevSurah = g.surah;
      prevAyah = g.ayah;
      prevWord = g.word;
    }

    return out.toString();
  }
}