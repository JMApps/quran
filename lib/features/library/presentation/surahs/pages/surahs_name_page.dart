import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../search/pages/search_ayahs_delegate.dart';
import '../../state/surah_name_state.dart';
import '../lists/surahs_name_list.dart';

class SurahNamePage extends StatelessWidget {
  const SurahNamePage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
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
                ),
              );
            },
            tooltip: AppStrings.searchByAyahs,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Consumer<SurahNameState>(
        builder: (context, surahState, _) {
          if (surahState.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (surahState.error != null && surahState.allSurahs.isEmpty) {
            return Padding(
              padding: AppStyles.mainPadding,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    '${AppStrings.errorLoadSurahsList}\n${surahState.error}',
                    style: AppStyles.mainTextStyle18,
                    textAlign: .center,
                  ),
                  const SizedBox(height: 7),
                  MaterialButton(
                    onPressed: () {
                      surahState.refreshAllSurahs();
                    },
                    elevation: 0.25,
                    color: appColors.secondaryContainer,
                    shape: AppStyles.mainShape,
                    child: const Text(
                      AppStrings.retry,
                      style: AppStyles.mainTextStyle16,
                    ),
                  ),
                ],
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
