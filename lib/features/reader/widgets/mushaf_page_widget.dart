import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/surah_name_entity.dart';
import '../../library/domain/entities/word_glyph_entity.dart';
import '../../library/presentation/state/mushaf_font_state.dart';
import '../../library/presentation/state/mushaf_page_meta_state.dart';
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
    Provider.of<WordGlyphState>(
      context,
      listen: false,
    ).loadPageWords(widget.pageNumber, prefetchNext: false);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;

    final lines = context.select<PageLayoutState, List<LayoutEntity>>(
      (s) => s.getPageLines(widget.pageNumber),
    );
    final glyphs = context.select<WordGlyphState, List<WordGlyphEntity>>(
      (s) => s.getPageWords(widget.pageNumber),
    );
    final fontFamily = context.select<MushafFontState, String?>(
      (s) => s.fontFamilyForPage(widget.pageNumber),
    );
    final allSurahs = context.select<SurahState, List<SurahNameEntity>>((s) => s.allSurahs);

    final mushafPageMeta = Provider.of<MushafPageMetaState>(
      context,
      listen: false,
    ).getPageMetaByPage(widget.pageNumber);

    if (lines.isEmpty || fontFamily == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
      );
    }

    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final textColor = appColors.onSurface;

    final header = Padding(
      padding: AppStyles.withoutBottomBigPadding,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            '${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber}',
            textDirection: .ltr,
          ),
          Text(
            '${AppStrings.surah} ${mushafPageMeta?.nameTranscription}',
            textDirection: .ltr,
          ),
        ],
      ),
    );

    final footer = Padding(
      padding: AppStyles.bottomMiniPadding,
      child: Text(
        '${widget.pageNumber}',
        textDirection: .ltr,
      ),
    );

    if (isLandscape) {
      final pageWidth = size.width - 14;
      final pageHeight = pageWidth * (20.5 / 13.5);

      return Directionality(
        textDirection: .rtl,
        child: SingleChildScrollView(
          padding: AppStyles.mainPadding,
          child: Column(
            children: [
              header,
              SizedBox(
                width: pageWidth,
                height: pageHeight,
                child: _buildPageContent(
                  isLandscape,
                  lines,
                  glyphs,
                  fontFamily,
                  allSurahs,
                  textColor,
                  appColors.primary,
                ),
              ),
              footer,
            ],
          ),
        ),
      );
    }

    return Directionality(
      textDirection: .rtl,
      child: Column(
        children: [
          header,
          Expanded(
            child: Padding(
              padding: AppStyles.mainPadding,
              child: _buildPageContent(
                isLandscape,
                lines,
                glyphs,
                fontFamily,
                allSurahs,
                textColor,
                appColors.primary,
              ),
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Widget _buildPageContent(
    bool isLandscape,
    List<LayoutEntity> lines,
    List<WordGlyphEntity> glyphs,
    String fontFamily,
    List<SurahNameEntity> allSurahs,
    Color textColor,
    Color endAyahColor,
  ) {
    return Column(
      mainAxisAlignment: .spaceBetween,
      children: lines.map((line) {
        final lineWords = _getWordsForLine(line, glyphs);
        return Expanded(
          child: FittedBox(
            fit: isLandscape ? .scaleDown : .scaleDown,
            child: MushafLineWidget(
              line: line,
              words: lineWords,
              fontFamily: fontFamily,
              allSurahs: allSurahs,
              pageNumber: widget.pageNumber,
              textColor: textColor,
              endAyahColor: endAyahColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<WordGlyphEntity> _getWordsForLine(LayoutEntity line, List<WordGlyphEntity> allGlyphs) {
    if (line.lineType != LineType.ayah) return [];
    if (line.firstWordId == null || line.lastWordId == null) return [];

    return allGlyphs.where((w) => w.id >= line.firstWordId! && w.id <= line.lastWordId!).toList();
  }
}
