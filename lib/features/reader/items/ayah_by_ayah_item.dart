import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../favorites/widgets/ayah_item_params.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../settings/state/reading_settings_state.dart';

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
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return AyahItemParams(
              ayahByAyahModel: ayahByAyahModel,
            );
          },
        );
      },
      child: Container(
        padding: AppStyles.vrBigHrMiniPadding,
        decoration: BoxDecoration(
          border: .symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: appColors.secondary,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 65,
                  padding: AppStyles.microPadding,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: appColors.secondaryContainer.withAlpha(155),
                    borderRadius: AppStyles.miniBorder,
                  ),
                  child: Text(ayahByAyahModel.verseKey),
                ),
              ],
            ),
            Consumer<ReadingSettingsState>(
              builder: (context, readingSettingsState, _) {
                return Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SizedBox(height: readingSettingsState.isArabicAyahShow ? 14 : 0),
                    Visibility(
                      visible: readingSettingsState.isArabicAyahShow,
                      child: Text(
                        ayahByAyahModel.ayahArabic,
                        textDirection: .rtl,
                        style: TextStyle(
                          fontSize: readingSettingsState.ayahArabicTextSize,
                          fontFamily: AppStrings.fontUthmanicHafs,
                          height: 2.25,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: readingSettingsState.isTranslationAyahShow ? 14 : 0),
                    Visibility(
                      visible: readingSettingsState.isTranslationAyahShow,
                      child: Text(
                        ayahByAyahModel.ayahTranslation,
                        style: TextStyle(
                          fontSize: readingSettingsState.ayahTranslationTextSize,
                          fontFamily: AppStrings.fontGilroy,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
