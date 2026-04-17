import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../lists/word_glyph_list.dart';

class WordGlyphDetailItem extends StatelessWidget {
  const WordGlyphDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final pageNumber = index + 1;

    final isLoaded = context.select<WordGlyphState, bool>((s) => s.isLoaded(pageNumber));
    final isLoading = context.select<WordGlyphState, bool>((s) => s.isLoading(pageNumber));
    final error = context.select<WordGlyphState, Object?>((s) => s.getError(pageNumber));
    final layoutsPage = context.select<WordGlyphState, List<LayoutEntity>>((s) => s.getPageLines(pageNumber));

    final pageMetaModel = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(index + 1));
    final surahNameModel = pageMetaModel == null ? null : context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber));

    if (error != null) {
      return const Center(
        child: Icon(Icons.error_rounded),
      );
    }

    if (!isLoaded || isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return WordGlyphList(
      surahNameTranscription: surahNameModel!.nameTranscription,
      juzNumber: pageMetaModel!.juzNumber,
      layoutsPage: layoutsPage,
    );
  }
}
