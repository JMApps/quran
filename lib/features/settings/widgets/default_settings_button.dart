import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../state/settings_reset_coordinator.dart';

class DefaultSettingsButton extends StatelessWidget {
  const DefaultSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Padding(
              padding: AppStyles.withoutTopPadding,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .stretch,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<SettingsResetCoordinator>().resetAll();
                                },
                                child: Text(
                                  AppStrings.reset,
                                  style: AppStyles.mainTextStyle18.copyWith(color: appColors.error),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  AppStrings.cancel,
                                  style: AppStyles.mainTextStyle18,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      AppStrings.resetSettings,
                      style: AppStyles.mainTextStyle18.copyWith(color: appColors.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      AppStrings.cancel,
                      style: AppStyles.mainTextStyle18,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      tooltip: AppStrings.resetSettings,
      icon: const Icon(Icons.restart_alt_rounded),
    );
  }
}
