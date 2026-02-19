import 'line_type.dart';

class LayoutLineEntity {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  const LayoutLineEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });
}