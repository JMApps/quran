import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_strings.dart';

class SurahHeaderItem extends StatelessWidget {
  const SurahHeaderItem({
    super.key,
    required this.surahNumber,
  });

  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppStyles.miniPadding,
      margin: AppStyles.miniPadding,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: .mode(appColors.primary, .srcIn),
          image: const AssetImage('assets/pictures/s_header.png'),
          fit: .scaleDown,
        ),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.surahNameByNumber(surahNumber),
            style: TextStyle(
              fontSize: 45.0,
              fontFamily: AppStrings.fontSurahName,
              color: appColors.primary,
              height: 2,
            ),
            textDirection: .ltr,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
