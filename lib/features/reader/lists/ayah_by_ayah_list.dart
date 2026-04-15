import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/theme/app_styles.dart';
import '../../library/data/mappers/ayah_list_row_builder.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/ayah_list_row.dart';
import '../../library/domain/entities/ayah_list_row_type.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/main_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../items/ayah_by_ayah_item.dart';
import '../items/basmallah_item.dart';
import '../items/surah_header_item.dart';

class AyahByAyahList extends StatefulWidget {
  const AyahByAyahList({
    super.key,
    required this.ayahsPage,
    required this.ayahPosition,
  });

  final List<AyahByAyahEntity> ayahsPage;
  final int ayahPosition;

  @override
  State<AyahByAyahList> createState() => _AyahByAyahListState();
}

class _AyahByAyahListState extends State<AyahByAyahList> {
  late final ItemScrollController _itemScrollController;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();

    if (widget.ayahPosition >= 0) {
      _scrollToIndex(widget.ayahPosition);
    }
  }

  void _scrollToIndex(int index) {
    if (_itemScrollController.isAttached) {
      _itemScrollController.jumpTo(
        index: index,
        alignment: 0.0,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) _scrollToIndex(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.select<MainState, int>((s) => s.currentPage);
    final mushafPageMeta = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(currentPage));
    final surahModel = context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: mushafPageMeta!.surahNumber));
    final rows = const AyahListRowBuilder().build(widget.ayahsPage);
    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      padding: AppStyles.vrMainPadding,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final AyahListRow row = rows[index];
        switch (row.type) {
          case AyahListRowType.surahHeader:
            return SurahHeaderItem(
              surahName: surahModel!.nameTranscription,
              surahNumber: row.surahNumber!,
            );

          case AyahListRowType.basmallah:
            return const BasmallahItem();

          case AyahListRowType.ayah:
            return AyahByAyahItem(
              ayahByAyahModel: row.ayah!,
              index: index,
            );
        }
      },
    );
  }
}