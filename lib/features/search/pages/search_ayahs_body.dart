import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../lists/ayah_search_list.dart';

class SearchAyahsBody extends StatelessWidget {
  const SearchAyahsBody({
    super.key,
    required this.query,
    required this.tableName,
  });

  final String query;
  final String tableName;

  int _countMarkerOccurrences({
    required String? markedText,
    required String startMarker,
  }) {
    if (markedText == null || markedText.isEmpty) {
      return 0;
    }

    return startMarker.allMatches(markedText).length;
  }

  int _countSearchMatches({
    required List<AyahByAyahEntity> result,
    required String query,
  }) {
    final String trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return 0;
    }

    final bool isArabicQuery = AppStrings.containsArabic(trimmedQuery);

    int total = 0;

    for (final ayah in result) {
      if (isArabicQuery) {
        total += _countMarkerOccurrences(
          markedText: ayah.highlightedArabic,
          startMarker: AppStrings.arabicHighlightStart,
        );
      } else {
        total += _countMarkerOccurrences(
          markedText: ayah.highlightedTranslation,
          startMarker: AppStrings.translationHighlightStart,
        );
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.enterSearchQueryMessage,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      );
    }

    return FutureBuilder<List<AyahByAyahEntity>>(
      future: Provider.of<AyahByAyahState>(context, listen: false).searchAyahs(
        query: trimmedQuery,
        tableName: tableName,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text('${AppStrings.errorSearch}${snapshot.error}'),
            ),
          );
        }

        final result = snapshot.data ?? const <AyahByAyahEntity>[];

        if (result.isEmpty) {
          return const Center(
            child: Text(
              AppStrings.searchNoResults,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          );
        }

        final int totalMatches = _countSearchMatches(
          result: result,
          query: trimmedQuery,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: AppStyles.mainPadding,
              color: appColors.tertiaryContainer,
              child: Text(
                '${AppStrings.searchByQuery} "$trimmedQuery" '
                    '${AppStrings.plural(totalMatches, AppStrings.foundOne, AppStrings.foundFew, AppStrings.foundMany)} '
                    '$totalMatches '
                    '${AppStrings.plural(totalMatches, AppStrings.resultOne, AppStrings.resultFew, AppStrings.resultMany)}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: AppStrings.fontGilroyMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: AyahSearchList(
                searchResultList: result,
                query: trimmedQuery,
              ),
            ),
          ],
        );
      },
    );
  }
}