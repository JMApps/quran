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

/// Рендер одной страницы Мусхафа.
///
/// Загрузка данных организована в [SurahDetailItem]: шрифт, layout и glyphs
/// стартуют параллельно ещё до того, как этот виджет попадает в дерево.
///
/// Здесь — только fallback-проверка через [ensureFontLoaded]: если по какой-то
/// причине шрифт ещё не готов при build, запросим его без лишней цепочки.
/// Layout и glyphs параллельно тоже проверяются как fallback.
class MushafPageWidget extends StatefulWidget {
  const MushafPageWidget({super.key, required this.pageNumber});

  final int pageNumber;

  @override
  State<MushafPageWidget> createState() => _MushafPageWidgetState();
}

class _MushafPageWidgetState extends State<MushafPageWidget> {
  @override
  void initState() {
    super.initState();
    // Fallback: данные должны уже грузиться из SurahDetailItem.
    // Запускаем параллельно на случай, если виджет попал в дерево
    // раньше, чем SurahDetailItem успел отработать.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureDataLoaded();
    });
  }

  void _ensureDataLoaded() {
    if (!mounted) return;

    // Все три запускаются параллельно — не ждём друг друга.
    Provider.of<MushafFontState>(context, listen: false)
        .ensureFontLoaded(widget.pageNumber);
    Provider.of<PageLayoutState>(context, listen: false)
        .loadPageLines(widget.pageNumber, prefetchNext: false);
    Provider.of<WordGlyphState>(context, listen: false)
        .loadPageWords(widget.pageNumber, prefetchNext: false);
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
    final allSurahs = context.select<SurahState, List<SurahNameEntity>>(
          (s) => s.allSurahs,
    );
    final mushafPageMeta = Provider.of<MushafPageMetaState>(
      context,
      listen: false,
    ).getPageMetaByPage(widget.pageNumber);

    // Показываем индикатор, пока нет шрифта ИЛИ нет layout.
    // Glyphs можно подождать — layout рендерится и без них (surah_name и basmallah).
    if (fontFamily == null || lines.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
      );
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final textColor = appColors.onSurface;

    final header = Padding(
      padding: AppStyles.withoutBottomBigPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber}',
            textDirection: TextDirection.ltr,
          ),
          Text(
            '${AppStrings.surah} ${mushafPageMeta?.nameTranscription}',
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

    final pageContent = _buildPageContent(
      lines: lines,
      glyphs: glyphs,
      fontFamily: fontFamily,
      allSurahs: allSurahs,
      textColor: textColor,
      endAyahColor: appColors.primary,
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
    required List<WordGlyphEntity> glyphs,
    required String fontFamily,
    required List<SurahNameEntity> allSurahs,
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
              words: _getWordsForLine(line, glyphs),
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

  List<WordGlyphEntity> _getWordsForLine(
      LayoutEntity line,
      List<WordGlyphEntity> allGlyphs,
      ) {
    if (line.lineType != LineType.ayah) return const [];
    if (line.firstWordId == null || line.lastWordId == null) return const [];

    return allGlyphs
        .where((w) => w.id >= line.firstWordId! && w.id <= line.lastWordId!)
        .toList(growable: false);
  }
}