import '../../domain/entities/line_type.dart';

class LayoutModel {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  const LayoutModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });

  factory LayoutModel.fromMap(Map<String, dynamic> map) {

    LineType lineTypeFromDb(String value) {
      switch (value) {
        case 'ayah':
          return LineType.ayah;
        case 'surahName':
          return LineType.surahName;
        case 'basmallah':
          return LineType.basmallah;
        default:
          return LineType.ayah;
      }
    }

    return LayoutModel(
      pageNumber: map['page_number'] as int,
      lineNumber: map['line_number'] as int,
      lineType: lineTypeFromDb(map['line_type'] as String),
      isCentered: map['is_centered'] == 1,
      firstWordId: map['first_word_id'] as int?,
      lastWordId: map['last_word_id'] as int?,
      surahNumber: map['surah_number'] as int?,
    );
  }
}