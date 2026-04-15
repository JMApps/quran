import '../../domain/entities/page_meta_entity.dart';
import '../models/page_meta_model.dart';

extension PageMetaMapperX on PageMetaModel {
  PageMetaEntity toEntity() => PageMetaEntity(
    pageNumber: pageNumber,
    surahNumber: surahNumber,
    juzNumber: juzNumber,
    hizbNumber: hizbNumber,
  );
}
