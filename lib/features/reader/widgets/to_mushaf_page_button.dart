import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/presentation/state/surah_state.dart';

class ToMushafPageButton extends StatelessWidget {
  const ToMushafPageButton({
    super.key,
    required this.mushafPageController,
  });

  final PageController mushafPageController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return Container(
              margin: AppStyles.topMiniPadding,
              padding: AppStyles.withoutTopPadding,
              height: 65,
              child: Consumer<SurahState>(
                builder: (context, surahState, _) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1.75,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    ),
                    child: Directionality(
                      textDirection: .rtl,
                      child: Slider(
                        showValueIndicator: .alwaysVisible,
                        value: surahState.currentMushafPage.toDouble(),
                        label: '${surahState.currentMushafPage}',
                        min: 1,
                        max: 604,
                        divisions: 604,
                        onChanged: (double value) {
                          surahState.setMushafCurrentPage(value.round());
                        },
                        onChangeEnd: (double value) {
                          surahState.setMushafCurrentPage(value.round());
                          if (mushafPageController.hasClients) {
                            mushafPageController.jumpToPage(value.toInt() - 1);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      tooltip: AppStrings.goTo,
      icon: const Icon(Icons.auto_stories_outlined),
    );
  }
}
