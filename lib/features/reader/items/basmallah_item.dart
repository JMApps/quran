import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../settings/state/reading_settings_state.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.bottomMainPadding,
      child: Text(
        AppStrings.basmallahGlyph.split('').join(''),
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: context.watch<ReadingSettingsState>().ayahArabicTextSize + 5.0,
          fontFamily: 'P1',
          wordSpacing: 0
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}