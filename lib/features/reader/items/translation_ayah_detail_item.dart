import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../state/ayah_by_ayah_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class TranslationAyahDetailItem extends StatelessWidget {
  const TranslationAyahDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final pageNumber = index + 1;

    final isLoaded = context.select<AyahByAyahState, bool>((s) => s.isPageLoaded(pageNumber: pageNumber));
    final error = context.select<AyahByAyahState, Object?>((s) => s.isPageError(pageNumber: pageNumber));
    final ayahsPage = context.select<AyahByAyahState, List<AyahByAyahEntity>>((s) => s.getPageAyahs(pageNumber: pageNumber));

    if (error != null) {
      return const Center(
        child: Icon(
          Icons.error_rounded,
          size: 75.0,
        ),
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
