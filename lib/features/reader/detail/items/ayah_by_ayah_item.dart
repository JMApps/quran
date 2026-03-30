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
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: AppStyles.miniPadding,
      title: Column(
        crossAxisAlignment: .stretch,
        children: [
          Container(
            padding: AppStyles.microPadding,
            decoration: BoxDecoration(
              color: appColors.secondaryContainer,
              borderRadius: AppStyles.miniBorder,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 3.5),
              child: Text(
                ayahByAyahModel.verseKey,
                style: TextStyle(
                  color: appColors.secondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ayahByAyahModel.ayahArabic,
            style: const TextStyle(
              fontSize: 20.0,
              fontFamily: AppStrings.fontUthmanicHafs,
              height: 2.0,
            ),
            textDirection: TextDirection.rtl,

          ),
        ],
      ),
    );
  }
}
