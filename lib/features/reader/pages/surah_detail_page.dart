import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/favorites_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../lists/surah_detail_list.dart';
import '../widgets/favorite_mushaf_page_button.dart';
import '../widgets/to_mushaf_page_button.dart';
import '../widgets/translate_mushaf_page_button.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.currentMushafPage,
    required this.ayahPosition,
  });

  final int currentMushafPage;
  final int ayahPosition;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final PageController _mushafPageController;

  @override
  void initState() {
    super.initState();
    _mushafPageController = PageController(initialPage: widget.currentMushafPage - 1);
  }

  @override
  void dispose() {
    _showSystemUiWithDelay();
    _mushafPageController.dispose();
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
    final int currentPage = context.select<SurahNameState, int>((s) => s.currentPage);
    final mushafPageMeta = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(currentPage));
    final surahModel = context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahById(surahNumber: mushafPageMeta!.surahNumber));
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Provider.of<FavoritesState>(context, listen: false).addLastOpenedPage(currentPage);
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Consumer<SurahNameState>(
            builder: (context, surahState, _) {
              return AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                offset: surahState.showAppBar ? .zero : const Offset(0, -1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: surahState.showAppBar ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !surahState.showAppBar,
                    child: AppBar(
                      elevation: 3.5,
                      titleSpacing: 0,
                      title: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          Text(
                            '${AppStrings.surah} ${surahModel!.nameTranscription}',
                            style: AppStyles.mainTextStyle18,
                          ),
                          Row(
                            children: [
                              Text(
                                '${AppStrings.page} ${mushafPageMeta?.pageNumber}, ',
                                style: AppStyles.mainTextStyle12,
                              ),
                              Text(
                                '${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber}',
                                style: AppStyles.mainTextStyle12,
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        const FavoriteMushafPageButton(),
                        TranslateMushafPageButton(currentMushafPage: surahState.currentPage),
                        ToMushafPageButton(mushafPageController: _mushafPageController),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final surahState = Provider.of<SurahNameState>(context, listen: false);
            surahState.toggleShowAppBar();
            surahState.showAppBar ? _showSystemUiWithDelay() : _hideSystemUiWithDelay();
          },
          child: SurahDetailList(
            mushafPageController: _mushafPageController,
            ayahPosition: widget.ayahPosition,
          ),
        ),
      ),
    );
  }
}
