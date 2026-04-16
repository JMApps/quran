import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/theme/app_styles.dart';
import '../../library/data/mappers/ayah_list_row_builder.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/domain/entities/ayah_list_row.dart';
import '../../library/domain/entities/ayah_list_row_type.dart';
import '../items/ayah_by_ayah_item.dart';
import '../items/basmallah_item.dart';
import '../items/surah_header_item.dart';

class AyahByAyahList extends StatefulWidget {
  const AyahByAyahList({
    super.key,
    required this.ayahsPage,
  });

  final List<AyahByAyahEntity> ayahsPage;

  @override
  State<AyahByAyahList> createState() => _AyahByAyahListState();
}

class _AyahByAyahListState extends State<AyahByAyahList> {
  late final ItemScrollController _itemScrollController;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();
    _scrollToIndex(0);
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