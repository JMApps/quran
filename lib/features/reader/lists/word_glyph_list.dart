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
    return LayoutBuilder(
      builder: (context, constraints) {
        final first = layoutsPage.first;
        final items = layoutsPage.map((l) => WordGlyphItem(layoutModel: l)).toList(growable: false);

        final column = Column(
          mainAxisSize: first.isCentered ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: .center,
          children: items,
        );

        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              Padding(
                padding: AppStyles.bigPadding,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('${AppStrings.surah} $surahNameTranscription'),
                    Text('${AppStrings.juz} $juzNumber'),
                  ],
                ),
              ),
              Expanded(
                child: constraints.maxWidth > constraints.maxHeight ? SingleChildScrollView(primary: false, child: column) : first.isCentered ? Center(child: column) : column,
              ),
              Padding(
                padding: AppStyles.mainPadding,
                child: Text(first.pageNumber.toString(), textAlign: TextAlign.center),
              ),
            ],
          ),
        );
      },
    );
  }
}