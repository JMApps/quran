import '../entities/ayah_word_entity.dart';
import '../repositories/ayah_word_repository.dart';

class AyahWordUseCase {
  final AyahWordRepository _wordRepository;

  const AyahWordUseCase(this._wordRepository);

  Future<List<AyahWordEntity>> getWordsByRange({required int fromId, required int toId}) async {
    return await _wordRepository.getWordsByRange(fromId: fromId, toId: toId);
  }
}