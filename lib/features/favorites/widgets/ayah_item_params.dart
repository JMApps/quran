import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/surah_name_state.dart';

class AyahItemParams extends StatelessWidget {
  const AyahItemParams({
    super.key,
    required this.ayahByAyahModel,
  });

  final AyahByAyahEntity ayahByAyahModel;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahState = Provider.of<SurahNameState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(
      surah: AppStrings.surah,
      ayah: AppStrings.ayah,
      verseKey: ayahByAyahModel.verseKey,
    );
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        Container(
          padding: AppStyles.microPadding,
          margin: AppStyles.hrMainPadding,
          alignment: .center,
          decoration: BoxDecoration(
            color: appColors.inversePrimary,
            borderRadius: AppStyles.miniBorder,
          ),
          child: Text(
            ayahByAyahModel.verseKey,
            style: AppStyles.mainTextStyle18,
          ),
        ),
        const SizedBox(height: 7),
        Consumer<FavoritesState>(
          builder: (context, mushafPageMetaState, _) {
            final bool isFavorite = mushafPageMetaState.isFavoriteAyah(ayahByAyahModel.ayahId);
            return TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                mushafPageMetaState.toggleFavoriteAyah(ayahId: ayahByAyahModel.ayahId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: appColors.inversePrimary,
                    content: Text(
                      !isFavorite ? AppStrings.addedToFavorite : AppStrings.removedFromFavorite,
                      style: AppStyles.mainTextStyle16.copyWith(color: appColors.onSurface),
                    ),
                  ),
                );
              },
              label: Text(
                isFavorite ? AppStrings.removeFromFavorite : AppStrings.addToFavorite,
                style: AppStyles.mainTextStyle18,
              ),
              icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border_rounded),
            );
          },
        ),
        TextButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            Pasteboard.writeText(
              '${ayahByAyahModel.ayahArabic}\n\n${ayahByAyahModel.ayahTranslation}\n\n$surahInfo',
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: appColors.inversePrimary,
                content: Text(
                  AppStrings.copied,
                  style: AppStyles.mainTextStyle16.copyWith(color: appColors.onSurface),
                ),
              ),
            );
          },
          label: const Text(
            AppStrings.copy,
            style: AppStyles.mainTextStyle18,
          ),
          icon: const Icon(Icons.content_copy_rounded),
        ),
        TextButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            await SharePlus.instance.share(
              ShareParams(
                text: '${ayahByAyahModel.ayahArabic}\n\n${ayahByAyahModel.ayahTranslation}\n\n$surahInfo',
                sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
              ),
            );
          },
          label: const Text(
            AppStrings.share,
            style: AppStyles.mainTextStyle18,
          ),
          icon: const Icon(Icons.ios_share_rounded),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
