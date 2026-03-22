import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_styles.dart';
import '../../../domain/entities/mushaf_page_meta_entity.dart';
import '../../state/mushaf_page_meta_state.dart';
import '../../state/surah_state.dart';
import '../lists/surah_detail_list.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.currentMushafPageIndex,
  });

  final int currentMushafPageIndex;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.currentMushafPageIndex);
  }

  Future<void> _showSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 125));

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _hideSystemUiWithDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 125));

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: const [],
    );
  }

  @override
  void dispose() {
    _showSystemUiWithDelay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topSafePadding = MediaQuery.of(context).padding.top;
    final int mushafPageIndex = context.select<SurahState, int>((s) => s.currentMushafPageIndex);
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>(
      (s) => s.getPageMetaByPageNumber(mushafPageIndex),
    );
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<SurahState>(
          builder: (context, surahState, _) {
            return AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              offset: surahState.showAppBar ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: surahState.showAppBar ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !surahState.showAppBar,
                  child: AppBar(
                    elevation: 5.0,
                    title: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Text('Сура ${mushafPageMeta?.nameTranscription}'),
                        Row(
                          children: [
                            Text(
                              'Страница ${mushafPageMeta?.pageNumber}, ',
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              'джуз ${mushafPageMeta?.juzNumber}',
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border_rounded),
                      ),
                      IconButton(
                        onPressed: () {},
                        visualDensity: const VisualDensity(horizontal: -4),
                        icon: const Icon(Icons.public_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                margin: AppStyles.topMiniPadding,
                                padding: AppStyles.withoutTopPadding,
                                height: 65,
                                child: Consumer<SurahState>(
                                  builder: (context, surahState, _) {
                                    return SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 1.75,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Slider(
                                          showValueIndicator: ShowValueIndicator.alwaysVisible,
                                          value: surahState.currentMushafPageIndex.toDouble(),
                                          label: '${surahState.currentMushafPageIndex + 1}',
                                          min: 0,
                                          max: 603,
                                          divisions: 603,
                                          onChanged: (double value) {
                                            surahState.mushafCurrentPageIndex = value.round();
                                            if (_controller.hasClients) {
                                              _controller.jumpToPage(value.toInt());
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.auto_stories_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: topSafePadding,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final surahState = Provider.of<SurahState>(context, listen: false);
            surahState.toggleShowAppBar();
            surahState.showAppBar ? _showSystemUiWithDelay() : _hideSystemUiWithDelay();
          },
          child: SurahDetailList(
            mushafPageController: _controller,
          ),
        ),
      ),
    );
  }
}
