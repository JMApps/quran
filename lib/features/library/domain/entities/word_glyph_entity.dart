import 'package:equatable/equatable.dart';

class WordGlyphEntity extends Equatable {
  final String location;
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;
  final String glyph;
  final String wholeWord;

  const WordGlyphEntity({
    required this.location,
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
    required this.glyph,
    required this.wholeWord,
  });

  @override
  List<Object?> get props => [
    location,
    surahNumber,
    ayahNumber,
    wordNumber,
    glyph,
    wholeWord,
  ];
}
