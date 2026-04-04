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
        if (hizbState.isLoading && hizbState.allHizbs.isEmpty) {
          return const SizedBox();
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
  }
}
