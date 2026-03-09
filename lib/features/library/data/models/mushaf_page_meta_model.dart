class MushafPageMetaModel {
  final int pageNumber;
  final String nameTranscription;
  final int juzNumber;
  final int? hizbNumber;

  const MushafPageMetaModel({
    required this.pageNumber,
    required this.nameTranscription,
    required this.juzNumber,
    required this.hizbNumber,
  });

  factory MushafPageMetaModel.fromMap(Map<String, Object?> map) {
    return MushafPageMetaModel(
      pageNumber: map['page_number'] as int,
      nameTranscription: map['name_transcription'] as String,
      juzNumber: map['juz_number'] as int,
      hizbNumber: map['hizb_number'] as int?,
    );
  }
}
