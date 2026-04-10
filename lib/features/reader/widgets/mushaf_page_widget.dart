import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/domain/entities/word_glyph_entity.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/page_layout_state.dart';
import '../../library/presentation/state/surah_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import 'mushaf_line_widget.dart';
class MushafPageWidget extends StatefulWidget {
  const MushafPageWidget({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<MushafPageWidget> createState() => _MushafPageWidgetState();
}

class _MushafPageWidgetState extends State<MushafPageWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    await Provider.of<MushafFontState>(context, listen: false).ensureFontLoaded(widget.pageNumber);
    if (!mounted) return;
    await Provider.of<PageLayoutState>(context, listen: false).loadPageLines(widget.pageNumber);
    if (!mounted) return;
    Provider.of<WordGlyphState>(context, listen: false).loadPageWords(widget.pageNumber, prefetchNext: false);
  }

  @override
  Widget build(BuildContext context) {
    final lines = context.select<PageLayoutState, List<LayoutEntity>>((s) => s.getPageLines(widget.pageNumber));
    final glyphs = context.select<WordGlyphState, List<WordGlyphEntity>>((s) => s.getPageWords(widget.pageNumber),);
    final fontFamily = context.select<MushafFontState, String?>((s) => s.fontFamilyForPage(widget.pageNumber),);
    final allSurahs = context.select<SurahState, List<SurahNameEntity>>((s) => s.allSurahs);
    if (lines.isEmpty || fontFamily == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
      );
    }
    return Directionality(
      textDirection: .rtl,
      child: Center(
        child: SingleChildScrollView(
          padding: const .symmetric(horizontal: 14, vertical: 7),
          child: Column(
            children: lines.map((line) {
              final lineWords = _getWordsForLine(line, glyphs);
              return MushafLineWidget(
                line: line,
                words: lineWords,
                fontFamily: fontFamily,
                allSurahs: allSurahs,
                pageNumber: widget.pageNumber,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<WordGlyphEntity> _getWordsForLine(LayoutEntity line, List<WordGlyphEntity> allGlyphs) {
    if (line.lineType != LineType.ayah) return [];
    if (line.firstWordId == null || line.lastWordId == null) return [];

    return allGlyphs.where((w) => w.id >= line.firstWordId! && w.id <= line.lastWordId!).toList();
  }
}