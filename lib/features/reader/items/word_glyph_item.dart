import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/strings/app_strings.dart';
import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/layout_entity.dart';
import '../../library/domain/entities/line_type.dart';
import '../../library/presentation/state/selected_ayah_state.dart';

class WordGlyphItem extends StatelessWidget {
  const WordGlyphItem({super.key, required this.layoutModel});
  final LayoutEntity layoutModel;

  String get _fontFamily => switch (layoutModel.lineType) {
    LineType.surahName => AppStrings.fontSurahName,
    LineType.basmallah => 'P1',
    _ => 'P${layoutModel.pageNumber}',
  };

  double get _fontHeight => layoutModel.lineType == LineType.ayah ? 2.15 : 1.75;

  TextStyle get _style => TextStyle(fontFamily: _fontFamily, fontSize: 24.0, height: _fontHeight, letterSpacing: 0);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return switch (layoutModel.lineType) {
      LineType.surahName => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(primary, .srcIn),
            image: const AssetImage('assets/pictures/s_header.png'),
          ),
        ),
        child: Text(
          AppStrings.surahNameByNumber(layoutModel.surahNumber!),
          textDirection: .rtl,
          textAlign: .center,
          style: _style,
        ),
      ),
      LineType.basmallah => IntrinsicWidth(
        child: Text(
          AppStrings.basmallahGlyph,
          textDirection: .rtl,
          textAlign: .center,
          style: _style,
        ),
      ),
      _ => Row(
        mainAxisSize: .min,
        textDirection: .rtl,
        children: layoutModel.glyphs.map((segment) {
          final selected = context.watch<SelectedAyahState>().isSelected(segment.surahNumber, segment.ayahNumber);
          return GestureDetector(
            onLongPress: () => context.read<SelectedAyahState>().select(segment.surahNumber, segment.ayahNumber),
            child: Container(
              decoration: BoxDecoration(
                color: selected ? primary.withAlpha(50) : Colors.transparent,
                borderRadius: AppStyles.mainBorder,
              ),
              child: Text(segment.glyph, textDirection: .rtl, style: _style),
            ),
          );
        }).toList(growable: false),
      ),
    };
  }
}