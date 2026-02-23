import 'package:flutter/material.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/line_type.dart';
import '../../../domain/usecases/get_page_word_use_case.dart';
import '../../../domain/usecases/layout_line_use_case.dart';
import '../../../domain/usecases/surah_use_case.dart';

class QuranPageItem extends StatelessWidget {
  const QuranPageItem({
    super.key,
    required this.pageNumber,
    required this.layoutLineUseCase,
    required this.getPageWordsUseCase,
    required this.surahUseCase,
  });

  final int pageNumber;

  final LayoutLineUseCase layoutLineUseCase;
  final GetPageWordsUseCase getPageWordsUseCase;
  final SurahUseCase surahUseCase;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PageVm>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        final vm = snap.data!;
        return _QuranPageView(vm: vm);
      },
    );
  }

  Future<_PageVm> _load() async {
    final lines = await layoutLineUseCase.getLinesByPage(pageNumber: pageNumber);
    final wordsById = await getPageWordsUseCase.execute(lines: lines);

    // Чтобы показать surah_name строку, нужен справочник сур
    final surahs = await surahUseCase.getAllSurahs();
    final surahById = {for (final s in surahs) s.surahNumber: s};

    final rendered = <_RenderedLine>[];

    for (final l in lines) {
      switch (l.lineType) {
        case LineType.surahName:
          final s = (l.surahNumber != null) ? surahById[l.surahNumber!] : null;
          rendered.add(
            _RenderedLine(
              type: l.lineType,
              isCentered: true,
              text: s?.nameArabic ?? '',
            ),
          );
          break;

        case LineType.basmallah:
          rendered.add(
            const _RenderedLine(
              type: LineType.basmallah,
              isCentered: true,
              text: '﷽',
            ),
          );
          break;

        case LineType.ayah:
          final first = l.firstWordId;
          final last = l.lastWordId;

          if (first == null || last == null) {
            rendered.add(_RenderedLine(type: l.lineType, isCentered: l.isCentered, text: ''));
            break;
          }

          final buffer = StringBuffer();
          for (int id = first; id <= last; id++) {
            final w = wordsById[id];
            if (w == null) continue;
            if (buffer.isNotEmpty) buffer.write(' ');
            buffer.write(w.text);
          }

          rendered.add(
            _RenderedLine(
              type: l.lineType,
              isCentered: l.isCentered,
              text: buffer.toString(),
            ),
          );
          break;
      }
    }

    return _PageVm(
      pageNumber: pageNumber,
      lines: rendered,
    );
  }
}

class _PageVm {
  final int pageNumber;
  final List<_RenderedLine> lines;

  const _PageVm({
    required this.pageNumber,
    required this.lines,
  });
}

class _RenderedLine {
  final LineType type;
  final bool isCentered;
  final String text;

  const _RenderedLine({
    required this.type,
    required this.isCentered,
    required this.text,
  });
}

class _QuranPageView extends StatelessWidget {
  const _QuranPageView({required this.vm});

  final _PageVm vm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.only(top: 48),
        child: Column(
          children: [
            for (final line in vm.lines)
              Center(
                child: SelectableText(
                  line.text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: AppStrings.fontUthmanicHafs,
                    height: 1.75
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}