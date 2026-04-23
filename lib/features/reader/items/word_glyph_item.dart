import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/word_glyph_entity.dart';
import '../../library/presentation/state/selected_ayah_state.dart';

class WordGlyphItem extends StatelessWidget {
  const WordGlyphItem({
    super.key,
    required this.layoutModel,
  });

  final LayoutEntity layoutModel;

  bool get _isSpecialPage => layoutModel.pageNumber == 1 || layoutModel.pageNumber == 2;

  bool get _isFixedRender =>
      _isSpecialPage ||
      layoutModel.lineType == LineType.surahName ||
      layoutModel.lineType == LineType.basmallah;

  bool get _isSurah9 => layoutModel.surahNumber == 9;

  bool get _shouldHide {
    if (_isSurah9 && layoutModel.lineType == LineType.basmallah) return true;
    if (layoutModel.pageNumber == 1 && layoutModel.lineType == LineType.surahName) return true;
    return false;
  }

  Alignment get _alignment {
    if (_isFixedRender) return Alignment.center;
    return layoutModel.isCentered ? Alignment.center : Alignment.centerRight;
  }

  TextAlign get _textAlign {
    if (_isFixedRender) return TextAlign.center;
    return layoutModel.isCentered ? TextAlign.center : TextAlign.start;
  }

  String get _fontFamily => switch (layoutModel.lineType) {
    LineType.surahName => AppStrings.fontSurahName,
    LineType.basmallah => 'P1',
    _ => 'P${layoutModel.pageNumber}',
  };

  double _fontSize(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final deviceTh = isLandscape ? size.width : size.height;

    final ayahFontSize = _isSpecialPage ? deviceTh * 0.030 : (isLandscape ? deviceTh * 0.060 : deviceTh * 0.030);

    switch (layoutModel.lineType) {
      case LineType.surahName:
        if (_isSpecialPage) return deviceTh * 0.035;
        return isLandscape ? deviceTh * 0.060 : deviceTh * 0.040;
      case LineType.basmallah:
        if (_isSpecialPage) return deviceTh * 0.030;
        return isLandscape ? deviceTh * 0.060 : deviceTh * 0.030;
      default:
        return ayahFontSize;
    }
  }

  String get _lineText => switch (layoutModel.lineType) {
    LineType.surahName => AppStrings.surahNameByNumber(layoutModel.surahNumber!),
    LineType.basmallah => AppStrings.basmallahGlyph.split('').join('\u200A'),
    _ => layoutModel.words.map((e) => e.glyph).where((e) => e.isNotEmpty).join('\u200A'),
  };

  double get _lineHeight {
    if (_isSpecialPage) return 1.75;
    return switch (layoutModel.lineType) {
      LineType.surahName => 1.75,
      LineType.basmallah => 1.35,
      _ => 2.0,
    };
  }

  double get _bottomPadding {
    if (_isSpecialPage) return 0;
    final t = layoutModel.lineType;
    return (t == LineType.surahName || t == LineType.basmallah) ? 3.5 : 0;
  }

  // Группируем слова по ayahNumber, сохраняя порядок
  List<({int surahNumber, int ayahNumber, List<WordGlyphEntity> words})> get _ayahSegments {
    final segments = <({int surahNumber, int ayahNumber, List<WordGlyphEntity> words})>[];
    for (final word in layoutModel.words) {
      if (segments.isNotEmpty && segments.last.ayahNumber == word.ayahNumber) {
        segments.last.words.add(word);
      } else {
        segments.add((
          surahNumber: word.surahNumber,
          ayahNumber: word.ayahNumber,
          words: [word],
        ));
      }
    }
    return segments;
  }

  Widget _buildChild(TextStyle style, ColorScheme appColors, SelectedAyahState selectedState) {
    // Специальные страницы: surahName и basmallah — без выделения,
    // ayah — с выделением через сегментированный row
    if (_isSpecialPage) {
      switch (layoutModel.lineType) {
        case LineType.surahName:
          return _buildSurahName(style, appColors);
        case LineType.basmallah:
          return _buildBasmallah(style);
        default:
          return _buildSegmentedRow(style, appColors, selectedState);
      }
    }

    if (!_isFixedRender) return _buildSegmentedRow(style, appColors, selectedState);

    switch (layoutModel.lineType) {
      case LineType.basmallah:
        return _buildBasmallah(style);
      case LineType.surahName:
        return _buildSurahName(style, appColors);
      default:
        return _buildFixedText(style);
    }
  }

  // Строка аята разбитая на сегменты по ayahNumber
  Widget _buildSegmentedRow(TextStyle style, ColorScheme appColors, SelectedAyahState selectedState) {
    final segments = _ayahSegments;

    // Если один аят на строке — простой путь без лишних виджетов
    if (segments.length == 1) {
      final seg = segments.first;
      final isSelected = selectedState.isSelected(seg.surahNumber, seg.ayahNumber);
      final text = seg.words.map((e) => e.glyph).where((e) => e.isNotEmpty).join('\u200A');

      return GestureDetector(
        onLongPress: () => selectedState.select(seg.surahNumber, seg.ayahNumber),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? appColors.primary.withAlpha(50) : Colors.transparent,
            borderRadius: AppStyles.mainBorder,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: _alignment,
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: _textAlign,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: style,
            ),
          ),
        ),
      );
    }

    // Несколько аятов на одной строке — сегментированный Row
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: _alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: segments.map((seg) {
          final isSelected = selectedState.isSelected(seg.surahNumber, seg.ayahNumber);
          final text = seg.words.map((e) => e.glyph).where((e) => e.isNotEmpty).join('\u200A');

          return GestureDetector(
            onLongPress: () => selectedState.select(seg.surahNumber, seg.ayahNumber),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? appColors.primary.withAlpha(50) : Colors.transparent,
                borderRadius: AppStyles.mainBorder,
              ),
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: style,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBasmallah(TextStyle style) {
    return IntrinsicWidth(
      child: Text(
        _lineText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }

  Widget _buildSurahName(TextStyle style, ColorScheme appColors) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(appColors.primary, BlendMode.srcIn),
          image: const AssetImage('assets/pictures/s_header.png'),
        ),
      ),
      child: Text(
        _lineText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }

  Widget _buildFixedText(TextStyle style) {
    return Text(
      _lineText,
      textDirection: TextDirection.rtl,
      textAlign: _textAlign,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldHide) return const SizedBox.shrink();

    final appColors = Theme.of(context).colorScheme;
    final isFixed = _isFixedRender;
    final selectedState = context.watch<SelectedAyahState>();

    final style = TextStyle(
      fontFamily: _fontFamily,
      fontSize: _fontSize(context),
      height: _lineHeight,
      color: appColors.onSurface,
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: _bottomPadding,
        left: isFixed ? 0 : 14,
        right: isFixed ? 0 : 14,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: _alignment,
          child: _buildChild(style, appColors, selectedState),
        ),
      ),
    );
  }
}
