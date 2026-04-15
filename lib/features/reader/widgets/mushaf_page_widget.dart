import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/word_glyph_entity.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/page_layout_state.dart';
import '../../library/presentation/state/page_meta_state.dart';
import '../../library/presentation/state/word_glyph_state.dart';
import 'mushaf_line_widget.dart';

class MushafPageWidget extends StatefulWidget {
  const MushafPageWidget({super.key, required this.pageNumber});

  final int pageNumber;

  @override
  State<MushafPageWidget> createState() => _MushafPageWidgetState();
}

class _MushafPageWidgetState extends State<MushafPageWidget> {
  List<LayoutEntity>? _cachedLines;
  List<WordGlyphEntity>? _cachedGlyphs;
  Map<int, List<WordGlyphEntity>> _wordsByLine = const {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureDataLoaded());
  }

  void _ensureDataLoaded() {
    if (!mounted) return;
    Provider.of<MushafFontState>(context, listen: false)
        .ensureFontLoaded(widget.pageNumber);
    Provider.of<PageLayoutState>(context, listen: false)
        .loadPageLines(widget.pageNumber, prefetchNext: false);
    Provider.of<WordGlyphState>(context, listen: false)
        .loadPageWords(widget.pageNumber, prefetchNext: false);
  }

  void _rebuildWordGroups(
      List<LayoutEntity> lines,
      List<WordGlyphEntity> glyphs,
      ) {
    if (identical(_cachedLines, lines) && identical(_cachedGlyphs, glyphs)) {
      return;
    }
    _cachedLines = lines;
    _cachedGlyphs = glyphs;

    final result = <int, List<WordGlyphEntity>>{};
    int gi = 0;

    for (final line in lines) {
      if (line.lineType != LineType.ayah ||
          line.firstWordId == null ||
          line.lastWordId == null) {
        result[line.lineNumber] = const [];
        continue;
      }

      while (gi < glyphs.length && glyphs[gi].id < line.firstWordId!) {
        gi++;
      }

      final words = <WordGlyphEntity>[];
      int i = gi;
      while (i < glyphs.length && glyphs[i].id <= line.lastWordId!) {
        words.add(glyphs[i++]);
      }
      result[line.lineNumber] = List.unmodifiable(words);
    }

    _wordsByLine = result;
  }

  @override
  Widget build(BuildContext context) {
    final lines = context.select<PageLayoutState, List<LayoutEntity>>(
          (s) => s.getPageLines(widget.pageNumber),
    );
    final glyphs = context.select<WordGlyphState, List<WordGlyphEntity>>(
          (s) => s.getPageWords(widget.pageNumber),
    );
    final fontFamily = context.select<MushafFontState, String?>(
          (s) => s.fontFamilyForPage(widget.pageNumber),
    );

    _rebuildWordGroups(lines, glyphs);

    if (fontFamily == null || lines.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
      );
    }

    final mushafPageMeta =
    context.read<PageMetaState>().getPageMeta(widget.pageNumber);

    final appColors = Theme.of(context).colorScheme;
    final textColor = appColors.onSurface;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final header = Padding(
      padding: AppStyles.withoutBottomBigPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber ?? ""}',
            textDirection: TextDirection.ltr,
          ),
          const Text(
            AppStrings.surah,
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );

    final footer = Padding(
      padding: AppStyles.bottomMiniPadding,
      child: Text(
        '${widget.pageNumber}',
        textDirection: TextDirection.ltr,
      ),
    );

    final pageContent = RepaintBoundary(
      child: _buildPageContent(
        lines: lines,
        fontFamily: fontFamily,
        textColor: textColor,
        endAyahColor: appColors.primary,
      ),
    );

    if (isLandscape) {
      final size = MediaQuery.of(context).size;
      final pageWidth = size.width - 14;
      final pageHeight = pageWidth * (20.5 / 13.5);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: AppStyles.mainPadding,
          child: Column(
            children: [
              header,
              SizedBox(width: pageWidth, height: pageHeight, child: pageContent),
              footer,
            ],
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          header,
          Expanded(
            child: Padding(padding: AppStyles.mainPadding, child: pageContent),
          ),
          footer,
        ],
      ),
    );
  }

  Widget _buildPageContent({
    required List<LayoutEntity> lines,
    required String fontFamily,
    required Color textColor,
    required Color endAyahColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: lines.map((line) {
        return Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: MushafLineWidget(
              line: line,
              words: _wordsByLine[line.lineNumber] ?? const [],
              fontFamily: fontFamily,
              pageNumber: widget.pageNumber,
              textColor: textColor,
              endAyahColor: endAyahColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}