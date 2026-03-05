import 'line_type.dart';

class MushafPageEntity {
  final int pageNumber;
  final List<MushafLineEntity> lines;

  const MushafPageEntity({
    required this.pageNumber,
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
