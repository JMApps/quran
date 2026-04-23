import '../../library/domain/entities/layout_entity.dart';

class GlyphPageSnapshot {
  const GlyphPageSnapshot({
    required this.isLoaded,
    required this.error,
    required this.lines,
  });

  final bool isLoaded;
  final Object? error;
  final List<LayoutEntity> lines;

  @override
  bool operator ==(Object other) =>
      other is GlyphPageSnapshot &&
      other.isLoaded == isLoaded &&
      other.error == error &&
      identical(
        other.lines,
        lines,
      );

  @override
  int get hashCode => Object.hash(isLoaded, error, identityHashCode(lines));
}
