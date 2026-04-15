import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/library/presentation/state/main_state.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../core/router/names_router.dart';
import '../../favorites/widgets/ayah_item_params.dart';
import '../../library/data/arguments/surah_detail_args.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/surah_name_state.dart';

class SearchAyahItem extends StatelessWidget {
  const SearchAyahItem({
    super.key,
    required this.ayahByAyahModel,
    required this.index,
    required this.query,
  });
  final AyahByAyahEntity ayahByAyahModel;
  final int index;
  final String query;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final surahState = Provider.of<SurahNameState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: ayahByAyahModel.verseKey);
    const arabicStyle = TextStyle(
      fontSize: 19.0,
      fontFamily: AppStrings.fontUthmanicHafs,
      height: 2.5,
      letterSpacing: 0,
    );

    const translationStyle = TextStyle(
      fontSize: 16.0,
      fontFamily: AppStrings.fontGilroy,
    );

    final TextStyle highlightStyleArabic = arabicStyle.copyWith(
      fontWeight: .bold,
      backgroundColor: appColors.inversePrimary,
    );

    final TextStyle highlightStyleTranslation = translationStyle.copyWith(
      fontWeight: .bold,
      backgroundColor: appColors.inversePrimary,
    );

    final TextSpan arabicSpan = _highlightOccurrences(
      fullText: ayahByAyahModel.ayahArabic,
      query: query,
      normalStyle: arabicStyle,
      highlightStyle: highlightStyleArabic,
      caseSensitive: true,
    );

    final TextSpan translationSpan = _highlightOccurrences(
      fullText: ayahByAyahModel.ayahTranslation,
      query: query,
      normalStyle: translationStyle,
      highlightStyle: highlightStyleTranslation,
      caseSensitive: false,
    );

    return InkWell(
      onTap: () async {
        final mainState = context.read<MainState>();
        mainState.setCurrentPage(ayahByAyahModel.ayahPageNumber);
        final arguments = SurahDetailArgs(
          currentMushafPage: ayahByAyahModel.ayahPageNumber,
          ayahPosition: ayahByAyahModel.ayahPosition,
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
          border: .symmetric(
            horizontal: BorderSide(
              width: 0.25,
              color: Colors.grey,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text.rich(
              arabicSpan,
              textDirection: .rtl,
            ),
            const SizedBox(height: 14),
            Text.rich(translationSpan),
            const SizedBox(height: 14),
            Text(
              surahInfo,
              style: AppStyles.mainTextStyle16.copyWith(
                color: appColors.onSurface.withAlpha(105),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _highlightOccurrences({required String fullText, required String query, required TextStyle normalStyle, required TextStyle highlightStyle, required bool caseSensitive}) {
    if (fullText.isEmpty || query.trim().isEmpty) {
      return TextSpan(text: fullText, style: normalStyle);
    }

    final String source = caseSensitive ? fullText : fullText.toLowerCase();
    final String target = caseSensitive ? query.trim() : query.toLowerCase().trim();

    final List<TextSpan> children = [];
    int start = 0;

    while (true) {
      final int index = source.indexOf(target, start);

      if (index == -1) {
        children.add(
          TextSpan(
            text: fullText.substring(start),
            style: normalStyle,
          ),
        );
        break;
      }

      if (index > start) {
        children.add(
          TextSpan(
            text: fullText.substring(start, index),
            style: normalStyle,
          ),
        );
      }

      children.add(
        TextSpan(
          text: fullText.substring(index, index + target.length),
          style: highlightStyle,
        ),
      );

      start = index + target.length;
    }

    return TextSpan(style: normalStyle, children: children);
  }
}
