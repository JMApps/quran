import 'package:equatable/equatable.dart';

class WordGlyphEntity extends Equatable {
  final int id;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;
  final int? charType;

  const WordGlyphEntity({
    required this.id,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
    required this.charType,
  });

  bool get isAyahEnd => charType == 1;

  @override
  List<Object?> get props => [id];
}