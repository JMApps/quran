import '../../../../core/strings/db_value_strings.dart';

class PageMetaModel {
  final int pageNumber;
  final String nameTranscription;
  final int juzNumber;
  final int? hizbNumber;

  const PageMetaModel({
    required this.pageNumber,
    required this.nameTranscription,
    required this.juzNumber,
    required this.hizbNumber,
  });

  factory PageMetaModel.fromMap(Map<String, Object?> map) {
    return PageMetaModel(
      pageNumber: map[DbValueStrings.dbPageNumber] as int,
      nameTranscription: map[DbValueStrings.dbNameTranscription] as String,
      juzNumber: map[DbValueStrings.dbJuzNumber] as int,
      hizbNumber: map[DbValueStrings.dbHizbNumber] as int?,
    );
  }
}
