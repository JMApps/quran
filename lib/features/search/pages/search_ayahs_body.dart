import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/data/repositories/ayah_by_ayah_repository_impl.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../lists/ayah_search_list.dart';

class SearchAyahsBody extends StatelessWidget {
  const SearchAyahsBody({
    super.key,
    required this.query,
    required this.dataTable,
    required this.ftsTable,
  });

  final String query;
  final String dataTable;
  final String ftsTable;

  List<String> _extractTokens(String value) {
    final String cleaned = value.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.isEmpty) return const <String>[];

    return cleaned.split(' ').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(growable: false);
  }

  int _countOccurrencesInText({required String text, required List<String> tokens, required bool caseSensitive}) {
    if (text.isEmpty || tokens.isEmpty) return 0;

    int total = 0;
    for (final token in tokens) {
      total += RegExp(
        RegExp.escape(token),
        caseSensitive: caseSensitive,
        unicode: true,
      ).allMatches(text).length;
    }
    return total;
  }

  int _countSearchMatches({required List<AyahByAyahEntity> result, required String query}) {
    final String trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return 0;

    final bool isArabicQuery = AppStrings.containsArabic(trimmedQuery);

    final String effectiveQuery = isArabicQuery ? AyahByAyahRepositoryImpl.normalizeArabic(trimmedQuery) : trimmedQuery;

    final List<String> tokens = _extractTokens(effectiveQuery);
    if (tokens.isEmpty) return 0;

    int total = 0;
    for (final ayah in result) {
      total += _countOccurrencesInText(
        text: isArabicQuery ? ayah.ayahArabic : ayah.ayahTranslation,
        tokens: tokens,
        caseSensitive: isArabicQuery,
      );
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
          style: AppStyles.mainTextStyle18,
        ),
      );
    }

    return FutureBuilder<List<AyahByAyahEntity>>(
      future: Provider.of<AyahByAyahState>(context, listen: false).searchAyahs(
        query: trimmedQuery,
        dataTable: dataTable,
        ftsTable: ftsTable,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: Text(
                '${AppStrings.errorSearch}${snapshot.error}',
                style: AppStyles.mainTextStyle18,
              ),
            ),
          );
        }

        final result = snapshot.data ?? const <AyahByAyahEntity>[];

        if (result.isEmpty) {
          return const Center(
            child: Text(
              AppStrings.searchNoResults,
              style: AppStyles.mainTextStyle18,
            ),
          );
        }

        final int totalMatches = _countSearchMatches(result: result, query: trimmedQuery);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: AppStyles.miniPadding,
              color: appColors.tertiaryContainer,
              child: Text(
                '${AppStrings.searchByQuery} "$trimmedQuery" ${AppStrings.plural(totalMatches, AppStrings.foundOne, AppStrings.foundFew, AppStrings.foundMany)} $totalMatches ${AppStrings.plural(totalMatches, AppStrings.resultOne, AppStrings.resultFew, AppStrings.resultMany)}',
                style: AppStyles.mediumTextStyle16,
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