import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../items/word_glyph_item.dart';

class WordGlyphList extends StatelessWidget {
  const WordGlyphList({
    super.key,
    required this.surahNameTranscription,
    required this.juzNumber,
    required this.layoutsPage,
  });

  final String surahNameTranscription;
  final int juzNumber;
  final List<LayoutEntity> layoutsPage;

  @override
  Widget build(BuildContext context) {
    final isSpecialPage = layoutsPage.first.pageNumber == 1 || layoutsPage.first.pageNumber == 2;

    return OrientationBuilder(
      builder: (context, orientation) {
        final mediaQuery = MediaQuery.of(context);
        final isLandscape = orientation == Orientation.landscape;
        final screenHeight = mediaQuery.size.height;
        final headerHeight = isLandscape ? screenHeight * 0.115 : screenHeight * 0.085;
        final footerHeight = isLandscape ? screenHeight * 0.075: screenHeight * 0.025;

        final items = layoutsPage.map((layout) => WordGlyphItem(
          layoutModel: layout,
        )).toList();

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: AppStyles.hrMainPadding,
                  child: SizedBox(
                    height: headerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppStrings.surah} $surahNameTranscription'),
                        Text('${AppStrings.juz} $juzNumber'),
                      ],
                    ),
                  ),
                ),
                isSpecialPage ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items,
                  ),
                ) : Column(
                  children: items,
                ),
                Padding(
                  padding: AppStyles.hrMainPadding,
                  child: SizedBox(
                    height: footerHeight,
                    child: Text(
                      layoutsPage.first.pageNumber.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
