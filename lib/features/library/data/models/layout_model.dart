import '../../../../core/strings/app_strings.dart';
import '../../../../core/strings/db_value_strings.dart';
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

  static bool _asBool01(Object? v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is num) return v.toInt() == 1;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  factory LayoutModel.fromMap(Map<String, Object?> map) {
    return LayoutModel(
      pageNumber: map[DbValueStrings.dbPageNumber] as int,
      lineNumber: map[DbValueStrings.dbLineNumber] as int,
      lineType: AppStrings.lineTypeFromDb((map[DbValueStrings.dbLineType]).toString()),
      isCentered: _asBool01(map[DbValueStrings.dbIsCentered]),
      firstWordId: map[DbValueStrings.dbFirstWordId] as int?,
      lastWordId: map[DbValueStrings.dbLastWordId] as int?,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
    );
  }
}
