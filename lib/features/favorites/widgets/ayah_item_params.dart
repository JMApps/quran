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
    return Row(
      mainAxisSize: .min,
      children: [
        Consumer<FavoritesState>(
          builder: (context, mushafPageMetaState, _) {
            final bool isFavorite = mushafPageMetaState.isFavoriteAyah(ayahByAyahModel.ayahId);
            return IconButton(
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
              tooltip: isFavorite ? AppStrings.removeFromFavorite : AppStrings.addToFavorite,
              icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border_rounded),
            );
          },
        ),
        IconButton(
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
          tooltip: AppStrings.copy,
          icon: const Icon(Icons.content_copy_rounded),
        ),
        IconButton(
          onPressed: () async {
            Navigator.pop(context);
            await SharePlus.instance.share(
              ShareParams(
                text:
                    '${ayahByAyahModel.ayahArabic}\n\n${ayahByAyahModel.ayahTranslation}\n\n$surahInfo',
                sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
              ),
            );
          },
          tooltip: AppStrings.share,
          icon: const Icon(Icons.ios_share_rounded),
        ),
      ],
    );
  }
}
