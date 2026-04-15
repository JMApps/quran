import '../entities/surah_name_entity.dart';

abstract class SurahNameRepository {
  Future<List<SurahNameEntity>> getAllSurahs({
    required String languageCode,
  });
}
