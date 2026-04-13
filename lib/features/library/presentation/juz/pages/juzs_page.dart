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
    final appColors = Theme.of(context).colorScheme;
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
          if (juzState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (juzState.error != null && juzState.allJuzs.isEmpty) {
            return Padding(
              padding: AppStyles.mainPadding,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    '${AppStrings.errorLoadJuzsList}\n${juzState.error}',
                    style: AppStyles.mainTextStyle18,
                    textAlign: .center,
                  ),
                  const SizedBox(height: 7),
                  MaterialButton(
                    onPressed: () {
                      juzState.refreshAllJuzs();
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

          return JuzsList(
            scrollController: scrollController,
            juzsList: juzState.allJuzs,
          );
        },
      ),
    );
  }
}
