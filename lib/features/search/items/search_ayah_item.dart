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

    final TextStyle highlightStyleArabic = arabicStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
    );

    final TextStyle highlightStyleTranslation = translationStyle.copyWith(
      backgroundColor: appColors.tertiaryContainer,
      fontWeight: FontWeight.w700,
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

  List<String> _extractTokens(String value) {
    final String cleaned = value.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) {
      return const <String>[];
    }

    final List<String> tokens = cleaned.split(' ').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList(growable: false);

    tokens.sort((a, b) => b.length.compareTo(a.length));
    return tokens;
  }

  TextSpan _highlightOccurrences({required String fullText, required String query, required TextStyle normalStyle, required TextStyle highlightStyle, required bool caseSensitive}) {
    final List<String> tokens = _extractTokens(query);

    if (fullText.isEmpty || tokens.isEmpty) {
      return TextSpan(
        text: fullText,
        style: normalStyle,
      );
    }

    final String pattern = tokens.map(RegExp.escape).join('|');
    final RegExp regExp = RegExp(
      pattern,
      caseSensitive: caseSensitive,
      unicode: true,
    );

    final List<RegExpMatch> matches = regExp.allMatches(fullText).toList(growable: false);

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