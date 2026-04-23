import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/page_meta_entity.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/surah_name_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import '../lists/word_glyph_list.dart';
import '../widgets/glyph_page_snapshot.dart';

class WordGlyphDetailItem extends StatelessWidget {
  const WordGlyphDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final pageNumber = index + 1;

    final snapshot = context.select<WordGlyphState, GlyphPageSnapshot>(
          (s) => GlyphPageSnapshot(
        isLoaded: s.isLoaded(pageNumber),
        error: s.getError(pageNumber),
        lines: s.getPageLines(pageNumber),
      ),
    );

    if (snapshot.error != null) {
      return const Center(child: Icon(Icons.error_rounded));
    }
    if (!snapshot.isLoaded) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final pageMetaModel = context.select<PageMetaState, PageMetaEntity?>((s) => s.getPageMeta(pageNumber));
    if (pageMetaModel == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final surahNameModel = context.select<SurahNameState, SurahNameEntity?>((s) => s.getSurahByNumber(surahNumber: pageMetaModel.surahNumber));
    if (surahNameModel == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return RepaintBoundary(
      child: WordGlyphList(
        surahNameTranscription: surahNameModel.nameTranscription,
        juzNumber: pageMetaModel.juzNumber,
        layoutsPage: snapshot.lines,
      ),
    );
  }
}
