import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_constants.dart';
import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../items/surah_detail_item.dart';

class SurahDetailList extends StatefulWidget {
  const SurahDetailList({
    super.key,
    required this.currentPage,
  });

  final int currentPage;

  @override
  State<SurahDetailList> createState() => _SurahDetailListState();
}

class _SurahDetailListState extends State<SurahDetailList> with WidgetsBindingObserver {
  late final PageController _translationController;
  late final AyahByAyahState _ayahState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _translationController = PageController(initialPage: widget.currentPage - 1);

    _ayahState = context.read<AyahByAyahState>();
    _ayahState.loadPageAyahs(pageNumber: widget.currentPage);
    _ayahState.prefetchAround(widget.currentPage);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      context.read<FavoritesState>().addLastOpenedPage(widget.currentPage);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationEnabled = context.select<PageMetaState, bool>((s) => s.translationEnabled);
    final int? currentPageNumber = context.select<MainState, int?>((e) => e.currentPage);
    final PageMetaEntity? pageMetaModel = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(currentPageNumber!));
    final SurahNameEntity? surahNameModel = context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: pageMetaModel!.surahNumber));
    return PageView.builder(
      controller: _translationController,
      reverse: true,
      physics: const ClampingScrollPhysics(),
      itemCount: AppConstants.totalPagesCount,
      onPageChanged: (pageIndex) {
        int pageNumber = pageIndex + 1;
        context.read<MainState>().onMainPageChanged(pageNumber);
        _ayahState.prefetchAround(pageNumber);
      },
      itemBuilder: (context, index) {
        if (translationEnabled) {
          return SurahDetailItem(
            index: index,
          );
        } else {
          return Padding(
            padding: const .only(top: 28, left: 14, bottom: 7, right: 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.surah} ${surahNameModel!.nameTranscription}',
                    ),
                    Text(
                      '${AppStrings.juz} ${pageMetaModel!.juzNumber}',
                    ),
                  ],
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Рендер страниц мусхафа на стадии разработки',
                      style: AppStyles.mainTextStyle18,
                      textAlign: .center,
                    ),
                  ),
                ),
                Text(
                  '$currentPageNumber',
                  textAlign: .center,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
