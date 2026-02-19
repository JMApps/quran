import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class WordUseCase {
  final WordRepository _wordRepository;

  const WordUseCase(this._wordRepository);

  Future<List<WordEntity>> getWordsByRange({required int fromId, required int toId}) {
    return _wordRepository.getWordsByRange(fromId: fromId, toId: toId);
  }
}
