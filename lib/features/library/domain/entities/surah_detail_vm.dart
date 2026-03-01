import 'layout_entity.dart';
import 'ayah_word_entity.dart';

class SurahDetailLineVm {
  final LayoutEntity line;
  final List<AyahWordEntity> words;
  final String? customText;

  const SurahDetailLineVm({
    required this.line,
    required this.words,
    this.customText,
  });
}

class SurahDetailPageVm {
  final int pageNumber;
  final String surahTitle;
  final int juzNumber;
  final List<SurahDetailLineVm> lines;

  const SurahDetailPageVm({
    required this.pageNumber,
    required this.surahTitle,
    required this.juzNumber,
    required this.lines,
  });
}
