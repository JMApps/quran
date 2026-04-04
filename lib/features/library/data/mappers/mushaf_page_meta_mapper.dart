import '../../domain/entities/mushaf_page_meta_entity.dart';
import '../models/mushaf_page_meta_model.dart';

extension MushafPageMetaMapperX on MushafPageMetaModel {
  MushafPageMetaEntity toEntity() => MushafPageMetaEntity(
    pageNumber: pageNumber,
    nameTranscription: nameTranscription,
    juzNumber: juzNumber,
    hizbNumber: hizbNumber,
  );
}
