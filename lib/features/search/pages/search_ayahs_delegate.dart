import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/strings/app_strings.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../lists/ayah_search_list.dart';

class SearchAyahsDelegate extends SearchDelegate<void> {
  SearchAyahsDelegate({
    required this.searchField,
    required this.tableName,
  }) : super(
         searchFieldLabel: searchField,
         keyboardType: TextInputType.text,
         textInputAction: TextInputAction.search,
       );

  final String searchField;
  final String tableName;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            _onQueryChanged(() {
              showSuggestions(context);
            });
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: transitionAnimation,
          ),
        ),
    ];
  }

  Timer? _debounce;

  void _onQueryChanged(VoidCallback callback) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1250), callback);
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchAyahsBody(
      query: query,
      tableName: tableName,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchAyahsBody(
      query: query,
      tableName: tableName,
    );
  }
}

class _SearchAyahsBody extends StatelessWidget {
  const _SearchAyahsBody({
    required this.query,
    required this.tableName,
  });

  final String query;
  final String tableName;

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
      future: context.read<AyahByAyahState>().searchAyahs(
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
              padding: const EdgeInsets.all(16),
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

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            Container(
              padding: AppStyles.mainPadding,
              color: appColors.tertiaryContainer,
              child: Text(
                'По запросу "${query.trim()}" ${AppStrings.plural(result.length, 'найден', 'найдено', 'найдены')} ${result.length} ${AppStrings.plural(result.length, 'результат', 'результата', 'результатов')}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: AppStrings.fontGilroyMedium,
                ),
                textAlign: .center,
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
