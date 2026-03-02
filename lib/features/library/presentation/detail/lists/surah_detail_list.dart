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

  int _pageNumberFromIndex(int index) => AppStrings.totalPages - index;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: mushafPageController,
      itemCount: AppStrings.totalPages,
      reverse: false,
      onPageChanged: (int index) {
        // Храним индекс как есть (0..603), но pageNumber считаем через формулу
        context.read<SurahState>().currentPageIndex = index;

        // ВАЖНО: currentPageNumber внутри SurahState должен считаться как totalPages - index
        // иначе заголовок/загрузка страниц будут неверными.
      },
      itemBuilder: (context, index) {
        final pageNumber = _pageNumberFromIndex(index); // 604..1
        return SurahDetailItem(
          pageNumber: pageNumber, // <-- лучше так, чем pageIndex
        );
      },
    );
  }
}
