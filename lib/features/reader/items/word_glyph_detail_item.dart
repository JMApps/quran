import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/features/reader/items/word_glyph_item.dart';

import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../state/word_glyph_state.dart';

class WordGlyphDetailItem extends StatelessWidget {
  const WordGlyphDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final pageNumber = index + 1;

    final isLoaded = context.select<WordGlyphState, bool>((s) => s.isLinesLoaded(pageNumber: pageNumber));
    final error = context.select<WordGlyphState, Object?>((s) => s.isLinesError(pageNumber: pageNumber));
    final linesPage = context.select<WordGlyphState, List<LayoutEntity>>((s) => s.getPageLines(pageNumber: pageNumber));

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

    final pageMetaModel = context.select<PageMetaState, PageMetaEntity?>(
      (s) => s.getPageMeta(pageNumber),
    );
    if (pageMetaModel == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final surahNameModel = context.select<SurahNameState, SurahNameEntity?>(
      (s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber),
    );
    if (surahNameModel == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return RepaintBoundary(
      child: WordGlyphItem(
        surahNameTranscription: surahNameModel.nameTranscription,
        juzNumber: pageMetaModel.juzNumber,
        pageNumber: pageNumber,
        layoutsPage: linesPage,
      ),
    );
  }
}
