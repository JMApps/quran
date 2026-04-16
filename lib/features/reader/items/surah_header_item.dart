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
    final surahModel = context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: surahNumber));
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
            '${AppStrings.surah} ${surahModel!.nameTranscription}',
            style: AppStyles.mainTextStyle18,
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
