import '../entities/ayah_word_entity.dart';

abstract class AyahWordRepository {
  Future<List<AyahWordEntity>> getWordsByRange({
    required int fromId,
    required int toId,
  });
}