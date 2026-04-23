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
    final layoutModel = layoutsPage.first;

    final items = layoutsPage.map((layout) => WordGlyphItem(layoutModel: layout)).toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
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
                child: layoutModel.isCentered ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items,
                ),
              ),
              Padding(
                padding: AppStyles.miniPadding,
                child: Text(
                  layoutModel.pageNumber.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}