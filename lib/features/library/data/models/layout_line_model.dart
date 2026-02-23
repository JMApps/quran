import '../../domain/entities/line_type.dart';

class LayoutLineModel {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  const LayoutLineModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });

  static LineType _parseLineType(Object? raw) {
    final v = (raw ?? '').toString();
    switch (v) {
      case 'ayah':
        return LineType.ayah;
      case 'surah_name':
        return LineType.surahName;
      case 'basmallah':
        return LineType.basmallah;
      default:
        return LineType.ayah;
    }
  }

  factory LayoutLineModel.fromMap(Map<String, dynamic> map) {
    return LayoutLineModel(
      pageNumber: map['page_number'] as int,
      lineNumber: map['line_number'] as int,
      lineType: _parseLineType(map['line_type']),
      isCentered: (map['is_centered'] as int) == 1,
      firstWordId: map['first_word_id'] as int?,
      lastWordId: map['last_word_id'] as int?,
      surahNumber: map['surah_number'] as int?,
    );
  }
}