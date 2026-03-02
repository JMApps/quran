import 'package:flutter/material.dart';
import 'package:quran/core/theme/app_strings.dart';
import '../../../domain/entities/surah_detail_vm.dart';

class Mushaf15LinesFromVm extends StatelessWidget {
  const Mushaf15LinesFromVm({
    super.key,
    required this.vm,
    this.horizontalPadding = 20,
    this.verticalPadding = 8,
    this.linesPerPage = 15,
  });

  final SurahDetailPageVm vm;
  final double horizontalPadding;
  final double verticalPadding;
  final int linesPerPage;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final usableHeight = constraints.maxHeight - (verticalPadding * 2);
          final lineHeight = usableHeight / linesPerPage;

          const textHeightFactor = 1.5;
          final fontSize = (lineHeight / textHeightFactor).clamp(16.0, 24.0);

          final baseStyle = TextStyle(
            fontFamily: AppStrings.fontUthmanicHafs,
            fontSize: fontSize,
            height: textHeightFactor,
            color: Theme.of(context).colorScheme.onSurface,
          );

          // ширина строки под расчёт justify (внутри padding)
          final lineWidth = constraints.maxWidth - (horizontalPadding * 2);

          final lines = vm.lines;

          return ClipRect(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(linesPerPage, (i) {
                  if (i >= lines.length) {
                    return SizedBox(height: lineHeight);
                  }

                  final lineVm = lines[i];
                  final isCentered = lineVm.line.isCentered;

                  // 1) customText (например "سورة ..." / "بسم الله") — обычно по центру
                  if (lineVm.customText != null && lineVm.customText!.isNotEmpty) {
                    return SizedBox(
                      height: lineHeight,
                      child: Center(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          text: TextSpan(style: baseStyle, text: lineVm.customText!),
                        ),
                      ),
                    );
                  }

                  // 2) обычные строки — делаем настоящую justify на 1 строку
                  final spans = isCentered
                      ? <InlineSpan>[TextSpan(text: _joinTokensMushaf(lineVm))]
                      : _buildJustifiedLineSpans(
                    lineVm: lineVm,
                    style: baseStyle,
                    maxWidth: lineWidth,
                    textDirection: TextDirection.rtl,
                  );

                  return SizedBox(
                    height: lineHeight,
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textDirection: TextDirection.rtl,
                        textAlign: isCentered ? TextAlign.center : TextAlign.right,
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                        text: TextSpan(style: baseStyle, children: spans),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Реальная single-line justification:
  /// - собираем токены
  /// - считаем где пробел допустим (не перед رقم الآية / علامات الوقف)
  /// - измеряем ширину каждого токена и обычного пробела
  /// - распределяем (maxWidth - contentWidth) по пробелам
  List<InlineSpan> _buildJustifiedLineSpans({
    required SurahDetailLineVm lineVm,
    required TextStyle style,
    required double maxWidth,
    required TextDirection textDirection,
  }) {
    final tokens = lineVm.words.map((w) => w.text).toList();
    if (tokens.isEmpty) return const <InlineSpan>[];

    // Индексы, перед которыми НЕ ставим пробел
    final noSpaceBefore = List<bool>.generate(tokens.length, (i) {
      if (i == 0) return true;
      return _noSpaceBeforeToken(tokens[i]);
    });

    // Пробельных "разрывов" (gaps) = количество мест, где мы реально ставим пробел
    final gapIndices = <int>[];
    for (int i = 1; i < tokens.length; i++) {
      if (!noSpaceBefore[i]) gapIndices.add(i);
    }

    // Если пробелов нет — нечего justify'ить
    if (gapIndices.isEmpty) {
      return <InlineSpan>[TextSpan(text: tokens.join())];
    }

    // Измерения
    double measure(String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: textDirection,
        maxLines: 1,
      )..layout(maxWidth: double.infinity);
      return tp.width;
    }

    final spaceWidth = measure(' ');
    double contentWidth = 0;

    for (int i = 0; i < tokens.length; i++) {
      contentWidth += measure(tokens[i]);
      if (i > 0 && !noSpaceBefore[i]) {
        contentWidth += spaceWidth;
      }
    }

    final extra = maxWidth - contentWidth;

    // Если строка уже шире контейнера — fallback на обычное склеивание (будет clip)
    if (extra <= 0) {
      return <InlineSpan>[TextSpan(text: _joinTokensMushaf(lineVm))];
    }

    final addPerGap = extra / gapIndices.length;

    final spans = <InlineSpan>[];

    for (int i = 0; i < tokens.length; i++) {
      if (i == 0) {
        spans.add(TextSpan(text: tokens[i]));
        continue;
      }

      if (!noSpaceBefore[i]) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(width: spaceWidth + addPerGap),
          ),
        );
      }

      spans.add(TextSpan(text: tokens[i]));
    }

    return spans;
  }

  /// Склейка токенов “как в мусхафе” (fallback и для centered)
  String _joinTokensMushaf(SurahDetailLineVm line) {
    final tokens = line.words.map((w) => w.text).toList();
    if (tokens.isEmpty) return '';

    final sb = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      if (i == 0) {
        sb.write(t);
        continue;
      }
      if (_noSpaceBeforeToken(t)) {
        sb.write(t);
      } else {
        sb.write(' ');
        sb.write(t);
      }
    }
    return sb.toString();
  }

  bool _noSpaceBeforeToken(String t) {
    final s = t.trim();
    if (s.isEmpty) return true;

    const noSpaceBeforeLeading = {
      '،', '؛', '؟', '.', '!', '…',
      'ۚ', 'ۛ', 'ۗ', 'ۙ', 'ۘ', 'ۖ', 'ۜ', '۝',
      '﴿', '﴾',
      'ﴹ', 'ﴺ', 'ﴻ', 'ﴼ', 'ﴽ',
      '۞', '۩',
    };

    final first = s[0];
    if (noSpaceBeforeLeading.contains(first)) return true;

    final isDigitsOnly = RegExp(r'^[\u0660-\u0669\u06F0-\u06F9]+$').hasMatch(s);
    if (isDigitsOnly) return true;

    final looksLikeAyahMarker = RegExp(r'^[﴿۝].+').hasMatch(s);
    if (looksLikeAyahMarker) return true;

    return false;
  }
}