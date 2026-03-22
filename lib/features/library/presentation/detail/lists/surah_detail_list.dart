import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../state/surah_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatelessWidget {
  const SurahDetailList({
    super.key,
    required this.mushafPageController,
  });

  final PageController mushafPageController;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: true,
      controller: mushafPageController,
      itemCount: AppStrings.totalPages,
      onPageChanged: (int index) {
        Provider.of<SurahState>(context, listen: false).mushafCurrentPageIndex = index;
      },
      itemBuilder: (context, index) {
        return const SurahDetailItem();
      },
    );
  }
}
