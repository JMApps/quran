import 'package:Quran/core/strings/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/presentation/state/main_state.dart';

class ToPageButton extends StatelessWidget {
  const ToPageButton({super.key});

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
              child: Column(
                mainAxisSize: .min,
                children: [
                  Consumer<MainState>(
                    builder: (context, mainState, _) {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 1.75,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Directionality(
                          textDirection: .rtl,
                          child: Slider(
                            showValueIndicator: .alwaysVisible,
                            value: mainState.currentPage.toDouble(),
                            label: '${mainState.currentPage}',
                            min: 1,
                            max: AppConstants.totalPagesCount.toDouble(),
                            divisions: AppConstants.totalPagesCount,
                            onChanged: (double value) {
                              mainState.onMainPageChanged(value.round());
                            },
                            onChangeEnd: (double value) {
                              mainState.onMainPageChangedEnd(value.round());
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const Text(
                    AppStrings.jumpToPage,
                    style: AppStyles.mainTextStyle18,
                  ),
                  const SizedBox(height: 7),
                ],
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
