import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_strings.dart';
import '../../../domain/entities/line_type.dart';
import '../../../domain/entities/mushaf_page_vm.dart';
import '../../state/mushaf_reader_state.dart';

class SurahDetailPage extends StatefulWidget {
  const SurahDetailPage({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // загружаем страницу один раз при входе
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MushafReaderState>().loadPage(widget.pageNumber);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MushafReaderState>();
    final pageVm = state.getPageFromCache(state.currentPage);

    return Scaffold(
      appBar: AppBar(
        title: Text('Стр. ${state.currentPage}'),
        centerTitle: true,
      ),
      body: state.loading && pageVm == null
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && pageVm == null
          ? Center(child: Text('Ошибка: ${state.error}'))
          : _PageView(
              controller: _scroll,
              page: pageVm!,
            ),
      floatingActionButton: _PageNavFab(
        onPrev: () => _goTo(state.currentPage - 1),
        onNext: () => _goTo(state.currentPage + 1),
      ),
    );
  }

  void _goTo(int page) {
    if (page < 1 || page > 604) return;
    context.read<MushafReaderState>().loadPage(page);
    _scroll.jumpTo(0);
  }
}

class _PageView extends StatelessWidget {
  const _PageView({
    required this.controller,
    required this.page,
  });

  final ScrollController controller;
  final MushafPageVm page;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // ШАПКА: слева сура (визуально), справа джуз (визуально)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      page.surahTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  'ج ${page.juzNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // СТРОКИ
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: page.lines.length,
              itemBuilder: (context, index) {
                final line = page.lines[index];
                return _MushafLine(line: line);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MushafLine extends StatelessWidget {
  const _MushafLine({required this.line});

  final MushafPageLineVm line;

  @override
  Widget build(BuildContext context) {
    final isCentered = line.line.isCentered;

    String text;

    if (line.line.lineType == LineType.surahName) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            line.customText ?? '',
            style: const TextStyle(
              fontFamily: AppStrings.fontUthmanicHafs,
              fontSize: 30,
              height: 2.0,
            ),
          ),
        ),
      );
    }

    if (line.customText != null) {
      text = line.customText!;
    } else {
      final buffer = StringBuffer();
      for (int i = 0; i < line.words.length; i++) {
        final word = line.words[i];

        // Если это номер аята (состоит только из арабских цифр)
        final isAyahNumber = RegExp(r'^[٠-٩]+$').hasMatch(word.text);

        if (isAyahNumber) {
          buffer.write(' ${word.text}');
        } else {
          if (i != 0) buffer.write(' ');
          buffer.write(word.text);
        }
      }
      text = buffer.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Align(
        alignment: isCentered ? Alignment.center : Alignment.centerRight,
        child: Text(
          text,
          textAlign: isCentered ? TextAlign.center : TextAlign.right,
          style: const TextStyle(
            fontFamily: AppStrings.fontUthmanicHafs,
            fontSize: 24,
            height: 1.75,
            fontFeatures: [
              FontFeature.enable('liga'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredText extends StatelessWidget {
  const _CenteredText({
    required this.text,
    required this.centered,
  });

  final String text;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: centered ? Alignment.center : Alignment.centerRight,
        child: Text(
          text,
          textAlign: centered ? TextAlign.center : TextAlign.right,
          style: const TextStyle(
            fontSize: 22,
            height: 1.6,
            fontFamily: AppStrings.fontUthmanicHafs,
          ),
        ),
      ),
    );
  }
}

class _PageNavFab extends StatelessWidget {
  const _PageNavFab({required this.onPrev, required this.onNext});

  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'prev',
          onPressed: onPrev,
          child: const Icon(Icons.chevron_left),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.small(
          heroTag: 'next',
          onPressed: onNext,
          child: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
