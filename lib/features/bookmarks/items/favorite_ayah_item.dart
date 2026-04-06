import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/ayah_by_ayah_state.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/surah_state.dart';

class FavoriteAyahItem extends StatelessWidget {
  const FavoriteAyahItem({
    super.key,
    required this.ayahModel,
    required this.index,
  });

  final AyahByAyahEntity ayahModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final surahState = Provider.of<SurahState>(context, listen: false);
    final ayahByAyahState = Provider.of<AyahByAyahState>(context, listen: false);

    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: ayahModel.verseKey) ?? ayahModel.verseKey;

    return InkWell(
      onTap: () async {
        final location = await ayahByAyahState.getAyahLocation(ayahId: ayahModel.ayahId);

        if (!context.mounted || location.pageNumber == null) {
          return;
        }

        surahState.setMushafCurrentPage(location.pageNumber!);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ayahModel.ayahArabic,
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
                  ayahModel.ayahTranslation,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: AppStrings.fontGilroy,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  surahInfo,
                  style: AppStyles.mainTextStyle16.copyWith(
                    color: appColors.onSurface.withAlpha(105),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}