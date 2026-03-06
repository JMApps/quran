import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../state/surah_state.dart';
import '../lists/surahs_name_list.dart';

class SurahNamePage extends StatefulWidget {
  const SurahNamePage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<SurahNamePage> createState() => _SurahNamePageState();
}

class _SurahNamePageState extends State<SurahNamePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SurahState>().loadAllSurahs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final surahState = context.watch<SurahState>();
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
      body: Builder(
        builder: (context) {
          if (surahState.isLoading && surahState.allSurahs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
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
            scrollController: widget.scrollController,
            surahsList: surahState.allSurahs,
          );
        },
      ),
    );
  }
}
