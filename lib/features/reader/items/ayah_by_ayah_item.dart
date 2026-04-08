import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/settings/state/app_settings_state.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';

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
            return Padding(
              padding: AppStyles.withoutTopPadding,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    iconAlignment: .end,
                    label: Text('Добавить в избранное', style: AppStyles.mainTextStyle16,),
                    icon: const Icon(Icons.bookmark),
                  ),
                  const Divider(),
                  TextButton.icon(
                    onPressed: () {},
                    iconAlignment: .end,
                    label: Text('Скопировать', style: AppStyles.mainTextStyle16,),
                    icon: const Icon(Icons.content_copy_rounded),
                  ),
                  const Divider(),
                  TextButton.icon(
                    onPressed: () {},
                    iconAlignment: .end,
                    label: Text('Поделиться', style: AppStyles.mainTextStyle16,),
                    icon: const Icon(Icons.ios_share_rounded),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: AppStyles.vrBigHrMiniPadding,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: Colors.grey,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: .start,
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
              ],
            ),
            Consumer<AppSettingsState>(
              builder: (context, appSettingsState, _) {
                return Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      ayahByAyahModel.ayahArabic,
                      textDirection: .rtl,
                      style: TextStyle(
                        fontSize: appSettingsState.ayahArabicTextSize,
                        fontFamily: AppStrings.fontUthmanicHafs,
                        height: 2.25,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      ayahByAyahModel.ayahTranslation,
                      style: TextStyle(
                        fontSize: appSettingsState.ayahTranslationTextSize,
                        fontFamily: AppStrings.fontGilroy,
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
