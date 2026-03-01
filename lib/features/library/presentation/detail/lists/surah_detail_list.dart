import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_strings.dart';

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
      controller: mushafPageController,
      itemCount: AppStrings.totalPages,
      reverse: true,
      onPageChanged: (int index) {
        context.read<SurahState>().currentPageIndex = index;
      },
      itemBuilder: (context, index) {
        return SurahDetailItem(
          pageIndex: index,
        );
      },
    );
  }
}