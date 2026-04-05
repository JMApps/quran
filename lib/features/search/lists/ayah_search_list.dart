import 'package:flutter/material.dart';

import '../../../core/theme/app_styles.dart';
import '../../library/domain/entities/ayah_by_ayah_entity.dart';
import '../items/search_ayah_item.dart';

class AyahSearchList extends StatelessWidget {
  const AyahSearchList({
    super.key,
    required this.searchResultList,
    required this.query,
  });

  final List<AyahByAyahEntity> searchResultList;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: AppStyles.miniPadding,
        itemCount: searchResultList.length,
        itemBuilder: (context, index) {
          final AyahByAyahEntity ayahModel = searchResultList[index];
          return SearchAyahItem(
            ayahModel: ayahModel,
            index: index,
            query: query,
          );
        },
      ),
    );
  }
}