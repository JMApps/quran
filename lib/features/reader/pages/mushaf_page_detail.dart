import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../lists/mushaf_page_detail_list.dart';
import '../widgets/mushaf_page_app_bar.dart';

class MushafPageDetail extends StatefulWidget {
  final int pageNumber;

  const MushafPageDetail({
    super.key,
    required this.pageNumber,
  });

  @override
  State<MushafPageDetail> createState() => _MushafPageDetailState();
}

class _MushafPageDetailState extends State<MushafPageDetail> {
  late final PageController _translationController;

  @override
  void initState() {
    super.initState();
    _translationController = PageController(
      initialPage: widget.pageNumber - 1,
    );
  }

  @override
  void dispose() {
    _translationController.dispose();
    unawaited(_showSystemUiWithDelay());
    super.dispose();
  }

  Future<void> _showSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  Future<void> _hideSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 125));
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentPageNumber = context.select<MainState, int>((e) => e.currentPage);
    final PageMetaEntity? pageMetaModel = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(currentPageNumber));
    final SurahNameEntity? surahNameModel = pageMetaModel == null ? null : context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber));
    if (pageMetaModel == null || surahNameModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<FavoritesState>().addLastOpenedPage(currentPageNumber);
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MushafPageAppBar(
            currentPageNumber: currentPageNumber,
            pageMetaModel: pageMetaModel,
            surahNameModel: surahNameModel,
            translationController: _translationController,
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final surahState = Provider.of<SurahNameState>(context, listen: false);
            surahState.toggleShowAppBar();
            surahState.showAppBar ? _showSystemUiWithDelay() : _hideSystemUiWithDelay();
          },
          child: MushafPageDetailList(
            currentPage: currentPageNumber,
            translationController: _translationController,
          ),
        ),
      ),
    );
  }
}
