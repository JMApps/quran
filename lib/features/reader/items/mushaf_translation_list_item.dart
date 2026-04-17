import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../library/presentation/state/ayah_by_ayah_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class MushafTranslationListItem extends StatefulWidget {
  const MushafTranslationListItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<MushafTranslationListItem> createState() => _MushafTranslationListItemState();
}

class _MushafTranslationListItemState extends State<MushafTranslationListItem> {
  @override
  void initState() {
    super.initState();
    context.read<AyahByAyahState>().loadPageAyahs(pageNumber: widget.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final pageNumber = widget.index + 1;

    final isLoaded = context.select<AyahByAyahState, bool>((s) => s.isPageLoaded(pageNumber: pageNumber));
    final error = context.select<AyahByAyahState, Object?>((s) => s.getPageError(pageNumber: pageNumber));
    final ayahsPage = context.select<AyahByAyahState, List<AyahByAyahEntity>>((s) => s.getPageAyahs(pageNumber: pageNumber));

    if (error != null) {
      return const Center(
        child: Icon(Icons.error_rounded),
      );
    }

    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return AyahByAyahList(
      ayahsPage: ayahsPage,
    );
  }
}