import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../settings/state/app_settings_state.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Padding(
      padding: AppStyles.bottomMainPadding,
      child: Consumer<AppSettingsState>(
        builder: (context, appSettingsState, _) {
          return Text(
            AppStrings.basmaLlah,
            textDirection: .rtl,
            style: TextStyle(
              fontSize: appSettingsState.ayahArabicTextSize,
              fontFamily: AppStrings.fontUthmanicHafs,
              color: appColors.primary,
            ),
            textAlign: .center,
          );
        },
      ),
    );
  }
}
