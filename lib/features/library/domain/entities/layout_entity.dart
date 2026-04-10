import 'line_type.dart';

class LayoutEntity {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  const LayoutEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.firstWordId,
    required this.lastWordId,
    required this.surahNumber,
  });
}