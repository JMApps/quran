import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/mushaf_page_meta_entity.dart';
import '../../state/mushaf_page_meta_state.dart';
import '../../state/surah_state.dart';
import '../lists/surah_detail_list.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late final PageController _controller;

  int _indexFromPageNumber(int pageNumber) => AppStrings.totalPages - pageNumber;

  @override
  void initState() {
    super.initState();

    final initialIndex = _indexFromPageNumber(widget.pageNumber);
    _controller = PageController(initialPage: initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurahState>(context, listen: false).mushafCurrentPageIndex = initialIndex;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageNumber = context.select<SurahState, int>((s) => s.currentMushafPage);
    final meta = context.select<MushafPageMetaState, MushafPageMetaEntity?>(
      (s) => s.getPageMetaByPageNumber(pageNumber),
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
                        Text('Сура ${meta?.nameTranscription}'),
                        Row(
                          children: [
                            Text(
                              'Страница ${meta?.pageNumber}, ',
                              style: const TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              'джуз ${meta?.juzNumber}',
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
                        icon: const Icon(Icons.public_outlined),
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
          top: MediaQuery.of(context).padding.top,
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: Provider.of<SurahState>(context, listen: false).toggleShowAppBar,
          child: SurahDetailList(
            mushafPageController: _controller,
          ),
        ),
      ),
    );
  }
}
