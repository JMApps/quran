import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/hizb_entity.dart';
import '../../state/hizb_state.dart';
import '../lists/hizbs_list.dart';

class HizbsPage extends StatelessWidget {
  const HizbsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.hizbs),
      ),
      body: Consumer<HizbState>(
        builder: (BuildContext context, hizbState, _) {
          if (hizbState.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (hizbState.error != null && hizbState.allHizbs.isEmpty) {
            return Padding(
              padding: AppStyles.mainPadding,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    '${AppStrings.errorLoadSurahsList}\n${hizbState.error}',
                    style: AppStyles.mainTextStyle18,
                    textAlign: .center,
                  ),
                  const SizedBox(height: 7),
                  MaterialButton(
                    onPressed: () {
                      hizbState.refreshAllHizbs();
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

          final List<HizbEntity> allHizbs = hizbState.allHizbs;

          return HizbsList(
            allHizbs: allHizbs,
          );
        },
      ),
    );
  }
}
