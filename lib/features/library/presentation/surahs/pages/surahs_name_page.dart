import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
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
              // Открыть showSearch(context: context, delegate: delegate)
            },
            tooltip: AppStrings.searchByAyahs,
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Consumer<SurahState>(
        builder: (context, surahState, _) {
          if (surahState.isLoading && surahState.allSurahs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Text(AppStrings.loadingData),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          if (surahState.error != null && surahState.allSurahs.isEmpty) {
            return Center(
              child: Padding(
                padding: AppStyles.mainPadding,
                child: Text(
                  '${AppStrings.errorLoadSurahsList}\n${surahState.error}',
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
