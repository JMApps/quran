import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';

class WordGlyphItem extends StatelessWidget {
  const WordGlyphItem({
    super.key,
    required this.surahNameTranscription,
    required this.juzNumber,
    required this.pageNumber,
    required this.layoutsPage,
    required this.fontStyle,
  });

  final String surahNameTranscription;
  final int juzNumber;
  final int pageNumber;
  final List<LayoutEntity> layoutsPage;
  final TextStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppStyles.bigPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${AppStrings.surah} $surahNameTranscription'),
              Text('${AppStrings.juz} $juzNumber'),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: layoutsPage.map((line) => _buildLine(line, fontStyle)).toList(growable: false),
          ),
        ),
        Padding(
          padding: AppStyles.mainPadding,
          child: Text(pageNumber.toString(), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildLine(LayoutEntity line, TextStyle baseStyle) {
    return switch (line.lineType) {
      LineType.basmallah => const _BasmallahLine(),
      LineType.surahName => _SurahNameLine(surahNumber: line.surahNumber!),
      LineType.ayah => _AyahLine(lines: line.glyphs.map((segment) => TextSpan(text: segment.glyph)).toList(growable: false), baseStyle: baseStyle, isCentered: line.isCentered),
    };
  }
}

class _BasmallahLine extends StatelessWidget {
  const _BasmallahLine();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.basmallahGlyph.split(' ').join('\u202F'),
      textAlign: .center,
      style: const TextStyle(
        fontFamily: AppStrings.fontUthmanicHafs,
        fontSize: 26.0,
        height: 1.75,
      ),
    );
  }
}

class _SurahNameLine extends StatelessWidget {
  const _SurahNameLine({required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.surahNameByNumber(surahNumber),
      textAlign: .center,
      style: const TextStyle(
        fontFamily: AppStrings.fontSurahName,
        fontSize: 28.0,
        height: 2.15,
      ),
    );
  }
}

class _AyahLine extends StatelessWidget {
  const _AyahLine({
    required this.lines,
    required this.baseStyle,
    required this.isCentered,
  });

  final List<TextSpan> lines;
  final TextStyle baseStyle;
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: lines,
      ),
      textDirection: .rtl,
      textAlign: isCentered ? .center : .justify,
    );
  }
}
