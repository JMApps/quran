import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../settings/state/reading_settings_state.dart';

class WordGlyphItem extends StatelessWidget {
  const WordGlyphItem({
    super.key,
    required this.surahNameTranscription,
    required this.juzNumber,
    required this.pageNumber,
    required this.layoutsPage,
  });

  final String surahNameTranscription;
  final int juzNumber;
  final int pageNumber;
  final List<LayoutEntity> layoutsPage;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamily: 'P$pageNumber',
      fontSize: context.select<ReadingSettingsState, double>((s) => s.ayahArabicTextSize),
      height: 2.15,
    );

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
            mainAxisAlignment: .center,
            children: layoutsPage.map((line) => Text.rich(
              TextSpan(
                style: baseStyle,
                children: line.glyphs.map((segment) => TextSpan(text: segment.glyph)).toList(growable: false),
              ),
              textDirection: TextDirection.rtl,
            )).toList(growable: false),
          ),
        ),
        Padding(
          padding: AppStyles.mainPadding,
          child: Text(pageNumber.toString(), textAlign: TextAlign.center),
        ),
      ],
    );
  }
}