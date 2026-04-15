import 'package:flutter/material.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/word_glyph_entity.dart';

/// Рендер одной строки мусхафа.
///
/// allSurahs убран: surahNameByNumber принимает int напрямую из line.surahNumber,
/// firstWhere по 114 элементам при каждом build больше не нужен.
class MushafLineWidget extends StatelessWidget {
  const MushafLineWidget({
    super.key,
    required this.line,
    required this.words,
    required this.fontFamily,
    required this.pageNumber,
    required this.textColor,
    required this.endAyahColor,
  });

  final LayoutEntity line;
  final List<WordGlyphEntity> words;
  final String fontFamily;
  final int pageNumber;
  final Color textColor;
  final Color endAyahColor;

  @override
  Widget build(BuildContext context) {
    return _buildLineContent();
  }

  Widget _buildLineContent() {
    switch (line.lineType) {
      case LineType.surahName:
        return _buildSurahNameLine();
      case LineType.basmallah:
        return _buildBasmallahLine();
      case LineType.ayah:
        return _buildAyahLine();
    }
  }

  Widget _buildSurahNameLine() {
    if (pageNumber == 1 || pageNumber == 2) {
      return const SizedBox.shrink();
    }

    final surahLabel = line.surahNumber != null
        ? AppStrings.surahNameByNumber(line.surahNumber!)
        : '';

    return Center(
      child: Text(
        surahLabel,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppStrings.fontSurahName,
          fontSize: line.isCentered ? 40.0 : 100.0,
        ),
      ),
    );
  }

  Widget _buildBasmallahLine() {
    return Center(
      child: Text(
        '﷽',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: line.isCentered ? 30.0 : 100.0,
        ),
      ),
    );
  }

  Widget _buildAyahLine() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment:
      line.isCentered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: words.map((w) {
        if (w.isAyahEnd) {
          return Padding(
            padding: AppStyles.leftMainPadding,
            child: Text(
              _toArabicDigits(w.ayah),
              style: TextStyle(
                fontFamily: AppStrings.fontUthmanicHafs,
                fontSize: (line.isCentered ? 26.0 : 200.0) * 1.15,
                color: endAyahColor,
              ),
            ),
          );
        }

        return Text(
          w.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: line.isCentered ? 26.0 : 200.0,
          ),
        );
      }).toList(),
    );
  }

  String _toArabicDigits(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }
}