import '../entities/hizb_entity.dart';

abstract class HizbRepository {

  Future<List<HizbEntity>> getAllHizbs();

  Future<HizbEntity?> getHizbByPage({required int pageNumber});
}