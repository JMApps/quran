import '../entities/ayah_word_entity.dart';
import '../entities/line_type.dart';
import '../entities/surah_detail_vm.dart';
import '../repositories/ayah_word_repository.dart';
import '../repositories/juz_repository.dart';
import '../repositories/layout_repository.dart';
import '../repositories/surah_name_repository.dart';

class GetMushafPageUseCase {
  final LayoutRepository _layoutRepo;
  final AyahWordRepository _wordRepo;
  final SurahNameRepository _surahRepo;
  final JuzRepository _juzRepo;

  const GetMushafPageUseCase(
    this._layoutRepo,
    this._wordRepo,
    this._surahRepo,
    this._juzRepo,
  );

  Future<SurahDetailPageVm> execute({required int pageNumber}) async {
    final lines = await _layoutRepo.getLinesByPage(pageNumber: pageNumber);

    // Получаем слова одним диапазоном
    final ranged = lines.where((l) => l.firstWordId != null && l.lastWordId != null).toList();
    Map<int, AyahWordEntity> wordsMap = {};

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

    final vmLines = <SurahDetailLineVm>[];

    for (final line in lines) {
      if (line.lineType == LineType.surahName && line.surahNumber != null) {
        final surah = surahMap[line.surahNumber!];
        final title = surah?.nameArabic ?? '';
        vmLines.add(
          SurahDetailLineVm(
            line: line,
            words: [],
            customText: title,
          ),
        );
        continue;
      }

      if (line.lineType == LineType.basmallah) {
        vmLines.add(
          SurahDetailLineVm(
            line: line,
            words: [],
            customText: '﷽',
          ),
        );
        continue;
      }

      if (line.firstWordId != null && line.lastWordId != null) {
        final words = <AyahWordEntity>[];
        for (int id = line.firstWordId!; id <= line.lastWordId!; id++) {
          final w = wordsMap[id];
          if (w != null) words.add(w);
        }

        vmLines.add(
          SurahDetailLineVm(
            line: line,
            words: words,
          ),
        );
      } else {
        vmLines.add(
          SurahDetailLineVm(
            line: line,
            words: const [],
          ),
        );
      }
    }

    return SurahDetailPageVm(
      pageNumber: pageNumber,
      surahTitle: surahHeader?.nameArabic ?? '',
      juzNumber: juz.juzNumber,
      lines: vmLines,
    );
  }
}
