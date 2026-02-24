import '../entities/line_type.dart';
import '../entities/mushaf_page_vm.dart';
import '../entities/word_entity.dart';
import '../repositories/juz_repository.dart';
import '../repositories/layout_line_repository.dart';
import '../repositories/surah_repository.dart';
import '../repositories/word_repository.dart';

class GetMushafPageUseCase {
  final LayoutLineRepository _layoutRepo;
  final WordRepository _wordRepo;
  final SurahRepository _surahRepo;
  final JuzRepository _juzRepo;

  const GetMushafPageUseCase(
      this._layoutRepo,
      this._wordRepo,
      this._surahRepo,
      this._juzRepo,
      );

  Future<MushafPageVm> execute({required int pageNumber}) async {
    final lines = await _layoutRepo.getLinesByPage(pageNumber: pageNumber);

    // Получаем слова одним диапазоном
    final ranged = lines.where((l) => l.firstWordId != null && l.lastWordId != null).toList();
    Map<int, WordEntity> wordsMap = {};

    if (ranged.isNotEmpty) {
      final fromId = ranged.map((e) => e.firstWordId!).reduce((a, b) => a < b ? a : b);
      final toId = ranged.map((e) => e.lastWordId!).reduce((a, b) => a > b ? a : b);

      final words = await _wordRepo.getWordsByRange(fromId: fromId, toId: toId);
      wordsMap = {for (final w in words) w.id: w};
    }

    final surahHeader = await _surahRepo.getSurahByPage(pageNumber: pageNumber);
    final juz = await _juzRepo.getJuzInfo(pageNumber: pageNumber);

    final allSurahs = await _surahRepo.getAllSurahs();
    final surahMap = {for (final s in allSurahs) s.surahNumber: s};

    final vmLines = <MushafPageLineVm>[];

    for (final line in lines) {
      if (line.lineType == LineType.surahName && line.surahNumber != null) {
        final surah = surahMap[line.surahNumber!];
        final title = surah?.nameArabic ?? '';
        vmLines.add(
          MushafPageLineVm(
            line: line,
            words: [],
            customText: title,
          ),
        );
        continue;
      }

      if (line.lineType == LineType.basmallah) {
        vmLines.add(
          MushafPageLineVm(
            line: line,
            words: [],
            customText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          ),
        );
        continue;
      }

      if (line.firstWordId != null && line.lastWordId != null) {
        final words = <WordEntity>[];
        for (int id = line.firstWordId!; id <= line.lastWordId!; id++) {
          final w = wordsMap[id];
          if (w != null) words.add(w);
        }

        vmLines.add(
          MushafPageLineVm(
            line: line,
            words: words,
          ),
        );
      } else {
        vmLines.add(
          MushafPageLineVm(
            line: line,
            words: const [],
          ),
        );
      }
    }

    return MushafPageVm(
      pageNumber: pageNumber,
      surahTitle: surahHeader?.nameArabic ?? '',
      juzNumber: juz.juzNumber,
      lines: vmLines,
    );
  }
}