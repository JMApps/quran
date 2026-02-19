import '../entities/word_entity.dart';

abstract class WordRepository {
  Future<List<WordEntity>> getWordsByRange({required int fromId, required int toId});
}