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

  static bool _asBool01(Object? value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is num) return value.toInt() == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == '1' || normalized == 'true';
    }
    return false;
  }

  static int? _asNullableInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory LayoutModel.fromMap(Map<String, Object?> map) {
    return LayoutModel(
      pageNumber: map[DbValueStrings.dbPageNumber] as int,
      lineNumber: map[DbValueStrings.dbLineNumber] as int,
      lineType: AppStrings.lineTypeFromDb(
        map[DbValueStrings.dbLineType].toString(),
      ),
      isCentered: _asBool01(map[DbValueStrings.dbIsCentered]),
      firstWordId: _asNullableInt(map[DbValueStrings.dbFirstWordId]),
      lastWordId: _asNullableInt(map[DbValueStrings.dbLastWordId]),
      surahNumber: _asNullableInt(map[DbValueStrings.dbSurahNumber]),
    );
  }
}