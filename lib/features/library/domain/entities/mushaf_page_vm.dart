
import 'layout_line_entity.dart';
import 'word_entity.dart';

class MushafPageLineVm {
  final LayoutLineEntity line;
  final List<WordEntity> words;
  final String? customText;

  const MushafPageLineVm({
    required this.line,
    required this.words,
    this.customText,
  });
}

class MushafPageVm {
  final int pageNumber;
  final String surahTitle; // что показывать слева
  final int juzNumber;     // что показывать справа
  final List<MushafPageLineVm> lines;

  const MushafPageVm({
    required this.pageNumber,
    required this.surahTitle,
    required this.juzNumber,
    required this.lines,
  });
}