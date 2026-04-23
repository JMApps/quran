import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/core/theme/app_styles.dart';

import '../../../core/strings/app_strings.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/domain/entities/word_glyph_entity.dart';
import '../../library/presentation/state/selected_ayah_state.dart';
import '../widgets/segment.dart';

class WordGlyphItem extends StatelessWidget {
  WordGlyphItem({
    super.key,
    required this.layoutModel,
  }) : _segments = _buildSegments(layoutModel.words);

  final LayoutEntity layoutModel;
  final List<Segment> _segments;

  static List<Segment> _buildSegments(List<WordGlyphEntity> words) {
    final out = <Segment>[];
    int? currentAyah;
    int? currentSurah;
    final buffer = <WordGlyphEntity>[];

    void flush() {
      if (buffer.isEmpty) return;
      out.add(Segment(
        surahNumber: currentSurah!,
        ayahNumber: currentAyah!,
        text: buffer.map((w) => w.glyph).where((g) => g.isNotEmpty).join('\u200A'),
      ));
      buffer.clear();
    }

    for (final word in words) {
      if (currentAyah != null && word.ayahNumber != currentAyah) {
        flush();
      }
      currentAyah = word.ayahNumber;
      currentSurah = word.surahNumber;
      buffer.add(word);
    }
    flush();
    return out;
  }

  double get _fontSize => switch (layoutModel.lineType) {
    LineType.basmallah => 26.0,
    LineType.surahName => 26.0,
    _ => 26.0,
  };

  String get _fontFamily => switch (layoutModel.lineType) {
    LineType.surahName => AppStrings.fontSurahName,
    LineType.basmallah => 'P1',
    _ => 'P${layoutModel.pageNumber}',
  };

  double get _fontHeight => switch (layoutModel.lineType) {
    LineType.basmallah => 1.75,
    LineType.surahName => 1.75,
    _ => 1.90,
  };

  String get _lineText => switch (layoutModel.lineType) {
    LineType.surahName => AppStrings.surahNameByNumber(layoutModel.surahNumber!),
    LineType.basmallah => AppStrings.basmallahGlyph,
    _ => layoutModel.words.map((e) => e.glyph).where((e) => e.isNotEmpty).join('\u200A'),
  };

  Widget _buildBasmallah() {
    return IntrinsicWidth(
      child: Text(
        _lineText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: _fontFamily,
          fontSize: _fontSize,
          height: _fontHeight,
        ),
      ),
    );
  }

  Widget _buildSurahName(Color color) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          image: const AssetImage('assets/pictures/s_header.png'),
        ),
      ),
      child: Text(
        _lineText,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: _fontFamily,
          fontSize: _fontSize,
          height: _fontHeight,
        ),
      ),
    );
  }

  Widget _buildSegmentedRow(SelectedAyahState selectedState, Color primaryColor) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: _segments.map((seg) {
          final isSelected = selectedState.isSelected(seg.surahNumber, seg.ayahNumber);
          return GestureDetector(
            onLongPress: () => selectedState.select(seg.surahNumber, seg.ayahNumber),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withAlpha(50) : Colors.transparent,
                borderRadius: AppStyles.mainBorder,
              ),
              child: Text(
                seg.text,  // ← уже готовая строка
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: _fontSize,
                  height: _fontHeight,
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    switch (layoutModel.lineType) {
      case LineType.surahName:
        return _buildSurahName(appColors.primary);
      case LineType.basmallah:
        return _buildBasmallah();
      default:
        return _buildSegmentedRow(context.watch<SelectedAyahState>(), appColors.primary); // обычный аят
    }
  }
}
