import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
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
  });

  final LayoutEntity line;
  final List<WordGlyphEntity> words;
  final String fontFamily;
  final List<SurahNameEntity> allSurahs;
  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final fontSize = isTablet ? 28.0 : _calculateFontSize(screenWidth, pageNumber);

    return SizedBox(
      width: .infinity,
      child: Padding(
        padding: .symmetric(vertical: isTablet ? 4.0 : 2.0),
        child: _buildLineContent(context, fontSize, pageNumber),
      ),
    );
  }

  double _calculateFontSize(double screenWidth, int pageNumber) {
    return (screenWidth / 15).clamp(18.0, 23.0);
  }

  Widget _buildLineContent(BuildContext context, double fontSize, int pageNumber) {
    switch (line.lineType) {
      case LineType.surahName:
        return _buildSurahNameLine(context, fontSize, pageNumber);
      case LineType.basmallah:
        return _buildBasmallahLine(context, fontSize);
      case LineType.ayah:
        return _buildAyahLine(context, fontSize);
    }
  }

  Widget _buildSurahNameLine(BuildContext context, double fontSize, int pageNumber) {
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

    return Container(
      alignment: .center,
      padding: .zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 1.0),
        ),
        borderRadius: AppStyles.mainBorder,
      ),
      child: Text(
        surahLabel,
        textAlign: .center,
        textDirection: .rtl,
        style: TextStyle(
          fontFamily: AppStrings.fontSurahName,
          fontSize: fontSize * 1.5,
          height: 1.75,
        ),
      ),
    );
  }

  Widget _buildBasmallahLine(BuildContext context, double fontSize) {
    return Center(
      child: Text(
        AppStrings.basmaLlah,
        textAlign: .center,
        textDirection: .rtl,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize * 1.2,
          height: 1.75,
        ),
      ),
    );
  }

  Widget _buildAyahLine(BuildContext context, double fontSize) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: line.isCentered ? WrapAlignment.center : WrapAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: words.map((word) {
          return Text(
            word.text,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              height: 2.0,
            ),
          );
        }).toList(),
      ),
    );
  }
}