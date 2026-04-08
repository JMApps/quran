import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_strings.dart';

class SurahHeaderItem extends StatelessWidget {
  const SurahHeaderItem({
    super.key,
    required this.surahName,
  });

  final String surahName;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppStyles.mainPadding,
      margin: AppStyles.vrBigHrMiniPadding,
      alignment: .center,
      decoration: BoxDecoration(
        color: appColors.secondaryContainer.withAlpha(120),
        borderRadius: AppStyles.mainBorder,
      ),
      child: Text(
        '${AppStrings.surah} $surahName',
        style: AppStyles.mainTextStyle18,
        textAlign: .center,
      ),
    );
  }
}
