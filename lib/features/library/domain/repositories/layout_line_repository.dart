
import '../entities/layout_line_entity.dart';

abstract class LayoutLineRepository {
  Future<List<LayoutLineEntity>> getLinesByPage({required int pageNumber});
}