import 'package:equatable/equatable.dart';

import 'line_type.dart';

class MushafPageEntity extends Equatable {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final int isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;
  final String location;
  final int surah;
  final int ayah;
  final int word;
  final String text;
  final int charType;

  const MushafPageEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.lineType,
    required this.isCentered,
    required this.firstWordId,
    required this.lastWordId,
    required this.surahNumber,
    required this.location,
    required this.surah,
    required this.ayah,
    required this.word,
    required this.text,
    required this.charType,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    lineNumber,
    lineType,
    isCentered,
    firstWordId,
    lastWordId,
    surahNumber,
    location,
    surah,
    ayah,
    word,
    text,
    charType,
  ];
}
