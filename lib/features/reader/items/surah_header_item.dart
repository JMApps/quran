import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/surah_name_state.dart';

class SurahHeaderItem extends StatelessWidget {
  const SurahHeaderItem({
    super.key,
    required this.surahNumber,
  });

  final int surahNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahModel = context.select<SurahNameState, SurahNameEntity?>(
      (s) => s.getSurahByNumber(surahNumber: surahNumber),
    );
    return Container(
      padding: AppStyles.miniPadding,
      margin: AppStyles.miniPadding,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: .mode(appColors.primary, .srcIn),
          image: const AssetImage('assets/pictures/s_header.png'),
          fit: .scaleDown
        ),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.surahNameByNumber(surahNumber),
            style: TextStyle(
              fontSize: 35.0,
              fontFamily: AppStrings.fontSurahName,
              color: appColors.primary,
            ),
            textDirection: .ltr,
            textAlign: .center,
          ),
          Text(
            '${AppStrings.surah} ${surahModel!.nameTranscription}',
            style: AppStyles.mainTextStyle16,
            textAlign: .center,
          ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
