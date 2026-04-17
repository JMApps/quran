import 'package:flutter/material.dart';

import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';

class WordGlyphItem extends StatelessWidget {
  const WordGlyphItem({
    super.key,
    required this.layoutModel,
    required this.index,
  });

  final LayoutEntity layoutModel;
  final int index;

  bool get _isSpecialPage => layoutModel.pageNumber == 1 || layoutModel.pageNumber == 2;

  bool get _isFixedRender => _isSpecialPage || layoutModel.lineType == LineType.surahName || layoutModel.lineType == LineType.basmallah;

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

  String _fontFamily(LayoutEntity layout) {
    switch (layout.lineType) {
      case LineType.surahName:
        return AppStrings.fontSurahName;
      case LineType.basmallah:
        return AppStrings.fontUthmanicHafs;
      default:
        return 'P${layout.pageNumber}';
    }
  }

  double _fontSize(LayoutEntity layout) {
    switch (layout.lineType) {
      case LineType.surahName:
        return 35;
      case LineType.basmallah:
        return 30;
      default:
        if (_isSpecialPage) return 28;
        return 250;
    }
  }

  String _lineText(LayoutEntity layout) {
    switch (layout.lineType) {
      case LineType.surahName:
        return AppStrings.surahNameByNumber(layoutModel.surahNumber!);
      case LineType.basmallah:
        return '\uFDFD';
      default:
        return layout.words.map((e) => e.glyph).where((e) => e.isNotEmpty).join(' ');
    }
  }

  double _lineHeight(LayoutEntity layout) {
    if (_isSpecialPage) return 1.65;
    switch (layout.lineType) {
      case LineType.surahName:
        return 1.15;
      case LineType.basmallah:
        return 1.45;
      default:
        return 1.85;
    }
  }

  double _topPadding(LayoutEntity layout) {
    if (_isSpecialPage) return 0;
    switch (layout.lineType) {
      case LineType.surahName:
        return 3.5;
      case LineType.basmallah:
        return 3.5;
      default:
        return 0;
    }
  }

  double _bottomPadding(LayoutEntity layout) {
    if (_isSpecialPage) return 0;
    switch (layout.lineType) {
      case LineType.surahName:
        return 3.5;
      case LineType.basmallah:
        return 3.5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldHide) return const SizedBox.shrink();
    final appColors = Theme.of(context).colorScheme;
    final lineText = _lineText(layoutModel);

    final style = TextStyle(
      fontFamily: _fontFamily(layoutModel),
      fontSize: _fontSize(layoutModel),
      height: _lineHeight(layoutModel),
      color: appColors.onSurface,
      letterSpacing: _isSpecialPage ? 0 : -75
    );

    return Padding(
      padding: EdgeInsets.only(
        top: _topPadding(layoutModel),
        bottom: _bottomPadding(layoutModel),
        left: _isFixedRender ? 0 : 14,
        right: _isFixedRender ? 0 : 14,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: _alignment,
          child: _isFixedRender? layoutModel.lineType == LineType.basmallah ? IntrinsicWidth(
            child: Text(
              lineText,
              textDirection: .rtl,
              textAlign: .center,
              style: style,
            ),
          ) : layoutModel.lineType == LineType.surahName ? Text(
            lineText,
            textDirection: .rtl,
            textAlign: .center,
            style: style,
          ) : Text(
            lineText,
            textDirection: .rtl,
            textAlign: _textAlign,
            style: style,
          ) : LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: _alignment,
                child: Directionality(
                  textDirection: .rtl,
                  child: Text(
                    lineText,
                    textDirection: .rtl,
                    textAlign: _textAlign,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: style,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}