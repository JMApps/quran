import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_constants.dart';
import '../state/ayah_by_ayah_state.dart';
import '../state/word_glyph_state.dart';
import '../state/mushaf_page_number_state.dart';

class ToMushafPageButton extends StatelessWidget {
  const ToMushafPageButton({
    super.key,
    required this.translationController,
  });

  final PageController translationController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Column(
              mainAxisSize: .min,
              children: [
                Container(
                  margin: AppStyles.topMiniPadding,
                  padding: AppStyles.withoutTopPadding,
                  child: Consumer<MushafPageNumberState>(
                    builder: (context, mushafPageNumberState, _) {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.75,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Directionality(
                          textDirection: .rtl,
                          child: Slider(
                            showValueIndicator: .alwaysVisible,
                            value: mushafPageNumberState.currentPageNumber.toDouble(),
                            label: '${mushafPageNumberState.currentPageNumber}',
                            min: 1,
                            max: AppConstants.totalPagesCount.toDouble(),
                            divisions: AppConstants.totalPagesCount,
                            onChanged: (double value) {
                              mushafPageNumberState.currentPageNumber = value.round();
                            },
                            onChangeEnd: (double value) {
                              int pageNumber = value.round();

                              final ayahByAyahState = context.read<AyahByAyahState>();
                              final wordGlyphState = context.read<WordGlyphState>();

                              ayahByAyahState.loadSelectPageAyahs(pageNumber: pageNumber);
                              ayahByAyahState.prefetchAround(pageNumber: pageNumber);
                              wordGlyphState.loadSelectPageLines(pageNumber: pageNumber);
                              wordGlyphState.prefetchAround(pageNumber: pageNumber);
                              
                              if (translationController.hasClients) {
                                translationController.jumpToPage(pageNumber - 1);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      tooltip: AppStrings.goTo,
      icon: const Icon(Icons.auto_stories_outlined),
    );
  }
}
