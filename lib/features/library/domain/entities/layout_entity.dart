import 'line_type.dart';

class LayoutEntity {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final String lineText;
  final String surahNameText;

  const LayoutEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.lineText,
    required this.surahNameText,
  });
}