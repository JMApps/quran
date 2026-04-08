import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../library/presentation/state/surah_state.dart';

class AyahItemParams extends StatelessWidget {
  const AyahItemParams({
    super.key,
    required this.ayahByAyahModel,
  });

  final AyahByAyahEntity ayahByAyahModel;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahState = Provider.of<SurahState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: ayahByAyahModel.verseKey)!;
    return Padding(
      padding: AppStyles.withoutTopPadding,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
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
          Consumer<MushafPageMetaState>(
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
                iconAlignment: .end,
                label: Text(isFavorite ? AppStrings.removeFromFavorite : AppStrings.addToFavorite,
                  style: AppStyles.mainTextStyle16,
                ),
                icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border_rounded),
              );
            },
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              // await FlutterClipboard.copy('${ayahByAyahModel.ayahArabic}\n\n${ayahByAyahModel.ayahTranslation}\n\n$surahInfo').whenComplete(() {
              //   if (!context.mounted) return;
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       duration: const Duration(seconds: 1),
              //       backgroundColor: appColors.inversePrimary,
              //       content: Text(
              //         AppStrings.removedFromFavorite,
              //         style: AppStyles.mainTextStyle16.copyWith(color: appColors.onSurface),
              //       ),
              //     ),
              //   );
              // });
            },
            iconAlignment: .end,
            label: const Text(
              AppStrings.copy,
              style: AppStyles.mainTextStyle16,
            ),
            icon: const Icon(Icons.content_copy_rounded),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              // await SharePlus.instance.share(
              //   ShareParams(
              //     text: '${ayahByAyahModel.ayahArabic}\n\n${ayahByAyahModel.ayahTranslation}\n\n$surahInfo',
              //     sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
              //   ),
              // );
            },
            iconAlignment: .end,
            label: const Text(
              AppStrings.share,
              style: AppStyles.mainTextStyle16,
            ),
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
    );
  }
}
