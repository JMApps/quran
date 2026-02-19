import '../entities/layout_line_entity.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class GetPageWordsUseCase {
  final WordRepository _wordRepository;

  const GetPageWordsUseCase(this._wordRepository);

  Future<Map<int, WordEntity>> execute({
    required List<LayoutLineEntity> lines,
  }) async {
    // Берём только строки, где реально есть диапазон слов
    final ranged = lines.where((l) => l.firstWordId != null && l.lastWordId != null).toList();

    if (ranged.isEmpty) return {};

    final int fromId = ranged
        .map((l) => l.firstWordId!)
        .reduce((a, b) => a < b ? a : b);

    final int toId = ranged
        .map((l) => l.lastWordId!)
        .reduce((a, b) => a > b ? a : b);

    final words = await _wordRepository.getWordsByRange(fromId: fromId, toId: toId);

    return {for (final w in words) w.id: w};
  }
}
