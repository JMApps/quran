class PageMetaEntity {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const PageMetaEntity({
    required this.pageNumber,
    required this.surahNumber,
    required this.juzNumber,
    required this.hizbNumber,
  });
}
