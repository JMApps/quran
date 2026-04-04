import 'ayah_by_ayah_entity.dart';
import 'ayah_list_row_type.dart';

class AyahListRow {
  final AyahListRowType type;
  final AyahByAyahEntity? ayah;
  final int? surahNumber;

  const AyahListRow._({
    required this.type,
    this.ayah,
    this.surahNumber,
  });

  const AyahListRow.surahHeader({
    required int surahNumber,
  }) : this._(
    type: AyahListRowType.surahHeader,
    surahNumber: surahNumber,
  );

  const AyahListRow.basmallah({
    required int surahNumber,
  }) : this._(
    type: AyahListRowType.basmallah,
    surahNumber: surahNumber,
  );

  const AyahListRow.ayah({
    required AyahByAyahEntity ayah,
  }) : this._(
    type: AyahListRowType.ayah,
    ayah: ayah,
  );
}