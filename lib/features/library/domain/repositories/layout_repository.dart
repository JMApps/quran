
import '../entities/layout_entity.dart';

abstract class LayoutRepository {
  Future<List<LayoutEntity>> getLinesByPage({required int pageNumber});
}