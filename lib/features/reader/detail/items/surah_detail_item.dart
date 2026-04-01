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
      await MushafFontLoader.instance.loadPageFont(_pageNumber);
      if (!mounted) return;
      await context.read<PageLayoutState>().loadPageLines(_pageNumber);
      if (!mounted) return;
      await context.read<AyahByAyahState>().loadPageAyahs(
        pageNumber: _pageNumber,
        tableName: tableName,
      );
    });
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
          (s) => s.isLoading,
    );
    final layoutError = context.select<PageLayoutState, Object?>(
          (s) => s.error,
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
      } else if (ayahIsLoading || ayahs.isEmpty) {
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
      } else if (layoutIsLoading || lines.isEmpty) {
        content = const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        content = content = LayoutBuilder(
          builder: (context, constraints) {
            final double pageHeight = constraints.maxHeight;
            final double lineSlotHeight = pageHeight / lines.length;

            return Column(
              children: List.generate(lines.length, (index) {
                final line = lines[index];

                final String text = switch (line.lineType) {
                  LineType.surahName => line.surahNameText,
                  LineType.basmallah => line.lineText,
                  LineType.ayah => line.lineText,
                };

                return SizedBox(
                  height: lineSlotHeight,
                  width: double.infinity,
                  child: Align(
                    alignment: line.isCentered ? Alignment.center : Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: line.isCentered ? Alignment.center : Alignment.center,
                        child: Text(
                          text,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          textDirection: TextDirection.rtl,
                          textAlign:
                          line.isCentered ? TextAlign.center : TextAlign.center,
                          style: TextStyle(
                            fontFamily: _fontFamilyForLine(line),
                            fontSize: _fontSizeForLine(line),
                            height: 1.0,
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
    }

    return Column(
      children: [
        if (!translationState)...[
          Padding(
            padding: const EdgeInsets.only(left: 8, top: kToolbarHeight, right: 8),
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
        Expanded(child: content),
        if (!translationState) Text('$_pageNumber'),
      ],
    );
  }

  String _fontFamilyForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return 'surah_name';
      case LineType.basmallah:
        return 'basmallah';
      case LineType.ayah:
        return MushafFontLoader.instance.familyForPage(_pageNumber);
    }
  }

  double _fontSizeForLine(LayoutEntity line) {
    switch (line.lineType) {
      case LineType.surahName:
        return 24;
      case LineType.basmallah:
        return 30;
      case LineType.ayah:
        return 32;
    }
  }
}