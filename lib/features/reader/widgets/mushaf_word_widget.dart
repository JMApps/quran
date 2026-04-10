import 'package:flutter/material.dart';

import '../../library/domain/entities/word_glyph_entity.dart';

class MushafWordWidget extends StatelessWidget {
  const MushafWordWidget({
    super.key,
    required this.word,
    required this.fontFamily,
    required this.fontSize,
    this.isHighlighted = false,
    this.highlightColor,
    this.onTap,
  });

  final WordGlyphEntity word;
  final String fontFamily;
  final double fontSize;
  final bool isHighlighted;
  final Color? highlightColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme;
    final textWidget = Text(
      word.text,
      textDirection: .rtl,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: 1.8,
        color: isHighlighted ? (highlightColor ?? appColors.primary) : Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onLongPress: onTap,
        behavior: .opaque,
        child: Container(
          decoration: isHighlighted ? BoxDecoration(
            color: (highlightColor ?? appColors.primary).withValues(alpha: 0.12),
            borderRadius: .circular(4),
          ) : null,
          padding: const .symmetric(horizontal: 1),
          child: textWidget,
        ),
      );
    }

    return Padding(
      padding: const .symmetric(horizontal: 0.5),
      child: textWidget,
    );
  }
}