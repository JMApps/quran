import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../state/juz_state.dart';
import '../lists/juzs_list.dart';
import '../widgets/to_hizbs_page_button.dart';

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
        actions: const [
          ToHizbsPageButton(),
        ],
      ),
      body: Consumer<JuzState>(
        builder: (context, juzState, _) {
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
                  textAlign: .center,
                ),
              ),
            );
          }

          return JuzsList(
            scrollController: scrollController,
            juzsList: juzState.allJuzs,
          );
        },
      ),
    );
  }
}
