import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/line_type.dart';

class PageLineDto {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final bool isCentered;
  final int? surahNumber;
  final String lineText;
  final String surahNameText;

  const PageLineDto({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
    required this.lineText,
    required this.surahNameText,
  });

  factory PageLineDto.fromMap(Map<String, Object?> map) {
    return PageLineDto(
      pageNumber: map['page_number'] as int,
      lineNumber: map['line_number'] as int,
      lineType: AppStrings.lineTypeFromDb((map['line_type'] as String?) ?? ''),
      isCentered: (map['is_centered'] as int? ?? 0) == 1,
      surahNumber: map['surah_number'] as int?,
      lineText: (map['line_text'] as String?) ?? '',
      surahNameText: (map['surah_name_text'] as String?) ?? '',
    );
  }
}