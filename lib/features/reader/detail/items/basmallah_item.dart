import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';

class BasmallahItem extends StatelessWidget {
  const BasmallahItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.bottomMainPadding,
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          /* TODO Задать размер как у аятов на арабском */
          fontSize: 19.0,
          fontFamily: AppStrings.fontUthmanicHafs,
          color: Theme.of(context).colorScheme.primary,
        ),
        textAlign: .center,
      ),
    );
  }
}
