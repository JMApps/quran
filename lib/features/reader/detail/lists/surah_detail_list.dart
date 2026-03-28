import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/surah_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.mushafPageController,
  });

  final PageController mushafPageController;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList> with WidgetsBindingObserver {
  late final MushafPageMetaState _mushafPageMetaState;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentPage = Provider.of<SurahState>(context, listen: false).currentMushafPage;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mushafPageMetaState = Provider.of<MushafPageMetaState>(context, listen: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _mushafPageMetaState.addLastOpenedPage(_currentPage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: true,
      controller: widget.mushafPageController,
      itemCount: AppStrings.totalPages,
      onPageChanged: (int index) {
        Provider.of<SurahState>(context, listen: false).mushafCurrentPage = index + 1;
        _currentPage = index + 1;
      },
      itemBuilder: (context, index) {
        return SurahDetailItem(
          index: index,
        );
      },
    );
  }
}
