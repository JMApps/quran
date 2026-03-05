import '../entities/surah_name_entity.dart';

abstract class SurahNameRepository {
  Future<List<SurahNameEntity>> getAllSurahs();

  Future<SurahNameEntity?> getSurahByPage({required int pageNumber});

  Future<SurahNameEntity?> getSurahByNumber({required int surahNumber});
}