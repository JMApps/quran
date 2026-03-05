import '../entities/layout_entity.dart';
import '../entities/ayah_word_entity.dart';
import '../entities/surah_name_entity.dart';
import '../entities/line_type.dart';

import '../entities/mushaf_page_entity.dart';

import 'ayah_word_use_case.dart';
import 'layout_use_case.dart';
import 'surah_name_use_case.dart';

class BuildMushafPageUseCase {
  final LayoutUseCase _layoutUseCase;
  final AyahWordUseCase _ayahWordUseCase;
  final SurahNameUseCase _surahNameUseCase;

  const BuildMushafPageUseCase(
      this._layoutUseCase,
      this._ayahWordUseCase,
      this._surahNameUseCase,
      );

  Future<MushafPageEntity> execute({required int pageNumber}) async {
    final layouts = await _layoutUseCase.getLinesByPage(pageNumber: pageNumber);

    // Чтобы не дергать БД по каждой строке: одним запросом вытаскиваем все слова страницы.
    final range = _calcWordRange(layouts);
    final List<AyahWordEntity> words = range == null
        ? const <AyahWordEntity>[]
        : await _ayahWordUseCase.getWordsByRange(fromId: range.$1, toId: range.$2);

    // Быстрый доступ по id
    final Map<int, AyahWordEntity> wordsById = {for (final w in words) w.id: w};

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
          final int? surahNumber = l.surahNumber;
          String surahName = '';
          if (surahNumber != null) {
            final SurahNameEntity? s =
            await _surahNameUseCase.getSurahByNumber(surahNumber: surahNumber);
            surahName = s?.nameArabic ?? '';
          }
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

    return MushafPageEntity(
      pageNumber: pageNumber,
      lines: lines,
    );
  }

  /// Возвращает (minId, maxId) для всей страницы.
  (int, int)? _calcWordRange(List<LayoutEntity> layouts) {
    int? minId;
    int? maxId;

    for (final l in layouts) {
      final a = l.firstWordId;
      final b = l.lastWordId;
      if (a == null || b == null) continue;

      minId = (minId == null) ? a : (a < minId ? a : minId);
      maxId = (maxId == null) ? b : (b > maxId ? b : maxId);
    }

    if (minId == null || maxId == null) return null;
    return (minId, maxId);
  }

  String _buildAyahLineText({
    required int? firstWordId,
    required int? lastWordId,
    required Map<int, AyahWordEntity> wordsById,
  }) {
    if (firstWordId == null || lastWordId == null) return '';

    final parts = <String>[];
    for (int id = firstWordId; id <= lastWordId; id++) {
      final w = wordsById[id];
      if (w == null) continue;
      parts.add(w.text);
    }
    return parts.join(' ');
  }
}