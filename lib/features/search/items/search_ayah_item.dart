import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';

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

    final highlightStyleArabic = arabicStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
    );

    final highlightStyleTranslation = translationStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
    );

    return Container(
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
          Container(
            width: 65,
            padding: AppStyles.microPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appColors.secondaryContainer.withAlpha(155),
              borderRadius: AppStyles.miniBorder,
            ),
            child: Text(ayahModel.verseKey),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                _highlightOccurrences(
                  fullText: ayahModel.ayahArabic,
                  query: query,
                  normalStyle: arabicStyle,
                  highlightStyle: highlightStyleArabic,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              Text.rich(
                _highlightOccurrences(
                  fullText: ayahModel.ayahTranslation,
                  query: query,
                  normalStyle: translationStyle,
                  highlightStyle: highlightStyleTranslation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextSpan _highlightOccurrences({
    required String fullText,
    required String query,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return TextSpan(
        text: fullText,
        style: normalStyle,
      );
    }

    final escapedQuery = RegExp.escape(trimmedQuery);
    final regExp = RegExp(
      escapedQuery,
      caseSensitive: false,
      unicode: true,
    );

    final matches = regExp.allMatches(fullText).toList(growable: false);

    if (matches.isEmpty) {
      return TextSpan(
        text: fullText,
        style: normalStyle,
      );
    }

    final List<TextSpan> children = [];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        children.add(
          TextSpan(
            text: fullText.substring(start, match.start),
            style: normalStyle,
          ),
        );
      }

      children.add(
        TextSpan(
          text: fullText.substring(match.start, match.end),
          style: highlightStyle,
        ),
      );

      start = match.end;
    }

    if (start < fullText.length) {
      children.add(
        TextSpan(
          text: fullText.substring(start),
          style: normalStyle,
        ),
      );
    }

    return TextSpan(
      style: normalStyle,
      children: children,
    );
  }
}