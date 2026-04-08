class SurahDetailArgs {
  final int currentMushafPage;
  final int ayahPosition;

  SurahDetailArgs({
    required this.currentMushafPage,
    this.ayahPosition = -1,
  });
}