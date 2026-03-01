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
    return LayoutModel(
      pageNumber: int.parse(map['page_number'].toString()),
      lineNumber: int.parse(map['line_number'].toString()),
      lineType: LineType.values.firstWhere((e) => e.name == map['line_type'], orElse: () => LineType.ayah),
      isCentered: map['is_centered'] == 1,
      firstWordId: map['first_word_id'] == null ? null : int.tryParse(map['first_word_id'].toString()),
      lastWordId: map['last_word_id'] == null ? null : int.tryParse(map['last_word_id'].toString()),
      surahNumber: map['surah_number'] == null ? null : int.tryParse(map['surah_number'].toString()),
    );
  }
}