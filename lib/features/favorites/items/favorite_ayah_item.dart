import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/main_state.dart';

import '../../../core/router/names_router.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/data/arguments/surah_detail_args.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../settings/state/app_settings_state.dart';
import '../widgets/ayah_item_params.dart';

class FavoriteAyahItem extends StatelessWidget {
  const FavoriteAyahItem({
    super.key,
    required this.ayahByAyahModel,
    required this.index,
    required this.surahInfo,
  });

  final AyahByAyahEntity ayahByAyahModel;
  final int index;
  final String surahInfo;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final mainState = context.read<MainState>();
        mainState.setCurrentPage(ayahByAyahModel.ayahPageNumber);
        final arguments = SurahDetailArgs(
          currentMushafPage: ayahByAyahModel.ayahPageNumber,
          ayahPosition: ayahByAyahModel.ayahPosition - 1,
        );
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: arguments,
        );
      },
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
        padding: AppStyles.mainPadding,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: Colors.grey,
            ),
          ),
        ),
        child: Consumer<AppSettingsState>(
          builder: (context, appSettingsState, _) {
            return Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  ayahByAyahModel.ayahArabic,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: appSettingsState.ayahArabicTextSize,
                    fontFamily: AppStrings.fontUthmanicHafs,
                    height: 2.5,
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
                const SizedBox(height: 14),
                Text(
                  surahInfo,
                  style: AppStyles.mainTextStyle16.copyWith(
                    color: appColors.onSurface.withAlpha(105),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
