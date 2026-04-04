import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../../library/domain/entities/layout_entity.dart';
import '../../../library/domain/entities/surah_name_entity.dart';
import '../../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/page_layout_state.dart';
import '../../../library/presentation/state/surah_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  late final int _pageNumber;
  final String tableName = 'Table_of_translation_kuliev';

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
    await Provider.of<PageLayoutState>(context, listen: false).loadPageLines(_pageNumber);
    if (!mounted) return;
    await Provider.of<AyahByAyahState>(context, listen: false)
        .loadPageAyahs(pageNumber: _pageNumber, tableName: tableName);
    if (!mounted) return;
    Provider.of<PageLayoutState>(context, listen: false).trimCache(currentPage: _pageNumber);
  }

  void _prefetchNextPage() {
    final nextPage = _pageNumber + 1;
    Provider.of<PageLayoutState>(context, listen: false)
        .loadPageLines(nextPage, prefetchNext: false);
    Provider.of<AyahByAyahState>(context, listen: false).loadPageAyahs(
      pageNumber: nextPage,
      tableName: tableName,
      prefetchNext: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = context.select<PageLayoutState, List<LayoutEntity>>(
          (s) => s.getPageLines(_pageNumber),
    );

    final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
          (s) => s.getPageAyahs(pageNumber: _pageNumber, tableName: tableName),
    );

    final allSurahs = context.select<SurahState, List<SurahNameEntity>>(
          (s) => s.allSurahs,
    );

    return Consumer<MushafPageMetaState>(
      builder: (context, mushafPageMetaState, _) {
        return mushafPageMetaState.translationState
            ? AyahByAyahList(
          ayahsPage: ayahs,
          allSurahs: allSurahs,
        )
            : const SizedBox();
      },
    );
  }
}