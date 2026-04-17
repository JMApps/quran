import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_styles.dart';
import '../../settings/state/app_settings_state.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.bottomMainPadding,
      child: Consumer<AppSettingsState>(
        builder: (context, appSettingsState, _) {
          return Text(
            '\uFDFD',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: appSettingsState.ayahArabicTextSize + 5.0,
              fontFamily: 'P1',
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}