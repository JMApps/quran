import '../entities/surah_entity.dart';

abstract class SurahRepository {
  Future<List<SurahEntity>> getAllSurahs();

  /// Сура, которая актуальна для страницы (последняя по start_page_number <= page)
  Future<SurahEntity?> getSurahByPage({required int pageNumber});
}