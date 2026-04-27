import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/strings/app_strings.dart';
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
    final String surahNameTranscription = context.select<SurahNameState, String>((s) => s.getSurahByNumber(surahNumber: surahNumber)!.nameTranscription);
    return Container(
      padding: AppStyles.bigPadding,
      margin: AppStyles.mainPadding,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: .mode(appColors.primary, .srcIn),
          image: const AssetImage('assets/pictures/s_header.png'),
          fit: .scaleDown,
        ),
      ),
      child: Text(
        surahNameTranscription,
        style: TextStyle(
          fontSize: 19.0,
          fontFamily: AppStrings.fontGilroy,
          color: appColors.primary,
        ),
        textAlign: .center,
        overflow: .ellipsis,
      ),
    );
  }
}
