import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/presentation/state/word_glyph_state.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final availableWidth = constraints.maxWidth - 28;
        final fontSize = context.read<WordGlyphState>().getFitFontSize(
          page: layoutModel.pageNumber,
          availableWidth: availableWidth,
        );
        final items = layoutsPage.map((layout) => WordGlyphItem(layoutModel: layout, fontSize: fontSize)).toList(growable: false);
        final body = layoutModel.isCentered ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ) : Column(
          mainAxisAlignment: isLandscape ? .start : .spaceEvenly,
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
                child: isLandscape
                    ? SingleChildScrollView(
                  primary: false,
                  physics: const ClampingScrollPhysics(),
                  child: body,
                )
                    : body,
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