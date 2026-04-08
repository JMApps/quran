import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../core/router/names_router.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/surah_state.dart';

class SearchAyahItem extends StatelessWidget {
  const SearchAyahItem({
    super.key,
    required this.ayahModel,
    required this.index,
    required this.query,
  });

  final AyahByAyahEntity ayahModel;
  final int index;
  final String query;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final surahState = Provider.of<SurahState>(context, listen: false);
    final String surahInfo = surahState.getSurahNameWithAyah(surah: AppStrings.surah, ayah: AppStrings.ayah, verseKey: ayahModel.verseKey) ?? ayahModel.verseKey;

    const arabicStyle = TextStyle(
      fontSize: 19.0,
      fontFamily: AppStrings.fontUthmanicHafs,
      height: 2.0,
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
      fullText: ayahModel.ayahArabic,
      query: query,
      normalStyle: arabicStyle,
      highlightStyle: highlightStyleArabic,
      caseSensitive: true,
    );

    final TextSpan translationSpan = _highlightOccurrences(
      fullText: ayahModel.ayahTranslation,
      query: query,
      normalStyle: translationStyle,
      highlightStyle: highlightStyleTranslation,
      caseSensitive: false,
    );

    return InkWell(
      onTap: () async {
        surahState.setMushafCurrentPage(ayahModel.ayahPageNumber);
        Navigator.pushNamed(
          context,
          NamesRouter.pageSurahDetail,
          arguments: surahState.currentMushafPage,
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
            const SizedBox(height: 16),
            Text.rich(translationSpan),
            const SizedBox(height: 16),
            Text(
              surahInfo,
              style: AppStyles.mainTextStyle12.copyWith(color: appColors.onSurface.withAlpha(105)),
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