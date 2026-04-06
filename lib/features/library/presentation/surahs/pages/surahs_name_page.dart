import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../search/pages/search_ayahs_delegate.dart';
import '../../state/surah_state.dart';
import '../lists/surahs_name_list.dart';

class SurahNamePage extends StatelessWidget {
  const SurahNamePage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchAyahsDelegate(
                  searchField: AppStrings.searchByAyahs,
                  dataTable: 'Table_of_translation_kuliev',
                  ftsTable: 'translation_kuliev_fts'
                ),
              );
            },
            tooltip: AppStrings.searchByAyahs,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Consumer<SurahState>(
        builder: (context, surahState, _) {
          if (surahState.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (surahState.error != null) {
            return Center(
              child: Padding(
                padding: AppStyles.mainPadding,
                child: Text(
                  '${AppStrings.errorLoadSurahsList}\n${surahState.error}',
                  style: AppStyles.mainTextStyle18,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return SurahsNameList(
            scrollController: scrollController,
            surahsList: surahState.allSurahs,
          );
        },
      ),
    );
  }
}
