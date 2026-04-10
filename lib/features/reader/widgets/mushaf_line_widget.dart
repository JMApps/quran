import 'package:arabic_justified_text/arabic_justified_text.dart';
import 'package:flutter/material.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/domain/entities/word_glyph_entity.dart';

class MushafLineWidget extends StatelessWidget {
  const MushafLineWidget({
    super.key,
    required this.line,
    required this.words,
    required this.fontFamily,
    required this.allSurahs,
    required this.pageNumber,
    required this.textColor,
    required this.endAyahColor,
  });

  final LayoutEntity line;
  final List<WordGlyphEntity> words;
  final String fontFamily;
  final List<SurahNameEntity> allSurahs;
  final int pageNumber;
  final Color textColor;
  final Color endAyahColor;

  @override
  Widget build(BuildContext context) {
    return _buildLineContent(textColor);
  }

  Widget _buildLineContent(Color textColor) {
    switch (line.lineType) {
      case LineType.surahName:
        return _buildSurahNameLine();
      case LineType.basmallah:
        return _buildBasmallahLine();
      case LineType.ayah:
        return _buildAyahLine( textColor, endAyahColor);
    }
  }

  Widget _buildSurahNameLine() {
    final shouldCenter = line.isCentered;

    if (pageNumber == 1 || pageNumber == 2) {
      return const SizedBox.shrink();
    }

    String surahLabel = '';
    if (line.surahNumber != null && allSurahs.isNotEmpty) {
      final surah = allSurahs.firstWhere((s) => s.surahNumber == line.surahNumber,
        orElse: () => allSurahs.first,
      );
      surahLabel = AppStrings.surahNameByNumber(surah.surahNumber);
    }

    return Center(
      child: Text(
        surahLabel,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppStrings.fontSurahName,
          fontSize: shouldCenter ? 40.0 : 100.0,
        ),
      ),
    );
  }

  Widget _buildBasmallahLine() {
    final shouldCenter = line.isCentered;
    return Center(
      child: Text(
        '﷽',
        textDirection: .rtl,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: shouldCenter ? 30.0 : 100.0,
        ),
      ),
    );
  }

  Widget _buildAyahLine(Color textColor, Color endAyahColor) {
    final shouldCenter = line.isCentered;
    return Row(
      textDirection: .rtl,
      mainAxisAlignment: shouldCenter ? .center : .spaceBetween,
      children: words.map((w) {
        final text = ArabicJustifiedText(
          w.text,
          enableKashida: true,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: shouldCenter ? 26.0 : 200.0,
          ),
        );

        if (w.isAyahEnd) {
          final ayahNumber = _toArabicDigits(w.ayah);
          final baseFontSize = shouldCenter ? 26.0 : 200.0;

          return Padding(
            padding: AppStyles.leftMainPadding,
            child: Text(
              ayahNumber,
              style: TextStyle(
                fontFamily: AppStrings.fontUthmanicHafs,
                fontSize: baseFontSize * 1.15,
                color: endAyahColor,
              ),
            ),
          );
        }

        return ColorFiltered(
          colorFilter: .mode(
            textColor,
            BlendMode.srcIn,
          ),
          child: text,
        );
      }).toList(),
    );
  }

  String _toArabicDigits(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((d) => arabicDigits[int.parse(d)]).join();
  }
}
