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
      padding: AppStyles.mainPadding,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 50,
            padding: AppStyles.microPadding,
            decoration: BoxDecoration(
              color: appColors.secondaryContainer.withAlpha(155),
              borderRadius: AppStyles.miniBorder,
            ),
            alignment: Alignment.center,
            child: Text(ayahByAyahModel.verseKey),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                ayahByAyahModel.ayahArabic,
                style: const TextStyle(
                  fontSize: 19.0,
                  fontFamily: AppStrings.fontUthmanicHafs,
                  height: 2.0,
                ),
                textDirection: TextDirection.rtl,
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
