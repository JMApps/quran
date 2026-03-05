import 'line_type.dart';

class MushafPageEntity {
  final int pageNumber;
  final String surahName;
  final int juzNumber;
  final List<MushafLineEntity> lines;

  const MushafPageEntity({
    required this.pageNumber,
    required this.surahName,
    required this.juzNumber,
    required this.lines,
  });
}

class MushafLineEntity {
  final LineType type;
  final String text;
  final bool isCentered;

  const MushafLineEntity({
    required this.type,
    required this.text,
    required this.isCentered,
  });
}
