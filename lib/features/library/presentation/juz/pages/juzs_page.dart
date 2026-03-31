import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../hizb/lists/hizbs_list.dart';
import '../../state/hizb_state.dart';
import '../../state/juz_state.dart';
import '../lists/juzs_list.dart';

class JuzsPage extends StatelessWidget {
  const JuzsPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.juzs),
        actions: [
          Consumer<HizbState>(
            builder: (BuildContext context, hizbState, _) {
              return Builder(
                builder: (context) {
                  if (hizbState.isLoading && hizbState.allHizbs.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (hizbState.error != null && hizbState.allHizbs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: AppStyles.mainPadding,
                        child: Text(
                          '${AppStrings.errorLoadHizbsList}\n${hizbState.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) {
                          return HizbsList(hizbsList: hizbState.allHizbs);
                        },
                      );
                    },
                    tooltip: AppStrings.hizbs,
                    icon: const Icon(Icons.pie_chart),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<JuzState>(
        builder: (context, juzState, _) {
          return Builder(
            builder: (context) {
              if (juzState.isLoading && juzState.allJuzs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (juzState.error != null && juzState.allJuzs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: AppStyles.mainPadding,
                    child: Text(
                      '${AppStrings.errorLoadJuzsList}\n${juzState.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return JuzsList(
                scrollController: scrollController,
                juzsList: juzState.allJuzs,
              );
            },
          );
        },
      ),
    );
  }
}
