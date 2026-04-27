import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../lists/mushaf_page_detail_list.dart';
import '../state/mushaf_page_number_state.dart';
import '../state/show_app_bar_state.dart';
import '../state/translation_mode_state.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentPageNumber = context.select<MushafPageNumberState, int>((e) => e.currentPageNumber);
    final PageMetaEntity? pageMetaModel = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(currentPageNumber));
    final SurahNameEntity? surahNameModel = pageMetaModel == null ? null : context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber));
    if (pageMetaModel == null || surahNameModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<FavoritesState>().addLastOpenedPage(currentPageNumber);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ShowAppBarState(),
          ),
          ChangeNotifierProvider(
            create: (_) => TranslationModeState(),
          ),
        ],
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
          body: Consumer<ShowAppBarState>(
            builder: (context, showAppBarState, _) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showAppBarState.changeShowingAppBar();
                },
                child: MushafPageDetailList(
                  currentPageNumber: currentPageNumber,
                  translationController: _translationController,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
