import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../library/domain/entities/ayah_by_ayah_entity.dart';

class AyahByAyahItem extends StatelessWidget {
  const AyahByAyahItem({
    super.key,
    required this.ayahByAyahModel,
    required this.index,
  });

  final AyahByAyahEntity ayahByAyahModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Container(
      padding: AppStyles.vrBigHrMiniPadding,
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.25,
            color: Colors.grey
          )
        )
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 65,
            padding: AppStyles.microPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appColors.secondaryContainer.withAlpha(155),
              borderRadius: AppStyles.miniBorder,
            ),
            child: Text(ayahByAyahModel.verseKey),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                ayahByAyahModel.ayahArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 19.0,
                  fontFamily: AppStrings.fontUthmanicHafs,
                  height: 2.0,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                ayahByAyahModel.ayahTranslation,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: AppStrings.fontGilroy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
