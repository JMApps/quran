import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_constants.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.mushafPageController,
    required this.ayahPosition,
  });

  final PageController mushafPageController;
  final int ayahPosition;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList>
    with WidgetsBindingObserver {
  late final FavoritesState _favoritesState;
  late final AyahByAyahState _ayahState;
  late int _currentPage;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _currentPage = Provider.of<MainState>(context, listen: false).currentPage;
    _favoritesState = Provider.of<FavoritesState>(context, listen: false);
    _ayahState = Provider.of<AyahByAyahState>(context, listen: false);

    _ayahState.loadPageAyahs(pageNumber: _currentPage);
    _ayahState.prefetchAround(_currentPage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _favoritesState.addLastOpenedPage(_currentPage);
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
      itemCount: AppConstants.totalPagesCount,
      onPageChanged: (int index) {
        _currentPage = index + 1;
        context.read<MainState>().setCurrentPage(_currentPage);
        _ayahState.prefetchAround(_currentPage);
      },
      itemBuilder: (context, index) {
        return SurahDetailItem(
          index: index,
          ayahPosition: widget.ayahPosition,
        );
      },
    );
  }
}