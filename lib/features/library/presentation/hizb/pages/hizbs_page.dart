import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../state/hizb_state.dart';
import '../lists/hizbs_list.dart';

class HizbsPage extends StatelessWidget {
  const HizbsPage({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(AppStrings.hizbs),
      ),
      body: Consumer<HizbState>(
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

              return HizbsList(
                scrollController: scrollController,
                hizbsList: hizbState.allHizbs,
              );
            },
          );
        },
      ),
    );
  }
}
