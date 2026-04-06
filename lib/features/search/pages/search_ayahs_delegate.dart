import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';
import 'search_ayahs_body.dart';

class SearchAyahsDelegate extends SearchDelegate<void> {
  SearchAyahsDelegate({required this.searchField, required this.dataTable, required this.ftsTable}) : super(
    searchFieldLabel: searchField,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );

  final String searchField;
  final String dataTable;
  final String ftsTable;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        titleSpacing: 0,
      ),
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
            showSuggestions(context);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: transitionAnimation,
          ),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: AppStyles.leftMainPadding,
      child: IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchAyahsBody(
      query: query,
      dataTable: dataTable,
      ftsTable: ftsTable,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchAyahsBody(
      query: query,
      dataTable: dataTable,
      ftsTable: ftsTable,
    );
  }
}
