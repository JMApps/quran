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

  static const String _arabicHighlightStart = '[[AR_HL]]';
  static const String _arabicHighlightEnd = '[[/AR_HL]]';
  static const String _translationHighlightStart = '[[TR_HL]]';
  static const String _translationHighlightEnd = '[[/TR_HL]]';

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

    final TextStyle highlightStyleArabic = arabicStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
    );

    final TextStyle highlightStyleTranslation = translationStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
    );

    final TextSpan arabicSpan =
    (ayahModel.highlightedArabic != null &&
        ayahModel.highlightedArabic!.isNotEmpty)
        ? _buildMarkedHighlightSpan(
      markedText: ayahModel.highlightedArabic!,
      normalStyle: arabicStyle,
      highlightStyle: highlightStyleArabic,
      startMarker: _arabicHighlightStart,
      endMarker: _arabicHighlightEnd,
    )
        : _highlightOccurrences(
      fullText: ayahModel.ayahArabic,
      query: query,
      normalStyle: arabicStyle,
      highlightStyle: highlightStyleArabic,
    );

    final TextSpan translationSpan =
    (ayahModel.highlightedTranslation != null &&
        ayahModel.highlightedTranslation!.isNotEmpty)
        ? _buildMarkedHighlightSpan(
      markedText: ayahModel.highlightedTranslation!,
      normalStyle: translationStyle,
      highlightStyle: highlightStyleTranslation,
      startMarker: _translationHighlightStart,
      endMarker: _translationHighlightEnd,
    )
        : _highlightOccurrences(
      fullText: ayahModel.ayahTranslation,
      query: query,
      normalStyle: translationStyle,
      highlightStyle: highlightStyleTranslation,
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
                arabicSpan,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              Text.rich(translationSpan),
            ],
          ),
        ],
      ),
    );
  }

  TextSpan _buildMarkedHighlightSpan({
    required String markedText,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
    required String startMarker,
    required String endMarker,
  }) {
    final List<TextSpan> children = <TextSpan>[];
    int cursor = 0;

    while (cursor < markedText.length) {
      final int startIndex = markedText.indexOf(startMarker, cursor);

      if (startIndex == -1) {
        children.add(
          TextSpan(
            text: markedText.substring(cursor),
            style: normalStyle,
          ),
        );
        break;
      }

      if (startIndex > cursor) {
        children.add(
          TextSpan(
            text: markedText.substring(cursor, startIndex),
            style: normalStyle,
          ),
        );
      }

      final int contentStart = startIndex + startMarker.length;
      final int endIndex = markedText.indexOf(endMarker, contentStart);

      if (endIndex == -1) {
        children.add(
          TextSpan(
            text: markedText.substring(startIndex),
            style: normalStyle,
          ),
        );
        break;
      }

      children.add(
        TextSpan(
          text: markedText.substring(contentStart, endIndex),
          style: highlightStyle,
        ),
      );

      cursor = endIndex + endMarker.length;
    }

    return TextSpan(
      style: normalStyle,
      children: children,
    );
  }

  TextSpan _highlightOccurrences({
    required String fullText,
    required String query,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return TextSpan(
        text: fullText,
        style: normalStyle,
      );
    }

    final String escapedQuery = RegExp.escape(trimmedQuery);
    final RegExp regExp = RegExp(
      escapedQuery,
      caseSensitive: false,
      unicode: true,
    );

    final List<RegExpMatch> matches = regExp
        .allMatches(fullText)
        .toList(growable: false);

    if (matches.isEmpty) {
      return TextSpan(
        text: fullText,
        style: normalStyle,
      );
    }

    final List<TextSpan> children = <TextSpan>[];
    int start = 0;

    for (final RegExpMatch match in matches) {
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