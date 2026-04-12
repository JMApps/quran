import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_strings.dart';

class SurahHeaderItem extends StatelessWidget {
  const SurahHeaderItem({
    super.key,
    required this.surahName,
    required this.surahNumber,
  });

  final String surahName;
  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppStyles.miniPadding,
      margin: AppStyles.vrBigHrMiniPadding,
      alignment: .center,
      decoration: BoxDecoration(
        color: appColors.secondaryContainer.withAlpha(120),
        borderRadius: AppStyles.mainBorder,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.surahNameByNumber(surahNumber),
            style: const TextStyle(
              fontSize: 35.0,
              fontFamily: AppStrings.fontSurahName,
              height: 1
            ),
            textDirection: .ltr,
            textAlign: .center,
          ),
          Text(
            '${AppStrings.surah} $surahName',
            style: AppStyles.mainTextStyle18,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
