import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/surah_state.dart';
import '../items/mushaf_page_item.dart';

class MushafPagesList extends StatelessWidget {
  const MushafPagesList({
    super.key,
    required this.mushafPageController,
  });

  final PageController mushafPageController;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: mushafPageController,
      itemCount: 604,
      reverse: true,
      onPageChanged: (int page) {
        Provider.of<SurahState>(context, listen: false).currentPageNumber = page;
      },
      itemBuilder: (context, index) {
        return const MushafPageItem();
      },
    );
  }
}
