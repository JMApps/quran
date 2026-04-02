class MushafFontLoader {
  MushafFontLoader._();
  static final MushafFontLoader instance = MushafFontLoader._();

  String familyForPage(int pageNumber) {
    assert(pageNumber >= 1 && pageNumber <= 604);
    return 'QCF_P${pageNumber.toString().padLeft(3, '0')}';
  }
}
