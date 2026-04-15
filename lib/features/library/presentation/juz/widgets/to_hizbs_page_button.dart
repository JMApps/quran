import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/strings/app_strings.dart';
import '../../hizb/lists/hizbs_list.dart';
import '../../state/hizb_state.dart';

class ToHizbsPageButton extends StatelessWidget {
  const ToHizbsPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HizbState>(
      builder: (BuildContext context, hizbState, _) {
        if (hizbState.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (hizbState.error != null && hizbState.allHizbs.isEmpty) {
          return IconButton(
            onPressed: () {
              hizbState.refreshAllHizbs();
            },
            icon: const Icon(Icons.refresh_rounded),
          );
        }

        return IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) {
                return HizbsList(allHizbs: hizbState.allHizbs);
              },
            );
          },
          tooltip: AppStrings.hizbs,
          icon: const Icon(Icons.pie_chart),
        );
      },
    );
  }
}
