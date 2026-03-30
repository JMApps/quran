import '../../../../core/strings/app_strings.dart';
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

  static int _asInt(Object? v, String key) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final parsed = int.tryParse(v);
      if (parsed != null) return parsed;
    }
    throw StateError("LayoutModel: '$key' expected int, got $v (${v.runtimeType})");
  }

  static int? _asIntOrNull(Object? v, String key) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    throw StateError("LayoutModel: '$key' expected int?, got $v (${v.runtimeType})");
  }

  static bool _asBool01(Object? v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is num) return v.toInt() == 1;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  factory LayoutModel.fromMap(Map<String, Object?> map) {
    return LayoutModel(
      pageNumber: _asInt(map['page_number'], 'page_number'),
      lineNumber: _asInt(map['line_number'], 'line_number'),
      lineType: AppStrings.lineTypeFromDb((map['line_type'] ?? '').toString()),
      isCentered: _asBool01(map['is_centered']),
      firstWordId: _asIntOrNull(map['first_word_id'], 'first_word_id'),
      lastWordId: _asIntOrNull(map['last_word_id'], 'last_word_id'),
      surahNumber: _asIntOrNull(map['surah_number'], 'surah_number'),
    );
  }
}