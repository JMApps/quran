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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final headerHeight = screenHeight * 0.075;
    final footerHeight = screenHeight * 0.035;

    final isSpecialPage = layoutsPage.first.pageNumber == 1 || layoutsPage.first.pageNumber == 2;

    final items = layoutsPage.map((layout) => WordGlyphItem(
      layoutModel: layout,
      index: layoutsPage.indexOf(layout)),
    ).toList();

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
  }
}
