import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/mushaf_font_loader.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../../../library/domain/entities/layout_entity.dart';
import '../../../library/domain/entities/line_type.dart';
import '../../../library/domain/entities/mushaf_page_meta_entity.dart';
import '../../../library/presentation/state/ayah_by_ayah_state.dart';
import '../../../library/presentation/state/mushaf_page_meta_state.dart';
import '../../../library/presentation/state/page_layout_state.dart';
import '../lists/ayah_by_ayah_list.dart';

class SurahLigatures {
  static String surahNameByNumber(int surahNumber) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw StateError('Invalid surah number: $surahNumber');
    }
    return 'surah${surahNumber.toString().padLeft(3, '0')}';
  }

  static const String surahIcon = 'surah-icon';
}

class SurahDetailItem extends StatefulWidget {
  const SurahDetailItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<SurahDetailItem> createState() => _SurahDetailItemState();
}

class _SurahDetailItemState extends State<SurahDetailItem> {
  late final int _pageNumber;
  final String tableName = 'Table_of_translation_kuliev';

  @override
  void initState() {
    super.initState();
    _pageNumber = widget.index + 1;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCurrentPage();
      if (!mounted) return;
      _prefetchNextPage();
    });
  }

  Future<void> _loadCurrentPage() async {
    await MushafFontLoader.instance.loadPageFont(_pageNumber);
    if (!mounted) return;

    await context.read<PageLayoutState>().loadPageLines(_pageNumber);
    if (!mounted) return;

    await context.read<AyahByAyahState>().loadPageAyahs(
      pageNumber: _pageNumber,
      tableName: tableName,
    );
    if (!mounted) return;

    context.read<PageLayoutState>().trimCache(currentPage: _pageNumber);
  }

  void _prefetchNextPage() {
    final nextPage = _pageNumber + 1;

    MushafFontLoader.instance.loadPageFont(nextPage);

    context.read<PageLayoutState>().loadPageLines(
      nextPage,
      prefetchNext: false,
    );

    context.read<AyahByAyahState>().loadPageAyahs(
      pageNumber: nextPage,
      tableName: tableName,
      prefetchNext: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mushafPageMeta = context.select<MushafPageMetaState, MushafPageMetaEntity?>(
          (s) => s.getPageMetaByPage(_pageNumber),
    );

    final translationState = context.select<MushafPageMetaState, bool>(
          (s) => s.translationState,
    );

    final lines = context.select<PageLayoutState, List<LayoutEntity>>(
          (s) => s.getPageLines(_pageNumber),
    );

    final layoutIsLoading = context.select<PageLayoutState, bool>(
          (s) => s.isPageLoading(_pageNumber),
    );

    final layoutError = context.select<PageLayoutState, Object?>(
          (s) => s.getPageError(_pageNumber),
    );

    final ayahs = context.select<AyahByAyahState, List<AyahByAyahEntity>>(
          (s) => s.getPageAyahs(
        pageNumber: _pageNumber,
        tableName: tableName,
      ),
    );

    final ayahIsLoading = context.select<AyahByAyahState, bool>(
          (s) => s.isPageLoading(
        pageNumber: _pageNumber,
        tableName: tableName,
      ),
    );

    final ayahError = context.select<AyahByAyahState, Object?>(
          (s) => s.getPageError(
        pageNumber: _pageNumber,
        tableName: tableName,
      ),
    );

    Widget content;

    if (translationState) {
      if (ayahError != null) {
        content = Center(
          child: Text('${AppStrings.errorLoad} $ayahError'),
        );
      } else if (ayahIsLoading && ayahs.isEmpty) {
        content = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (ayahs.isEmpty) {
        content = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        content = AyahByAyahList(
          ayahsPage: ayahs,
        );
      }
    } else {
      if (layoutError != null) {
        content = Center(
          child: Text('${AppStrings.errorLoad} $layoutError'),
        );
      } else if (layoutIsLoading && lines.isEmpty) {
        content = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else if (lines.isEmpty) {
        content = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        content = _MushafPageView(
          pageNumber: _pageNumber,
          lines: lines,
          fontFamilyForLine: _fontFamilyForLine,
          fontSizeForLine: _fontSizeForLine,
        );
      }
    }

    return Column(
      children: [
        if (!translationState) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              top: kToolbarHeight,
              right: 8,
            ),
            child: Row(
              children: [
                Text('${AppStrings.surah} ${mushafPageMeta?.nameTranscription ?? ''}'),
                const Expanded(child: SizedBox()),
                Text('${AppStrings.juz.toLowerCase()} ${mushafPageMeta?.juzNumber ?? ''}'),
                Text(mushafPageMeta?.hizbNumber == null ? '' : ', ${AppStrings.hizb.toLowerCase()} ${mushafPageMeta!.hizbNumber}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: content,
          ),
        ),
        if (!translationState) Text('$_pageNumber'),
      ],
    );
  }

  String _fontFamilyForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return AppStrings.fontSurahName;
      case LineType.basmallah:
        return AppStrings.fontUthmanicHafs;
      case LineType.ayah:
        return MushafFontLoader.instance.familyForPage(_pageNumber);
    }
  }

  double _fontSizeForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return 28;
      case LineType.basmallah:
        return 28;
      case LineType.ayah:
        return 28;
    }
  }
}

class _MushafPageView extends StatelessWidget {
  const _MushafPageView({
    required this.pageNumber,
    required this.lines,
    required this.fontFamilyForLine,
    required this.fontSizeForLine,
  });

  final int pageNumber;
  final List<LayoutEntity> lines;
  final String Function(LayoutEntity line) fontFamilyForLine;
  final double Function(LayoutEntity line) fontSizeForLine;

  String _textForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        final surahNumber = line.surahNumber;
        if (surahNumber == null) {
          return line.surahNameText;
        }
        return SurahLigatures.surahNameByNumber(surahNumber);

      case LineType.basmallah:
        return line.lineText;

      case LineType.ayah:
        return line.lineText;
    }
  }

  List<FontFeature>? _fontFeaturesForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return const [
          FontFeature.enable('liga'),
          FontFeature.enable('clig'),
          FontFeature.enable('calt'),
        ];
      case LineType.basmallah:
      case LineType.ayah:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int lineCount = lines.isEmpty ? 15 : lines.length;
        final double pageHeight = constraints.maxHeight;
        final double lineSlotHeight = pageHeight / lineCount;

        return Column(
          children: List.generate(lines.length, (index) {
            final line = lines[index];
            final String text = _textForLine(line);

            return SizedBox(
              height: lineSlotHeight,
              width: double.infinity,
              child: Padding(
                padding: _horizontalPaddingForLine(line),
                child: Align(
                  alignment: line.isCentered ? Alignment.center : Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: line.isCentered ? Alignment.center : Alignment.centerRight,
                    child: Text(
                      text,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      textDirection: TextDirection.rtl,
                      textAlign: line.isCentered ? TextAlign.center : TextAlign.right,
                      style: TextStyle(
                        fontFamily: fontFamilyForLine(line),
                        fontSize: fontSizeForLine(line),
                        fontFeatures: _fontFeaturesForLine(line),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  EdgeInsets _horizontalPaddingForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return const EdgeInsets.symmetric(horizontal: 40);
      case LineType.basmallah:
        return const EdgeInsets.symmetric(horizontal: 32);
      case LineType.ayah:
        return const EdgeInsets.symmetric(horizontal: 8);
    }
  }
}