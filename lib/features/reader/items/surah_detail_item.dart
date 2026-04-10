import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../library/presentation/state/page_layout_state.dart';
import '../../library/presentation/state/surah_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../lists/ayah_by_ayah_list.dart';
import '../widgets/mushaf_page_widget.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
    required this.tableName,
    required this.ayahPosition,
  });

  final int index;
  final String tableName;
  final int ayahPosition;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  late final int _pageNumber;

  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SurahState>(context, listen: false).loadAllSurahs();
      if (!mounted) return;
      await _loadCurrentPage();

      if (!mounted) return;
      _prefetchNextPage();
    });
  }

  Future<void> _loadCurrentPage() async {
    if (!mounted) return;
    await Provider.of<MushafFontState>(context, listen: false).ensureFontLoaded(_pageNumber);
    if (!mounted) return;
    Provider.of<WordGlyphState>(context, listen: false).loadPageWords(_pageNumber, prefetchNext: false);
    if (!mounted) return;
    await Provider.of<PageLayoutState>(context, listen: false).loadPageLines(_pageNumber);
    if (!mounted) return;
    await Provider.of<AyahByAyahState>(context, listen: false).loadPageAyahs(pageNumber: _pageNumber, tableName: widget.tableName);
  }

  void _prefetchNextPage() {
    final nextPage = _pageNumber + 1;
    if (nextPage > 604) return;
    Provider.of<MushafFontState>(context, listen: false).onPageChanged(nextPage);
    Provider.of<WordGlyphState>(context, listen: false).loadPageWords(nextPage, prefetchNext: true);
    Provider.of<PageLayoutState>(context, listen: false).loadPageLines(nextPage);
    Provider.of<AyahByAyahState>(context, listen: false).loadPageAyahs(pageNumber: nextPage, tableName: widget.tableName);
  }

  @override
  Widget build(BuildContext context) {
    final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>((s) => s.getPageAyahs(pageNumber: _pageNumber, tableName: widget.tableName),);
    final allSurahs = context.select<SurahState, List<SurahNameEntity>>((s) => s.allSurahs,);

    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        if (mushafPageMetaState.translationEnabled) {
          return AyahByAyahList(
            ayahsPage: ayahs,
            allSurahs: allSurahs,
            ayahPosition: widget.ayahPosition,
          );
        }
        return MushafPageWidget(pageNumber: _pageNumber);
      },
    );
  }
}