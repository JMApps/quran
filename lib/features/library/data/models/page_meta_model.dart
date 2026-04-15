import '../../../../core/strings/db_value_strings.dart';

class PageMetaModel {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const PageMetaModel({
    required this.pageNumber,
    required this.surahNumber,
    required this.juzNumber,
    required this.hizbNumber,
  });

  factory PageMetaModel.fromMap(Map<String, Object?> map) {
    return PageMetaModel(
      pageNumber: map[DbValueStrings.dbPageNumber] as int,
      surahNumber: map[DbValueStrings.dbSurahNumber] as int,
      juzNumber: map[DbValueStrings.dbJuzNumber] as int,
      hizbNumber: map[DbValueStrings.dbHizbNumber] as int?,
    );
  }
}
